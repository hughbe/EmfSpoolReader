//
//  FontOffsetRecord.swift
//
//
//  Created by Hugh Bellamy on 09/12/2020.
//

import DataStream

/// [MS-EMF] 2.2.3.4 Font Offset Records
/// Font Offset records are of six types, and they all have the structure shown as follows. Font offset records specify offsets to embedded
/// font definition records in an EMF spool format metafile.
public struct FontOffsetRecord {
    public let ulID: RecordType
    public let cjSize: UInt32
    public let offsetLow: UInt32
    public let offsetHigh: UInt32
    
    public init(dataStream: inout DataStream) throws {
        /// ulID (4 bytes): A 32-bit unsigned integer that identifies the type of record, from the RecordType (section 2.1.1) enumeration.
        /// Value Meaning
        /// EMRI_ENGINE_FONT_EXT 0x0000000F This type of record specifies an offset to a TrueType font within a page content
        /// record.
        /// EMRI_TYPE1_FONT_EXT 0x00000010 This type of record specifies an offset to a PostScript Type 1 font within a page
        /// content record.
        /// EMRI_DESIGNVECTOR_EXT 0x00000011 This type of record specifies an offset to a TrueType font design vector within a
        /// page content record.
        /// EMRI_SUBSET_FONT_EXT 0x00000012 This type of record specifies an offset to embedded subset fonts within a page
        /// content record.
        /// EMRI_DELTA_FONT_EXT 0x00000013 This type of record specifies an offset to embedded delta fonts within a page
        /// content record.
        /// EMRI_EMBED_FONT_EXT 0x00000015 This type of record specifies an offset to embedded font identifiers within a page
        /// content record.
        let ulID = try RecordType(dataStream: &dataStream)
        guard ulID == .EMRI_ENGINE_FONT_EXT ||
                ulID == .EMRI_TYPE1_FONT_EXT ||
                ulID == .EMRI_DESIGNVECTOR_EXT ||
                ulID == .EMRI_SUBSET_FONT_EXT ||
                ulID == .EMRI_DELTA_FONT_EXT ||
                ulID == .EMRI_EMBED_FONT_EXT else {
            throw EmfSpoolReadError.corrupted
        }
        
        self.ulID = ulID
        
        /// cjSize (4 bytes): A 32-bit unsigned integer that specifies the size, in bytes, of the data attached to the record.
        /// The size of each record in EMF spool format MUST be aligned to a multiple of 4 bytes.
        let cjSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard cjSize == 0x00000008 && cjSize <= dataStream.remainingCount else {
            throw EmfSpoolReadError.corrupted
        }
        
        self.cjSize = cjSize
        
        let startPosition = dataStream.position

        /// OffsetLow (4 bytes): The lower 32 bits of a 64-bit unsigned integer that contains the font offset.
        self.offsetLow = try dataStream.read(endianess: .littleEndian)
        
        /// OffsetHigh (4 bytes): The upper 32 bits of a 64-bit unsigned integer that contains the font offset.
        self.offsetHigh = try dataStream.read(endianess: .littleEndian)
        
        guard dataStream.position - startPosition == self.cjSize else {
            throw EmfSpoolReadError.corrupted
        }
    }
}
