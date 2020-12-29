//
//  EmfSpoolHeader.swift
//  
//
//  Created by Hugh Bellamy on 09/12/2020.
//

import DataStream

/// [MS-EMFSPOOL] 2.2.2 Header Record
/// The Header record is always the first record of an EMFSPOOL metafile.
public struct EmfSpoolHeader {
    public let dwVersion: UInt32
    public let cjSize: UInt32
    public let dpszDocName: UInt32
    public let dpszOutput: UInt32
    public let docName: String?
    public let outputDevice: String?
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// dwVersion (4 bytes): A 32-bit unsigned integer that specifies the version of EMFSPOOL. This value MUST be 0x00010000.
        self.dwVersion = try dataStream.read(endianess: .littleEndian)
        guard self.dwVersion == 0x00010000 else {
            throw EmfSpoolReadError.corrupted
        }
        
        /// cjSize (4 bytes): A 32-bit unsigned integer that specifies the size, in bytes, of the header record, including extra data attached.
        /// The size of each record in EMFSPOOL MUST be rounded up to a multiple of 32 bits.
        let cjSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard cjSize >= 0x00000010 && (cjSize % 4) == 0 && cjSize - 0x00000008 <= dataStream.remainingCount else {
            throw EmfSpoolReadError.corrupted
        }

        self.cjSize = cjSize
        
        /// dpszDocName (4 bytes): A 32-bit unsigned integer that specifies the offset of the document name from the start of the
        /// record (dwVersion field). The document name is stored as a NULLterminated Unicode string, as specified in [UNICODE],
        /// in the extraDataDocName field. If this value is 0x00000000, a document name string SHOULD NOT be present in the
        /// header record.
        let dpszDocName: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.dpszDocName = dpszDocName
        
        /// dpszOutput (4 bytes): A 32-bit unsigned integer that specifies the offset of the output device name from the start of the
        /// record (dwVersion field). The output device name is stored as a NULLterminated Unicode string in the
        /// extraDataOutputDevice field. If this value is 0x00000000, an output device name string SHOULD NOT be present in the
        /// header record.
        let dpszOutput: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.dpszOutput = dpszOutput
        
        /// extraDataDocName (variable): Variable-size storage area for the document name string.
        /// This structure MUST be 32-bit aligned.
        if dpszDocName != 0x00000000 {
            /// PaddingDocName (variable): An optional array of WORD structures as padding, because the DocName field is not
            /// required to immediately follow the dpszOutput field.
            /// The values of these structures are indeterminate and MUST be ignored.
            guard dpszDocName >= 0x00000010 &&
                    startPosition + Int(dpszDocName) <= dataStream.count else {
                throw EmfSpoolReadError.corrupted
            }
            
            dataStream.position = startPosition + Int(dpszDocName)
            
            /// DocName (variable): A null-terminated string that specifies the name of the output file, or the name of the printer port.
            self.docName = try dataStream.readUnicodeString(endianess: .littleEndian)
            
            /// AlignmentDocName (variable): An optional array of WORD structures to ensure 32-bit alignment.
            /// The values of these structures are indeterminate and MUST be ignored.
            try dataStream.readFourByteAlignmentPadding(startPosition: startPosition)
        } else {
            self.docName = nil
        }
        
        /// extraDataOutputDevice (variable): Variable-size storage area for the output device name string.
        /// This structure MUST be 32-bit aligned.
        if dpszOutput != 0x00000000 {
            /// PaddingOutputDevice (variable): An optional array of WORD structures as padding, because the OutputDevice field
            /// is not required to immediately follow the extraDataDocName field.
            /// The values of these structures are indeterminate and MUST be ignored.
            guard dpszOutput >= 0x00000010 &&
                    startPosition + Int(dpszOutput) <= dataStream.count else {
                throw EmfSpoolReadError.corrupted
            }
            
            dataStream.position = startPosition + Int(dpszOutput)
            
            /// OutputDevice (variable): A null-terminated string that specifies the name of the output file, or the name of the printer port.
            self.outputDevice = try dataStream.readUnicodeString(endianess: .littleEndian)
            
            /// AlignmentOutputDevice (variable): An optional array of WORD structures to ensure 32-bit alignment.
            /// The values of these structures are indeterminate and MUST be ignored.
            try dataStream.readFourByteAlignmentPadding(startPosition: startPosition)
        } else {
            self.outputDevice = nil
        }
        
        guard dataStream.position - startPosition == self.cjSize else {
            throw EmfSpoolReadError.corrupted
        }
    }
}
