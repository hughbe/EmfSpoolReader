//
//  EMRI_PRESTARTPAGE.swift
//
//
//  Created by Hugh Bellamy on 09/12/2020.
//

import DataStream

/// [MS-EMF] 2.2.3.6 EMRI_PRESTARTPAGE Record
/// The EMRI_PRESTARTPAGE record specifies the start of encapsulated PostScript (EPS) data.
public struct EMRI_PRESTARTPAGE {
    public let ulID: RecordType
    public let cjSize: UInt32
    public let ulUnused: UInt32
    public let bEPS: UInt32
    
    public init(dataStream: inout DataStream) throws {
        /// ulID (4 bytes): A 32-bit unsigned integer that identifies the type of record.
        /// The value MUST be 0x00000005, from the RecordType (section 2.1.1) enumeration.
        self.ulID = try RecordType(dataStream: &dataStream)
        guard self.ulID == .EMRI_PRESTARTPAGE else {
            throw EmfSpoolReadError.corrupted
        }
        
        /// cjSize (4 bytes): A 32-bit unsigned integer that specifies the size, in bytes, of the data attached to the record.
        /// Each record in EMF spool format MUST be aligned to a multiple of 4 bytes.
        self.cjSize = try dataStream.read(endianess: .littleEndian)
        guard cjSize == 8 else {
            throw EmfSpoolReadError.corrupted
        }
        
        let startPosition = dataStream.position

        /// ulUnused (4 bytes): A 32-bit unsigned integer that is not used. Its value MUST be 0xFFFFFFFF.
        self.ulUnused = try dataStream.read(endianess: .littleEndian)
        
        /// bEPS (4 bytes): A 32-bit unsigned integer that specifies whether EPS printing is enabled. EPS printing is enabled if the
        /// value is nonzero. When EPS printing is enabled, the printer driver is only used to generate a minimum header, and the
        /// rest of the output is generated through PostScript pass-through.
        self.bEPS = try dataStream.read(endianess: .littleEndian)
        
        guard dataStream.position - startPosition == self.cjSize else {
            throw EmfSpoolReadError.corrupted
        }
    }
}
