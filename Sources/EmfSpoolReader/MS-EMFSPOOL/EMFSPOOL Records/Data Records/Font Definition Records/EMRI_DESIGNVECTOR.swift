//
//  EMRI_DESIGNVECTOR.swift
//
//
//  Created by Hugh Bellamy on 09/12/2020.
//

import DataStream
import EmfReader

/// [MS-EMF] 2.2.3.3.3 EMRI_DESIGNVECTOR Record
/// The EMRI_DESIGNVECTOR record specifies a design vector for a font, which characterizes the font's appearance in up to 16
/// dimensions.<9>
public struct EMRI_DESIGNVECTOR {
    public let ulID: RecordType
    public let cjSize: UInt32
    public let universalFontId: UniversalFontId
    public let designVector: DesignVector
    
    public init(dataStream: inout DataStream) throws {
        /// lID (4 bytes): A 32-bit unsigned integer that identifies the type of record. The value MUST be 0x00000006, which specifies
        /// the EMRI_DESIGNVECTOR record type from the RecordType Enumeration (section 2.1.1).
        self.ulID = try RecordType(dataStream: &dataStream)
        guard self.ulID == .EMRI_DESIGNVECTOR else {
            throw EmfSpoolReadError.corrupted
        }
        
        /// cjSize (4 bytes): A 32-bit unsigned integer that specifies the size, in bytes, of the data attached to the record.
        /// The size of each record in an EMF spool format file MUST be rounded up to a multiple of 4 bytes.
        let cjSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard cjSize >= 16 && cjSize % 4 == 0 else {
            throw EmfSpoolReadError.corrupted
        }
        
        self.cjSize = cjSize
        
        let startPosition = dataStream.position

        /// UniversalFontId (8 bytes): An EMF UniversalFontId object ([MS-EMF] section 2.2.27) that identifies the font.
        self.universalFontId = try UniversalFontId(dataStream: &dataStream)
        
        /// DesignVector (variable): An EMF DesignVector object ([MS-EMF] section 2.2.3) that specifies the properties of the font.
        /// The first DWORD MUST contain the design vector signature, which is the value given by the equation.
        /// 0x08000000 + 'd' + ('v' << 8)
        /// Using 8-bit ASCII for the character code points, this value is 0x08007664.
        self.designVector = try DesignVector(dataStream: &dataStream)
        
        try dataStream.readFourByteAlignmentPadding(startPosition: startPosition)
        
        guard dataStream.position - startPosition == self.cjSize else {
            throw EmfSpoolReadError.corrupted
        }
    }
}
