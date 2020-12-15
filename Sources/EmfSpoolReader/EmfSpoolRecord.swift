//
//  EMFSPOOL.swift
//  
//
//  Created by Hugh Bellamy on 09/12/2020.
//

import DataStream

/// [MS-EMFSPOOL] 2.2 EMFSPOOL Records
/// EMFSPOOL records include syntax and record types. This information is organized as follows.
/// Name Section Description
/// Record syntax 2.2.1 The structure and syntax of EMFSPOOL records.
/// Header record 2.2.2 The EMFSPOOL header record, which specifies global properties, including the size of the spool file, the name
/// of the document being spooled, and the name of the output device.
/// Data records 2.2.3 EMFSPOOL data records, which specify page content, fonts, and output device information.
/// All string data in EMFSPOOL records MUST be encoded in Unicode UTF-16LE format, as specified in [UNICODE], unless stated
/// otherwise. The size of each record in EMFSPOOL MUST be rounded up to a multiple of 4 bytes.
public enum EmfSpoolRecord {
    case eof
    case metafile(_: PageContentRecord)
    case engineFont(_: EMRI_ENGINE_FONT)
    case devmode(_: EMRI_DEVMODE)
    case type1Font(_: EMRI_TYPE1_FONT)
    case prestartPage(_: EMRI_PRESTARTPAGE)
    case designVector(_: EMRI_DESIGNVECTOR)
    case subsetFont(_: EMRI_SUBSET_FONT)
    case deltaFont(_: EMRI_DELTA_FONT)
    case formMetafile(_: PageContentRecord)
    case bwMetafile(_: PageContentRecord)
    case bwFormMetafile(_: PageContentRecord)
    case metafileData(_: PageContentRecord)
    case metafileExt(_: PageOffsetRecord)
    case bwMetafileEx(_: PageOffsetRecord)
    case engineFontExt(_: FontOffsetRecord)
    case type1FontExt(_: FontOffsetRecord)
    case designVectorExt(_: FontOffsetRecord)
    case subsetFontExt(_: FontOffsetRecord)
    case deltaFontExt(_: FontOffsetRecord)
    case psJobData(_: EMRI_PS_JOB_DATA)
    case embedFontExt(_: FontOffsetRecord)
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// ulID (4 bytes): A 32-bit unsigned identifier that specifies the type of record from the RecordType Enumeration (section 2.1.1).
        let ulID = try RecordType(dataStream: &dataStream)
        
        /// cjSize (4 bytes): A 32-bit unsigned integer that specifies the size, in bytes, of the data attached to the record.
        /// The size of each record in an EMF spool format metafile MUST be rounded up to a multiple of 4 bytes.
        let cjSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard cjSize <= dataStream.remainingCount && (cjSize % 4) == 0 else {
            throw EmfSpoolReadError.corrupted
        }

        dataStream.position = startPosition
        switch ulID {
        case .EMRI_METAFILE:
            self = .metafile(try PageContentRecord(dataStream: &dataStream))
        case .EMRI_ENGINE_FONT:
            self = .engineFont(try EMRI_ENGINE_FONT(dataStream: &dataStream))
        case .EMRI_DEVMODE:
            self = .devmode(try EMRI_DEVMODE(dataStream: &dataStream))
        case .EMRI_TYPE1_FONT:
            self = .type1Font(try EMRI_TYPE1_FONT(dataStream: &dataStream))
        case .EMRI_PRESTARTPAGE:
            self = .prestartPage(try EMRI_PRESTARTPAGE(dataStream: &dataStream))
        case .EMRI_DESIGNVECTOR:
            self = .designVector(try EMRI_DESIGNVECTOR(dataStream: &dataStream))
        case .EMRI_SUBSET_FONT:
            self = .subsetFont(try EMRI_SUBSET_FONT(dataStream: &dataStream))
        case .EMRI_DELTA_FONT:
            self = .deltaFont(try EMRI_DELTA_FONT(dataStream: &dataStream))
        case .EMRI_FORM_METAFILE:
            self = .formMetafile(try PageContentRecord(dataStream: &dataStream))
        case .EMRI_BW_METAFILE:
            self = .bwMetafile(try PageContentRecord(dataStream: &dataStream))
        case .EMRI_BW_FORM_METAFILE:
            self = .bwFormMetafile(try PageContentRecord(dataStream: &dataStream))
        case .EMRI_METAFILE_DATA:
            self = .metafileData(try PageContentRecord(dataStream: &dataStream))
        case .EMRI_METAFILE_EXT:
            self = .metafileExt(try PageOffsetRecord(dataStream: &dataStream))
        case .EMRI_BW_METAFILE_EXT:
            self = .bwMetafileEx(try PageOffsetRecord(dataStream: &dataStream))
        case .EMRI_ENGINE_FONT_EXT:
            self = .engineFontExt(try FontOffsetRecord(dataStream: &dataStream))
        case .EMRI_TYPE1_FONT_EXT:
            self = .type1FontExt(try FontOffsetRecord(dataStream: &dataStream))
        case .EMRI_DESIGNVECTOR_EXT:
            self = .designVectorExt(try FontOffsetRecord(dataStream: &dataStream))
        case .EMRI_SUBSET_FONT_EXT:
            self = .subsetFontExt(try FontOffsetRecord(dataStream: &dataStream))
        case .EMRI_DELTA_FONT_EXT:
            self = .deltaFontExt(try FontOffsetRecord(dataStream: &dataStream))
        case .EMRI_PS_JOB_DATA:
            self = .psJobData(try EMRI_PS_JOB_DATA(dataStream: &dataStream))
        case .EMRI_EMBED_FONT_EXT:
            self = .embedFontExt(try FontOffsetRecord(dataStream: &dataStream))
        }
        
        guard dataStream.position - startPosition == cjSize + 8 else {
            throw EmfSpoolReadError.corrupted
        }
    }
}
