//
//  EMRI_ENGINE_FONT.swift
//
//
//  Created by Hugh Bellamy on 09/12/2020.
//

import DataStream

/// [MS-EMF] 2.2.3.3.1 EMRI_ENGINE_FONT Record
/// The EMRI_ENGINE_FONT record contains embedded TrueType fonts. This record and the EMRI_TYPE1_FONT (section 2.2.3.3.2)
/// record have similar structures.
public struct EMRI_ENGINE_FONT {
    public let ulID: RecordType
    public let cjSize: UInt32
    public let type1ID: UInt32
    public let numFiles: UInt32
    public let fileSizes: [UInt32]
    public let fileContent: [UInt8]
    
    public init(dataStream: inout DataStream) throws {
        /// lID (4 bytes): A 32-bit unsigned integer that identifies the type of record. The value MUST be 0x00000002, which specifies
        /// the EMRI_ENGINE_FONT record type from the RecordType Enumeration (section 2.1.1).
        self.ulID = try RecordType(dataStream: &dataStream)
        guard self.ulID == .EMRI_ENGINE_FONT else {
            throw EmfSpoolReadError.corrupted
        }
        
        /// cjSize (4 bytes): A 32-bit unsigned integer that specifies the size, in bytes, of the data attached to the record.
        /// The size of each record in an EMF spool format file MUST be rounded up to a multiple of 4 bytes.
        let cjSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard cjSize >= 0x00000008 && cjSize % 4 == 0 && cjSize <= dataStream.remainingCount else {
            throw EmfSpoolReadError.corrupted
        }
        
        self.cjSize = cjSize
        
        let startPosition = dataStream.position

        /// Type1ID (4 bytes): A 32-bit unsigned integer. The value MUST be 0x00000000, to indicate a TrueType.
        self.type1ID = try dataStream.read(endianess: .littleEndian)
        guard self.type1ID == 0x00000000 else {
            throw EmfSpoolReadError.corrupted
        }
        
        /// NumFiles (4 bytes): A 32-bit unsigned integer that specifies the number of files attached to this record.
        self.numFiles = try dataStream.read(endianess: .littleEndian)
        guard 0x00000008 + self.numFiles * 0x00000004 <= cjSize else {
            throw EmfSpoolReadError.corrupted
        }
        
        /// FileSizes (variable): Variable number of 32-bit unsigned integers that define the sizes of the files attached to this record.
        var fileSizes: [UInt32] = []
        fileSizes.reserveCapacity(Int(self.numFiles))
        for _ in 0..<self.numFiles {
            fileSizes.append(try dataStream.read(endianess: .littleEndian))
        }
        
        self.fileSizes = fileSizes
        
        /// AlignBuffer (variable): Up to 7 bytes, to make the data that follows 64-bit aligned.
        try dataStream.readEightByteAlignmentPadding(startPosition: startPosition)
        
        /// FileContent (variable): Variable-size, 32-bit aligned data that represents the definitions of glyphs in the font.
        /// The content is in TrueType format.
        let fileContentSize = Int(self.cjSize) - (dataStream.position - startPosition)
        if fileContentSize > 0 {
            self.fileContent = try dataStream.readBytes(count: Int(fileContentSize))
        } else {
            self.fileContent = []
        }
        
        try dataStream.readFourByteAlignmentPadding(startPosition: startPosition)
        
        guard dataStream.position - startPosition == self.cjSize else {
            throw EmfSpoolReadError.corrupted
        }
    }
}
