//
//  PageOffsetRecord.swift
//
//
//  Created by Hugh Bellamy on 09/12/2020.
//

import DataStream
import EmfReader

/// [MS-EMFSPOOL] 2.2.3.2 Page Offset Records
/// The Page Offset records include two record types, and they both have the structure shown as follows.
/// Page offset records specify the location of page content records in the EMF spool format metafile.
/// Page content records are specified in section 2.2.3.1.
public struct PageOffsetRecord {
    public let ulID: RecordType
    public let cjSize: UInt32
    public let startPosition: Int
    public let offset: UInt64
    
    public init(dataStream: inout DataStream) throws {
        self.startPosition = dataStream.position
        
        /// ulID (4 bytes): A 32-bit unsigned integer that identifies the type of record, from the RecordType (section 2.1.1) enumeration.
        /// Value Meaning
        /// EMRI_METAFILE_EXT 0x0000000D Offset to a page content record.
        /// EMRI_BW_METAFILE_EXT 0x0000000E Offset to a page content record that contains only monochrome data.
        let ulID = try RecordType(dataStream: &dataStream)
        guard ulID == .EMRI_METAFILE_EXT ||
                ulID == .EMRI_BW_METAFILE_EXT else {
            throw EmfSpoolReadError.corrupted
        }
        
        self.ulID = ulID
        
        /// cjSize (4 bytes): A 32-bit unsigned integer that specifies the size, in bytes, of the data attached to the record.
        /// The size of each record in EMF spool format MUST be rounded up to a multiple of 4 bytes.
        let cjSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard cjSize == 0x00000008 && cjSize <= dataStream.remainingCount else {
            throw EmfSpoolReadError.corrupted
        }
        
        self.cjSize = cjSize
        
        let startPosition = dataStream.position
        
        /// offset (8 bytes): A 64-bit unsigned integer that specifies the offset, in bytes, from the start of the page offset record to the
        /// start of a page content record. That page content record MUST be located ahead of the corresponding page offset record,
        /// which means that the offset is counted backward in the metafile.
        self.offset = try dataStream.read(endianess: .littleEndian)
        
        guard dataStream.position - startPosition == self.cjSize else {
            throw EmfSpoolReadError.corrupted
        }
    }
}
