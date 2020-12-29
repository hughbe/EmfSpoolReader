//
//  File.swift
//  
//
//  Created by Hugh Bellamy on 09/12/2020.
//

import DataStream

/// [MS-EMF] 2.2.3.5 EMRI_DEVMODE Record
/// The EMRI_DEVMODE record specifies the configuration and capabilities of an output device.
public struct EMRI_DEVMODE {
    public let ulID: RecordType
    public let cjSize: UInt32
    public let devmode: _DEVMODE
    
    public init(dataStream: inout DataStream) throws {
        /// ulID (4 bytes): An unsigned integer that identifies the record type (section 2.1.1).
        /// This value is 0x00000003 for the EMRI_DEVMODE record.
        self.ulID = try RecordType(dataStream: &dataStream)
        
        /// CjSize (4 bytes): An unsigned integer that specifies the size of the Devmode field, in bytes.
        /// Each EMFSPOOL record MUST be aligned to a multiple of 32 bits.
        let cjSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard cjSize >= 0x000000DC && (cjSize % 4) == 0 && cjSize <= dataStream.remainingCount else {
            throw EmfSpoolReadError.corrupted
        }
        
        self.cjSize = cjSize
        
        let startPosition = dataStream.position
        
        /// Devmode (variable): A _DEVMODE structure ([MS-RPRN] section 2.2.2.1), which defines the configuration and capabilities
        /// of an output device.
        self.devmode = try _DEVMODE(dataStream: &dataStream, size: self.cjSize)
        
        guard dataStream.position - startPosition == self.cjSize else {
            throw EmfSpoolReadError.corrupted
        }
    }
}
