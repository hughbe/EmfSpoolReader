//
//  PageContentRecord.swift
//  
//
//  Created by Hugh Bellamy on 09/12/2020.
//

import DataStream
import EmfReader
import Foundation

var counter = 0

/// [MS-EMFSPOOL] 2.2.3.1 Page Content Records
/// Page Content Records include five record types, and they all have the following structure. Page content records specify formatting and
/// graphical content, in the form of embedded EMF metafile records [MS-EMF].
public struct PageContentRecord {
    public let ulID: RecordType
    public let cjSize: UInt32
    public let emfMetafile: EmfMetafile
    
    public init(dataStream: inout DataStream) throws {
        /// ulID (4 bytes): A 32-bit unsigned integer from the following table, which identifies the type of record (section 2.1.1).
        /// Value Meaning
        /// EMRI_METAFILE 0x00000001 This record defines the same function as the EMRI_METAFILE_DATA record.<4>
        /// EMRI_FORM_METAFILE 0x00000009 This record defines the same function as the EMRI_METAFILE_DATA record.<5>
        /// EMRI_BW_METAFILE 0x0000000A This record defines the same function as the EMRI_METAFILE_DATA record,
        /// except that the content is monochrome.<6>
        /// EMRI_BW_FORM_METAFILE 0x0000000B This record defines the same function as the EMRI_METAFILE_DATA record,
        /// except that the content is monochrome.<7>
        /// EMRI_METAFILE_DATA 0x0000000C The record contains an EMF metafile [MS-EMF], which specifies the content for a
        /// page of output.
        let ulID = try RecordType(dataStream: &dataStream)
        guard ulID == .EMRI_METAFILE ||
                ulID == .EMRI_FORM_METAFILE ||
                ulID == .EMRI_BW_METAFILE ||
                ulID == .EMRI_BW_FORM_METAFILE ||
                ulID == .EMRI_METAFILE_DATA else {
            throw EmfSpoolReadError.corrupted
        }
        
        self.ulID = ulID
        
        /// cjSize (4 bytes): A 32-bit unsigned integer that specifies the size, in bytes, of the metafile data attached to the record.
        /// The size of each record in EMF spool format MUST be rounded up to a multiple of 4 bytes.
        let cjSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard (cjSize % 4) == 0 && cjSize <= dataStream.remainingCount else {
            throw EmfSpoolReadError.corrupted
        }
        
        self.cjSize = cjSize
        
        let startPosition = dataStream.position
        
        if self.cjSize > 0 {
            /// EmfMetafile (variable): A complete EMF metafile.
            var metafileDataStream = DataStream(slicing: dataStream,
                                                startIndex: dataStream.position,
                                                count: Int(self.cjSize))
            if try metafileDataStream.peek() as UInt32 == 0x00000001 {
                self.emfMetafile = .emf(try EmfFile(dataStream: &metafileDataStream))
            } else {
                self.emfMetafile = .unknown(try metafileDataStream.readBytes(count: Int(self.cjSize)))
            }
            dataStream.position += Int(self.cjSize)
        } else {
            self.emfMetafile = .none
        }
        
        guard dataStream.position - startPosition == self.cjSize else {
            throw EmfSpoolReadError.corrupted
        }
    }
    
    public enum EmfMetafile {
        case none
        case emf(_: EmfFile)
        case unknown(_: [UInt8])
    }
}
