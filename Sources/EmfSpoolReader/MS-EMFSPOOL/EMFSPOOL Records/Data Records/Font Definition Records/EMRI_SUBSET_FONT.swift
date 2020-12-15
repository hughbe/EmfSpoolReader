//
//  EMRI_SUBSET_FONT.swift
//
//
//  Created by Hugh Bellamy on 09/12/2020.
//

import DataStream
import EmfReader

/// [MS-EMF] 2.2.3.3.4 EMRI_SUBSET_FONT Record
/// The EMRI_SUBSET_FONT record contains a subset of TrueType and OpenType fonts, which can be merged to form more complete
/// fonts. An EMRI_SUBSET_FONT record defines enough glyph outlines for pages up to the current one.
/// This record and the EMRI_DELTA_FONT (section 2.2.3.3.5) record have similar structures.
public struct EMRI_SUBSET_FONT {
    public let ulID: RecordType
    public let cjSize: UInt32
    public let universalFontId: UniversalFontId
    public let fontData: [UInt8]
    
    public init(dataStream: inout DataStream) throws {
        /// ulID (4 bytes): A 32-bit unsigned integer that identifies the type of record. The value MUST be 0x00000007, which specifies
        /// the EMRI_SUBSET_FONT record type from the RecordType Enumeration (section 2.1.1).
        self.ulID = try RecordType(dataStream: &dataStream)
        guard self.ulID == .EMRI_SUBSET_FONT else {
            throw EmfSpoolReadError.corrupted
        }
        
        /// cjSize (4 bytes): A 32-bit unsigned integer that specifies the size, in bytes, of the data attached to the record.
        /// The size of each record in an EMF spool format file MUST be rounded up to a multiple of 4 bytes.
        let cjSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard cjSize >= 8 && cjSize % 4 == 0 else {
            throw EmfSpoolReadError.corrupted
        }
        
        self.cjSize = cjSize
        
        let startPosition = dataStream.position

        /// UniversalFontId (8 bytes): An EMF UniversalFontId object ([MS-EMF] section 2.2.27) that identifies the font.
        self.universalFontId = try UniversalFontId(dataStream: &dataStream)
        
        /// FontData (variable): The 32-bit-aligned data that contains the definitions of glyphs in the font.
        self.fontData = try dataStream.readBytes(count: Int(self.cjSize) - 8)
        
        try dataStream.readFourByteAlignmentPadding(startPosition: startPosition)
        
        guard dataStream.position - startPosition == self.cjSize else {
            throw EmfSpoolReadError.corrupted
        }
    }
}
