//
//  File.swift
//  
//
//  Created by Hugh Bellamy on 09/12/2020.
//

/// [MS-EMFSPOOL] 2.1.1 RecordType Enumeration
/// The RecordType enumeration specifies the types of records allowed in an EMF spool format metafile.<2>
/// typedef enum
/// {
///  EMRI_METAFILE = 0x00000001,
///  EMRI_ENGINE_FONT = 0x00000002,
///  EMRI_DEVMODE = 0x00000003,
///  EMRI_TYPE1_FONT = 0x00000004,
///  EMRI_PRESTARTPAGE = 0x00000005,
///  EMRI_DESIGNVECTOR = 0x00000006,
///  EMRI_SUBSET_FONT = 0x00000007,
///  EMRI_DELTA_FONT = 0x00000008,
///  EMRI_FORM_METAFILE = 0x00000009,
///  EMRI_BW_METAFILE = 0x0000000A,
///  EMRI_BW_FORM_METAFILE = 0x0000000B,
///  EMRI_METAFILE_DATA = 0x0000000C,
///  EMRI_METAFILE_EXT = 0x0000000D,
///  EMRI_BW_METAFILE_EXT = 0x0000000E,
///  EMRI_ENGINE_FONT_EXT = 0x0000000F,
///  EMRI_TYPE1_FONT_EXT = 0x00000010,
///  EMRI_DESIGNVECTOR_EXT = 0x00000011,
///  EMRI_SUBSET_FONT_EXT = 0x00000012,
///  EMRI_DELTA_FONT_EXT = 0x00000013,
///  EMRI_PS_JOB_DATA = 0x00000014,
///  EMRI_EMBED_FONT_EXT = 0x00000015
/// } RecordType;
public enum RecordType: UInt32, DataStreamCreatable {    
    /// EMRI_METAFILE: Document content in the form of an EMF metafile, as specified in section 2.2.3.1.
    case EMRI_METAFILE = 0x00000001

    /// EMRI_ENGINE_FONT: A TrueType font definition, as specified in section 2.2.3.3.1.
    case EMRI_ENGINE_FONT = 0x00000002

    /// EMRI_DEVMODE: Device settings, as specified in section 2.2.3.5.
    case EMRI_DEVMODE = 0x00000003

    /// EMRI_TYPE1_FONT: A PostScript Type 1 font definition, as specified in section 2.2.3.3.2.
    case EMRI_TYPE1_FONT = 0x00000004

    /// EMRI_PRESTARTPAGE: The start page for encapsulated PostScript (EPS), as specified in section 2.2.3.6.
    case EMRI_PRESTARTPAGE = 0x00000005

    /// EMRI_DESIGNVECTOR: A font design vector, as specified in section 2.2.3.3.3.
    case EMRI_DESIGNVECTOR = 0x00000006

    /// EMRI_SUBSET_FONT: A subset font definition, as specified in section 2.2.3.3.4.
    case EMRI_SUBSET_FONT = 0x00000007

    /// EMRI_DELTA_FONT: A delta font definition, as specified in section 2.2.3.3.5.
    case EMRI_DELTA_FONT = 0x00000008

    /// EMRI_FORM_METAFILE: Document content in the form of an EMF metafile, as specified in section 2.2.3.1.
    case EMRI_FORM_METAFILE = 0x00000009

    /// EMRI_BW_METAFILE: Monochrome document content in the form of an EMF metafile, as specified in section 2.2.3.1.
    case EMRI_BW_METAFILE = 0x0000000A

    /// EMRI_BW_FORM_METAFILE: Monochrome document content in the form of an EMF metafile, as specified in section 2.2.3.1.
    case EMRI_BW_FORM_METAFILE = 0x0000000B

    /// EMRI_METAFILE_DATA: Document content in the form of an EMF metafile, as specified in section 2.2.3.1.
    case EMRI_METAFILE_DATA = 0x0000000C

    /// EMRI_METAFILE_EXT: An offset to document content, as specified in section 2.2.3.2.
    case EMRI_METAFILE_EXT = 0x0000000D

    /// EMRI_BW_METAFILE_EXT: An offset to monochrome document content, as specified in section 2.2.3.2.
    case EMRI_BW_METAFILE_EXT = 0x0000000E

    /// EMRI_ENGINE_FONT_EXT: An offset to a TrueType font definition, as specified in section 2.2.3.4.
    case EMRI_ENGINE_FONT_EXT = 0x0000000F

    /// EMRI_TYPE1_FONT_EXT: An offset to a PostScript Type 1 font definition, as specified in section 2.2.3.4.
    case EMRI_TYPE1_FONT_EXT = 0x00000010

    /// EMRI_DESIGNVECTOR_EXT: An offset to a font design vector, as specified in section 2.2.3.4.
    case EMRI_DESIGNVECTOR_EXT = 0x00000011

    /// EMRI_SUBSET_FONT_EXT: An offset to a subset font definition, as specified in section 2.2.3.4.
    case EMRI_SUBSET_FONT_EXT = 0x00000012

    /// EMRI_DELTA_FONT_EXT: An offset to a delta font definition, as specified in section 2.2.3.4.
    case EMRI_DELTA_FONT_EXT = 0x00000013

    /// EMRI_PS_JOB_DATA: Document-level PostScript data, as specified in section 2.2.3.7.
    case EMRI_PS_JOB_DATA = 0x00000014
    
    /// EMRI_EMBED_FONT_EXT: An offset to embedded font identifiers, as specified in section 2.2.3.4.
    case EMRI_EMBED_FONT_EXT = 0x00000015
}
