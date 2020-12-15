//
//  EMRI_PS_JOB_DATA.swift
//
//
//  Created by Hugh Bellamy on 09/12/2020.
//

import DataStream

/// [MS-EMF] 2.2.3.7 EMRI_PS_JOB_DATA Record
/// The EMRI_PS_JOB_DATA record stores encapsulated PostScript (EPS) data at the document level.
/// If this record is present, it MUST appear immediately after an EMFSPOOL Header Record (section 2.2.2), as shown in the Record
/// Syntax (section 2.2.1).
public struct EMRI_PS_JOB_DATA {
    public let ulID: RecordType
    public let cjSize: UInt32
    public let postScriptDataRecords: [PostScriptRecord]
    
    public init(dataStream: inout DataStream) throws {
        /// ulID (4 bytes): A 32-bit unsigned integer that identifies the type of record.
        /// The value MUST be 0x00000014, from the RecordType (section 2.1.1) enumeration.
        self.ulID = try RecordType(dataStream: &dataStream)
        guard self.ulID == .EMRI_PS_JOB_DATA else {
            throw EmfSpoolReadError.corrupted
        }
        
        /// cjSize (4 bytes): A 32-bit unsigned integer that specifies the size, in bytes, of the data attached to the record.
        /// Each record in EMF spool format MUST be aligned to a multiple of 4 bytes.
        self.cjSize = try dataStream.read(endianess: .littleEndian)
        guard self.cjSize % 4 == 0 else {
            throw EmfSpoolReadError.corrupted
        }
        
        let startPosition = dataStream.position

        /// PostScriptDataRecords (variable): Data after the ulID and cjSize fields comes as multiple PostScript data records until all
        /// cjSize bytes are accounted for. Each variable-size record has the following structure.
        var postScriptDataRecords: [PostScriptRecord] = []
        while dataStream.position - startPosition < self.cjSize {
            postScriptDataRecords.append(try PostScriptRecord(dataStream: &dataStream))
        }
        
        self.postScriptDataRecords = postScriptDataRecords
        
        try dataStream.readFourByteAlignmentPadding(startPosition: startPosition)
        
        guard dataStream.position - startPosition == self.cjSize else {
            throw EmfSpoolReadError.corrupted
        }
    }
    
    /// PostScriptDataRecords (variable): Data after the ulID and cjSize fields comes as multiple PostScript data records until all
    /// cjSize bytes are accounted for. Each variable-size record has the following structure.
    public struct PostScriptRecord {
        public let postScriptDataRecordSize: UInt32
        public let nEscape: UInt16
        public let nIgnore: UInt16
        public let postScriptDataSize: Int32
        public let postScriptData: [UInt8]
        
        public init(dataStream: inout DataStream) throws {
            
            /// PostScriptDataRecordSize (4 bytes): A 32-bit unsigned integer that specifies the size, in bytes, of this PostScript
            /// data record. This value is based upon the value of PostScriptDataSize as follows:
            /// Value of (PostScriptDataSize modulo 4) Value of PostScriptDataRecordSize
            /// 0 PostScriptDataSize + 16
            /// 1 PostScriptDataSize + 15
            /// 2 PostScriptDataSize + 18
            /// 3 PostScriptDataSize + 17
            let postScriptDataRecordSize: UInt32 = try dataStream.read(endianess: .littleEndian)
            guard postScriptDataRecordSize >= 8 else {
                throw EmfSpoolReadError.corrupted
            }
            
            self.postScriptDataRecordSize = postScriptDataRecordSize
            
            /// nEscape (2 bytes): A 16-bit unsigned integer that specifies the escape code. It MUST be one of the following values;
            /// otherwise, this record is ignored.
            /// Value Meaning
            /// POSTSCRIPT_IDENTIFY 0x1005 Specify either PostScript–centric or GDI–centric mode to the printer driver.
            /// POSTSCRIPT_INJECTION 0x1006 Insert a block of raw data into a PostScript stream.
            self.nEscape = try dataStream.read(endianess: .littleEndian)
            
            /// nIgnore (2 bytes): An unsigned integer that SHOULD be zero and MUST be ignored on receipt.
            self.nIgnore = try dataStream.read(endianess: .littleEndian)
            
            /// PostScriptDataSize (4 bytes): A signed integer that specifies the size of the PostScriptData field, in bytes.
            let postScriptDataSize: Int32 = try dataStream.read(endianess: .littleEndian)
            guard postScriptDataSize >= 0 &&
                    postScriptDataSize <= postScriptDataRecordSize - 8 else {
                throw EmfSpoolReadError.corrupted
            }
            
            self.postScriptDataSize = postScriptDataSize
            
            /// PostScriptData (variable): The PostScript data.
            self.postScriptData = try dataStream.readBytes(count: Int(self.postScriptDataSize))
            
            /// nAlignment (variable): A buffer that is included to ensure the record is 32-bit aligned. The
            /// contents of this field MUST be ignored. The size of this field is based upon the value of
            /// PostScriptDataSize as follows:
            /// Value of (PostScriptDataSize modulo 4) Size of nAlignment
            /// 0 4 bytes
            /// 1 3 bytes
            /// 2 6 bytes
            /// 3 5 bytes
            let additionalAlignment: Int
            switch postScriptDataSize % 4 {
            case 0:
                additionalAlignment = 4
            case 1:
                additionalAlignment = 3
            case 2:
                additionalAlignment = 6
            default:
                additionalAlignment = 5
            }
            
            guard dataStream.position + additionalAlignment <= dataStream.count else {
                throw EmfSpoolReadError.corrupted
            }
            
            dataStream.position += additionalAlignment
        }
        
        /// nEscape (2 bytes): A 16-bit unsigned integer that specifies the escape code. It MUST be one of the following values;
        /// otherwise, this record is ignored.
        public enum Escape: UInt16 {
            /// POSTSCRIPT_IDENTIFY 0x1005 Specify either PostScript–centric or GDI–centric mode to the printer driver.
            case identify = 0x1005
            
            /// POSTSCRIPT_INJECTION 0x1006 Insert a block of raw data into a PostScript stream.
            case injection = 0x1006
        }
    }
}
