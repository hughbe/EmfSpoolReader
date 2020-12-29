//
//  EMRI_TYPE1_FONT.swift
//
//
//  Created by Hugh Bellamy on 09/12/2020.
//

import DataStream

/// [MS-EMF] 2.2.3.3.2 EMRI_TYPE1_FONT Record
/// The EMRI_TYPE1_FONT record contains embedded PostScript Type 1 fonts. This record and the EMRI_ENGINE_FONT (section
/// 2.2.3.3.1) record have similar structures.
public struct EMRI_TYPE1_FONT {
    public let ulID: RecordType
    public let cjSize: UInt32
    public let type1ID: UInt32
    public let numFiles: UInt32
    public let fileEndOffs: [UInt32]
    public let fileContent: [UInt8]
    
    public init(dataStream: inout DataStream) throws {
        /// lID (4 bytes): A 32-bit unsigned integer that identifies the type of record. The value MUST be 0x00000004, which specifies
        /// the EMRI_TYPE1_FONT record type from the RecordType Enumeration (section 2.1.1).
        self.ulID = try RecordType(dataStream: &dataStream)
        guard self.ulID == .EMRI_TYPE1_FONT else {
            throw EmfSpoolReadError.corrupted
        }
        
        /// cjSize (4 bytes): A 32-bit unsigned integer that specifies the size, in bytes, of this record, not including the ulID and cjSize
        /// fields. The size of each record in EMF spool format MUST be rounded up to a multiple of 4 bytes.
        let cjSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard cjSize >= 0x00000008 && cjSize % 4 == 0 && cjSize <= dataStream.remainingCount else {
            throw EmfSpoolReadError.corrupted
        }
        
        self.cjSize = cjSize
        
        let startPosition = dataStream.position

        /// Type1ID (4 bytes): A 32-bit unsigned integer that SHOULD be 0x00000000 and MUST be ignored.<8>
        self.type1ID = try dataStream.read(endianess: .littleEndian)
        
        /// NumFiles (4 bytes): A 32-bit unsigned integer that specifies the number of files included in this record.
        /// This value MUST NOT be zero.
        let numFiles: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard numFiles != 0 && 0x00000008 + numFiles * 0x00000004 <= cjSize else {
            throw EmfSpoolReadError.corrupted
        }
        
        self.numFiles = numFiles
        
        /// FileEndOffs (variable): An array of 32-bit unsigned integers that specify the locations of the font files in this record.
        /// For each font file, this value is the byte offset of the end of that file, starting from the beginning of the first file.
        /// Thus, the first FileEndOffs value is the size, in bytes, of the first file; the second value is the sum of the sizes of the first
        /// and second files, and so on.
        /// The FileEndOffs values are limited as follows:
        /// FileEndOffs[0] < FileEndOffs[1] < ... < FileEndOffs[NumFiles - 1] <= (cjSize – (8 + (nFiles
        /// * 4))
        /// Each offset value MUST be a multiple of 4 bytes, and each file MUST have a size greater than zero.
        var fileEndOffs: [UInt32] = []
        fileEndOffs.reserveCapacity(Int(self.numFiles))
        for _ in 0..<self.numFiles {
            let fileEndOff: UInt32 = try dataStream.read(endianess: .littleEndian)
            guard fileEndOff > 0 && fileEndOff % 4 == 0 else {
                throw EmfSpoolReadError.corrupted
            }

            fileEndOffs.append(fileEndOff)
        }
        
        self.fileEndOffs = fileEndOffs
        
        /// Padding (4 bytes): An optional 32-bit field, which is padding used to align the FileContent field on an 8-byte boundary.
        /// The contents of this field are indeterminate and MUST be ignored.
        try dataStream.readEightByteAlignmentPadding(startPosition: startPosition)
        
        /// FileContent (variable): Variable-size, 32-bit aligned data, which represents the definitions of glyphs in the font.
        /// The content is in PostScript Type 1 font format.
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
