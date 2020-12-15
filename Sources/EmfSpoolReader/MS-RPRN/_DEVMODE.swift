//
//  File.swift
//
//
//  Created by Hugh Bellamy on 09/12/2020.
//

import DataStream

/// [MS-RRPN] 2.2.2.1 _DEVMODE
/// The _DEVMODE structure defines initialization data for a printer. Although the _DEVMODE structure does not contain any pointers,
/// it is still custom-marshaled, because the size of the structure is version-specific and implementation-specific, and cannot be
/// expressed using IDL attributes. It has the following message format.
/// The print server MUST accept _DEVMODE structures with truncated public information. A truncated _DEVMODE structure contains
/// a subset of fields, from dmDeviceName up to and including dmFields, plus at least those fields that are initialized as specified by
/// dmFields. It is followed by private, printer driver–specific data, the size of which is specified by the dmDriverExtra field.
public struct _DEVMODE {
    public let dmDeviceName: String
    public let dmSpecVersion: UInt16
    public let dmDriverVersion: UInt16
    public let dmSize: UInt16
    public let dmDriverExtra: UInt16
    public let dmFields: Fields
    public let dmOrientation: UInt16?
    public let dmPaperSize: UInt16?
    public let dmPaperLength: UInt16?
    public let dmPaperWidth: UInt16?
    public let dmScale: UInt16?
    public let dmCopies: UInt16?
    public let dmDefaultSource: UInt16?
    public let dmPrintQuality: UInt16?
    public let dmColor: Color?
    public let dmDuplex: UInt16?
    public let dmYResolution: UInt16?
    public let dmTTOption: UInt16?
    public let dmCollate: UInt16?
    public let dmFormName: String?
    public let reserved0: UInt16
    public let reserved1: UInt32
    public let reserved2: UInt32
    public let reserved3: UInt32
    public let dmNup: UInt32?
    public let reserved4: UInt32
    public let dmICMMethod: UInt32?
    public let dmICMIntent: UInt32?
    public let dmMediaType: UInt32?
    public let dmDitherType: UInt32?
    public let reserved5: UInt32
    public let reserved6: UInt32
    public let reserved7: UInt32
    public let reserved8: UInt32
    public let dmDriverExtraData: [UInt8]
    
    public init(dataStream: inout DataStream) throws {
        /// dmDeviceName (64 bytes): A 32-element array of 16-bit Unicode characters that form a nullterminated string that specifies
        /// the name of the printer. Printer name strings that are longer than 32 characters are truncated to fit the array. For more rules
        /// governing printer names, see section 2.2.4.14.
        self.dmDeviceName = try dataStream.readString(count: 64, encoding: .utf16LittleEndian)!.trimmingCharacters(in: ["\0"])
        
        /// dmSpecVersion (2 bytes): The version of initialization data specification on which the _DEVMODE structure is based.
        /// This value SHOULD be 0x0401.<93>
        self.dmSpecVersion = try dataStream.read(endianess: .littleEndian)
        
        /// dmDriverVersion (2 bytes): For printers, an optional, implementation-defined version of the printer driver.<94>
        self.dmDriverVersion = try dataStream.read(endianess: .littleEndian)
        
        /// dmSize (2 bytes): The size, in bytes, of the _DEVMODE structure, which MUST be a multiple of 4.
        /// This value does not include the length of any private, printer driver–specific data that follows the _DEVMODE structure's
        /// public fields. The size of private data is specified by the dmDriverExtra value.
        /// If the _DEVMODE structure contains truncated public information, the value of dmSize is at least the size, in bytes, of a
        /// subset of fields, from dmDeviceName up to and including dmFields, plus fields that are initialized as specified by dmFields.
        self.dmSize = try dataStream.read(endianess: .littleEndian)
        guard self.dmSize % 4 == 0 else {
            throw EmfSpoolReadError.corrupted
        }
        
        /// dmDriverExtra (2 bytes): The size, in bytes, of the private, printer driver–specific data that follows this structure.
        self.dmDriverExtra = try dataStream.read(endianess: .littleEndian)
        
        /// dmFields (4 bytes): A bitfield that specifies the fields of the _DEVMODE structure that have been initialized.
        /// If a bit is set, the corresponding field MUST be initialized and MUST be processed on receipt.
        /// If a bit is not set, the value of the corresponding field SHOULD be zero when sent and MUST be ignored on receipt.
        /// The value of this field is the result of a bitwise OR of the following bits.
        self.dmFields = try Fields(dataStream: &dataStream)
        
        /// dmOrientation (2 bytes): For printers, the orientation for output. If the DM_ORIENTATION bit is set in dmFields, the value
        /// of this field SHOULD be one of the following.
        //if self.dmFields.contains(.orientation) {
            self.dmOrientation = try dataStream.read(endianess: .littleEndian)
        //} else {
        //    self.dmOrientation = nil
        //}
        
        /// dmPaperSize (2 bytes): For printers, the size of the output media. If the DM_PAPERSIZE bit is set in dmFields, the value of
        /// this field SHOULD<95> be one of the following, or it MAY be a devicespecific value that is greater than or equal to 0x0100.
        //if self.dmFields.contains(.paperSize) {
            self.dmPaperSize = try dataStream.read(endianess: .littleEndian)
        //} else {
        //    self.dmPaperSize = nil
        //}
        
        /// dmPaperLength (2 bytes): If the DM_PAPERLENGTH bit is set in the dmFields field, this field specifies the length of the
        /// paper, in tenths of a millimeter, to use in the printer for which the job is destined.
        self.dmPaperLength = try dataStream.read(endianess: .littleEndian)
        
        /// dmPaperWidth (2 bytes): If the DM_PAPERWIDTH bit is set in the dmFields field, this field specifies the width of the
        /// paper, in tenths of a millimeter, to use in the printer for which the job is destined.
        self.dmPaperWidth = try dataStream.read(endianess: .littleEndian)
        
        /// dmScale (2 bytes): If the DM_SCALE bit is set in the dmFields field, this field specifies the percentage factor by which the
        /// printed output is to be scaled.
        //if self.dmFields.contains(.scale) {
            self.dmScale = try dataStream.read(endianess: .littleEndian)
        //} else {
        //    self.dmScale = nil
        //}
        
        /// dmCopies (2 bytes): If the DM_COPIES bit is set in the dmFields field, this field specifies the number of copies to be
        /// printed, if the device supports multiple-page copies.
        //if self.dmFields.contains(.copies) {
            self.dmCopies = try dataStream.read(endianess: .littleEndian)
        //} else {
        //    self.dmCopies = nil
        //}
        
        /// dmDefaultSource (2 bytes): If the DM_DEFAULTSOURCE bit is set in the dmFields field, this field specifies the paper source.
        /// The value of this field SHOULD be one of the following, or it MAY be a device-specific value that is greater than or equal to
        /// 0x0100.
        //if self.dmFields.contains(.defaultSource) {
            self.dmDefaultSource = try dataStream.read(endianess: .littleEndian)
        //} else {
        //    self.dmDefaultSource = nil
        //}
        
        /// dmPrintQuality (2 bytes): If the DM_PRINTQUALITY bit is set in the dmFields field, this field specifies the printer resolution.
        /// The value of this field MUST be either a positive value that specifies a device-dependent resolution in dots per inch (DPI) or
        /// one of the following four predefined device-independent values that are mapped to a device-specific resolution in an
        /// implementation-specific manner.
        //if self.dmFields.contains(.printQuality) {
            self.dmPrintQuality = try dataStream.read(endianess: .littleEndian)
        //} else {
        //    self.dmPrintQuality = nil
        //}
        
        /// dmColor (2 bytes): If the DM_COLOR bit is set in the dmFields field, this field specifies the color mode to use with color
        /// printers. The value of this field MUST be one of the following.
        //if self.dmFields.contains(.color) {
            self.dmColor = try Color(dataStream: &dataStream)
        //} else {
        //    self.dmColor = nil
        //}
        
        /// dmDuplex (2 bytes): If the DM_DUPLEX bit is set in the dmFields field, this field specifies duplex or double-sided printing
        /// for printers that are capable of duplex printing. The value of this field MUST be one of the following.
        //if self.dmFields.contains(.duplex) {
            self.dmDuplex = try dataStream.read(endianess: .littleEndian)
        //} else {
        //    self.dmDuplex = nil
        //}
        
        /// dmYResolution (2 bytes): If the DM_YRESOLUTION bit is set in the dmFields, this field specifies the y-resolution, in dots
        /// per inch, of the printer.
        //if self.dmFields.contains(.yResolution) {
            self.dmYResolution = try dataStream.read(endianess: .littleEndian)
        //} else {
        //    self.dmYResolution = nil
        //}
        
        /// dmTTOption (2 bytes): If the DM_TTOPTION bit is set in the dmFields field, this field specifies how TrueType fonts MUST
        /// be printed. The value of this field MUST be one of the following.
        //if self.dmFields.contains(.ttOption) {
            self.dmTTOption = try dataStream.read(endianess: .littleEndian)
        //} else {
        //    self.dmTTOption = nil
        //}
        
        /// dmCollate (2 bytes): If the DM_COLLATE bit is set in the dmFields field, this field specifies whether collation is used when
        /// printing multiple copies. The value of this field is one of the following:
        //if self.dmFields.contains(.collate) {
            self.dmCollate = try dataStream.read(endianess: .littleEndian)
        //} else {
        //    self.dmCollate = nil
        //}
        
        /// dmFormName (64 bytes): This field is a 32-element array of 16-bit Unicode characters. If the DM_FORMNAME bit is set in
        /// the dmFields field, this field specifies the name of the form to use, for example, "Letter" or "Legal". The value of this field
        /// is restricted to 32 characters, including the trailing null. Form names that are longer than 32 characters, including the
        /// trailing null, are truncated to fit the array.
        //if self.dmFields.contains(.formName) {
            self.dmFormName = try dataStream.readString(count: 64, encoding: .utf16LittleEndian)!.trimmingCharacters(in: ["\0"])
        //} else {
        //    self.dmFormName = nil
        //}
        
        /// reserved0 (2 bytes): A value that SHOULD be zero when sent and MUST be ignored on receipt.
        self.reserved0 = try dataStream.read(endianess: .littleEndian)
        
        /// reserved1 (4 bytes): A value that SHOULD be zero when sent and MUST be ignored on receipt.
        self.reserved1 = try dataStream.read(endianess: .littleEndian)
        
        /// reserved2 (4 bytes): A value that SHOULD be zero when sent and MUST be ignored on receipt.
        self.reserved2 = try dataStream.read(endianess: .littleEndian)
        
        /// reserved3 (4 bytes): A value that SHOULD be zero when sent and MUST be ignored on receipt.
        self.reserved3 = try dataStream.read(endianess: .littleEndian)
        
        /// dmNup (4 bytes): If the DM_NUP bit is set in the dmFields, this field specifies the responsibility for performing page layout
        /// for N-Up Printing. It is one of the following values:
        //if self.dmFields.contains(.nup) {
            self.dmNup = try dataStream.read(endianess: .littleEndian)
        //} else {
        //    self.dmNup = nil
        //}
        
        /// reserved4 (4 bytes): A value that SHOULD be zero when sent and MUST be ignored on receipt.
        self.reserved4 = try dataStream.read(endianess: .littleEndian)
        
        /// dmICMMethod (4 bytes): If the DM_ICMMETHOD bit is set in the dmFields field, this field specifies how Image Color
        /// Management (ICM) is handled. For a non-ICM application, this field determines if ICM is enabled or disabled.
        /// For ICM applications, the system examines this field to determine how to handle ICM support.
        /// The value of this field is one of the following predefined values or a printer driver-defined value greater than or equal to
        /// 0x00000100.
        //if self.dmFields.contains(.icmMethod) {
            self.dmICMMethod = try dataStream.read(endianess: .littleEndian)
        //} else {
        //    self.dmICMMethod = nil
        //}
        
        /// dmICMIntent (4 bytes): If the DM_ICMINTENT bit is set in the dmFields field, this field specifies which color matching method,
        /// or intent, is used by default. This field is primarily for non-ICM applications. ICM applications can establish intents by using
        /// the ICM functions. The value of this field is one of the following predefined values, or a printer driver defined value greater
        /// than or equal to 0x00000100.
        //if self.dmFields.contains(.icmIntent) {
            self.dmICMIntent = try dataStream.read(endianess: .littleEndian)
        //} else {
        //    self.dmICMIntent = nil
        //}
        
        /// dmMediaType (4 bytes): If the DM_MEDIATYPE bit is set in the dmFields field, this field specifies the type of media to print
        /// on. The value of this field is one of the following predefined values or else a printer driver-defined value greater than or equal
        /// to 0x00000100.
        //if self.dmFields.contains(.mediaType) {
            self.dmMediaType = try dataStream.read(endianess: .littleEndian)
        //} else {
        //    self.dmMediaType = nil
        //}
        
        /// dmDitherType (4 bytes): If the DM_DITHERTYPE bit is set in the dmFields field, this field specifies how dithering is to be done.
        /// The value of this field is one of the following predefined values or else a printer driver-defined value greater than or equal to
        /// 0x00000100.
        //if self.dmFields.contains(.ditherType) {
            self.dmDitherType = try dataStream.read(endianess: .littleEndian)
        //} else {
        //    self.dmDitherType = nil
        //}
        
        /// reserved5 (4 bytes): A value that SHOULD be zero when sent and MUST be ignored on receipt.
        self.reserved5 = try dataStream.read(endianess: .littleEndian)
        
        /// reserved6 (4 bytes): A value that SHOULD be zero when sent and MUST be ignored on receipt.
        self.reserved6 = try dataStream.read(endianess: .littleEndian)
        
        /// reserved7 (4 bytes): A value that SHOULD be zero when sent and MUST be ignored on receipt.
        self.reserved7 = try dataStream.read(endianess: .littleEndian)
        
        /// reserved8 (4 bytes): A value that SHOULD be zero when sent and MUST be ignored on receipt.
        self.reserved8 = try dataStream.read(endianess: .littleEndian)
        
        /// dmDriverExtraData (variable): This field can contain implementation-specific printer driver data.
        /// Its size in bytes is specified by the dmDriverExtra field.<98>
        self.dmDriverExtraData = try dataStream.readBytes(count: Int(self.dmDriverExtra))
    }
    
    /// dmFields (4 bytes): A bitfield that specifies the fields of the _DEVMODE structure that have been initialized.
    /// If a bit is set, the corresponding field MUST be initialized and MUST be processed on receipt.
    /// If a bit is not set, the value of the corresponding field SHOULD be zero when sent and MUST be ignored on receipt.
    /// The value of this field is the result of a bitwise OR of the following bits.
    public struct Fields: OptionSet, DataStreamCreatable {
        public let rawValue: UInt32
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
        
        public init(dataStream: inout DataStream) throws {
            self.rawValue = try dataStream.read(endianess: .bigEndian)
        }
        
        /// DM_ICMINTENT CI If this bit is set, the dmICMIntent field MUST be initialized.
        public static let icmIntent = Fields(rawValue: 1 << 0)
        
        /// DM_MEDIATYPE MT If this bit is set, the dmMediaType field MUST be initialized.
        public static let mediaType = Fields(rawValue: 1 << 1)
        
        /// DM_DITHERTYPE DT If this bit is set, the dmDitherType field MUST be initialized.
        public static let ditherType = Fields(rawValue: 1 << 2)
        
        /// DM_FORMNAME FM If this bit is set, the dmFormName field MUST be initialized.
        public static let formName = Fields(rawValue: 1 << 8)
        
        /// DM_ICMMETHOD CM If this bit is set, the dmICMMethod field MUST be initialized.
        public static let icmMethod = Fields(rawValue: 1 << 15)
        
        /// DM_COPIES CP If this bit is set, the dmCopies field MUST be initialized.
        public static let copies = Fields(rawValue: 1 << 16)
        
        /// DM_DEFAULTSOURCE DS If this bit is set, the dmDefaultSource field MUST be initialized.
        public static let defaultSource = Fields(rawValue: 1 << 17)
        
        /// DM_PRINTQUALITY PQ If this bit is set, the dmPrintQuality field MUST be initialized.
        public static let printQuality = Fields(rawValue: 1 << 18)
        
        /// DM_COLOR CR If this bit is set, the dmColor field MUST be initialized.
        public static let color = Fields(rawValue: 1 << 19)
        
        /// DM_DUPLEX DX If this bit is set, the dmDuplex field MUST be initialized.
        public static let duplex = Fields(rawValue: 1 << 20)
        
        /// DM_YRESOLUTION Y If this bit is set, the dmYResolution field MUST be initialized.
        public static let yResolution = Fields(rawValue: 1 << 21)
        
        /// DM_TTOPTION TT If this bit is set, the dmTTOption field MUST be initialized.
        public static let ttOption = Fields(rawValue: 1 << 22)
        
        /// DM_COLLATE CL If this bit is set, the dmCollate field MUST be initialized.
        public static let collate = Fields(rawValue: 1 << 23)
        
        /// DM_ORIENTATION OR If this bit is set, the dmOrientation field MUST be initialized.
        public static let orientation = Fields(rawValue: 1 << 24)
        
        /// DM_PAPERSIZE PS If this bit is set, the dmPaperSize field MUST be initialized. This bit MUST NOT be set if either
        /// DM_PAPERLENGTH or DM_PAPERWIDTH are set.
        public static let paperSize = Fields(rawValue: 1 << 25)
        
        /// DM_PAPERLENGTH PL If this bit is set, the dmPaperLength field MUST be initialized. This bit MUST NOT be set if
        /// DM_PAPERSIZE is set.
        public static let paperLength = Fields(rawValue: 1 << 26)
        
        /// DM_PAPERWIDTH PW If this bit is set, the dmPaperWidth field MUST be initialized. This bit MUST NOT be set if
        /// DM_PAPERSIZE is set.
        public static let paperWidth = Fields(rawValue: 1 << 27)
        
        /// DM_SCALE SC If this bit is set, the dmScale field MUST be initialized.
        public static let scale = Fields(rawValue: 1 << 28)
        
        /// DM_NUP UP If this bit is set, the dmNup field MUST be initialized.
        public static let nup = Fields(rawValue: 1 << 30)
        
        static let all: Fields = [
            .icmIntent,
            .mediaType,
            .ditherType,
            .formName,
            .icmMethod,
            .copies,
            .defaultSource,
            .printQuality,
            .color,
            .duplex,
            .yResolution,
            .ttOption,
            .collate,
            .orientation,
            .paperSize,
            .paperLength,
            .paperWidth,
            .scale,
            .nup
        ]
    }

    /// dmOrientation (2 bytes): For printers, the orientation for output. If the DM_ORIENTATION bit is set in dmFields, the value of this field
    /// SHOULD be one of the following.
    public enum Orientation: UInt16 {
        /// DMORIENT_POTRAIT 0x0001 "Portrait" orientation.
        case portrait = 0x0001
    
        /// DMORIENT_LANDSCAPE 0x0002 "Landscape" orientation.
        case landscape = 0x0002
    }
    
    /// dmPaperSize (2 bytes): For printers, the size of the output media. If the DM_PAPERSIZE bit is set in dmFields, the value of this field
    /// SHOULD<95> be one of the following, or it MAY be a devicespecific value that is greater than or equal to 0x0100.
    public enum PaperSize: UInt16 {
        /// DMPAPER_LETTER 0x0001 Letter, 8 1/2 x 11 inches
        case letter = 0x0001
        
        /// DMPAPER_LEGAL 0x0005 Legal, 8 1/2 x 14 inches
        case legal = 0x0005
        
        /// DMPAPER_10X14 0x0010 10 x 14-inch sheet
        case tenXFourteen = 0x0010
        
        /// DMPAPER_11X17 0x0011 11 x 17-inch sheet
        case elevenXSeventeen = 0x0011
        
        /// DMPAPER_12X11 0x005A 12 x 11-inch sheet
        case twelveXEleven = 0x005A
        
        /// DMPAPER_A3 0x0008 A3 sheet, 297 x 420 millimeters
        case a3 = 0x0008
        
        /// DMPAPER_A3_ROTATED 0x004C A3 rotated sheet, 420 x 297 millimeters
        case a3Rotated = 0x004C
        
        /// DMPAPER_A4 0x0009 A4 sheet, 210 x 297 millimeters
        case a4 = 0x0009
        
        /// DMPAPER_A4_ROTATED 0x004D A4 rotated sheet, 297 x 210 millimeters
        case a4Rotated = 0x004D
        
        /// DMPAPER_A4SMALL 0x000A A4 small sheet, 210 x 297 millimeters
        case a4Small = 0x000A
        
        /// DMPAPER_A5 0x000B A5 sheet, 148 x 210 millimeters
        case a5 = 0x000B
        
        /// DMPAPER_A5_ROTATED 0x004E A5 rotated sheet, 210 x 148 millimeters
        case a5Rotated = 0x004E
        
        /// DMPAPER_A6 0x0046 A6 sheet, 105 x 148 millimeters
        case a6 = 0x0046
        
        /// DMPAPER_A6_ROTATED 0x0053 A6 rotated sheet, 148 x 105 millimeters
        case a6Rotated = 0x0053
        
        /// DMPAPER_B4 0x000C B4 sheet, 250 x 354 millimeters
        case b4 = 0x000C
        
        /// DMPAPER_B4_JIS_ROTATED 0x004F B4 (JIS) rotated sheet, 364 x 257 millimeters
        case b4JisRotated = 0x004F
        
        /// DMPAPER_B5 0x000D B5 sheet, 182 x 257-millimeter paper
        case b5 = 0x000D
        
        /// DMPAPER_B5_JIS_ROTATED 0x0050 B5 (JIS) rotated sheet, 257 x 182 millimeters
        case b5JisRotated = 0x0050
        
        /// DMPAPER_B6_JIS 0x0058 B6 (JIS) sheet, 128 x 182 millimeters
        case b6Jis = 0x0058
        
        /// DMPAPER_B6_JIS_ROTATED 0x0059 B6 (JIS) rotated sheet, 182 x 128 millimeters
        case b6JisRotated = 0x0059
    
        /// DMPAPER_CSHEET 0x0018 C Sheet, 17 x 22 inches
        case cSheet = 0x0018
        
        /// DMPAPER_DBL_JAPANESE_POSTCARD 0x0045 Double Japanese Postcard, 200 x 148 millimeters
        case dblJapanesePostcard = 0x0045
        
        /// DMPAPER_DBL_JAPANESE_POSTCARD_ROTATED 0x0052 Double Japanese Postcard Rotated, 148 x 200 millimeters
        case dblJapanesePostcardRotated = 0x0052

        /// DMPAPER_DSHEET 0x0019 D Sheet, 22 x 34 inches
        case dSheet = 0x0019

        /// DMPAPER_ENV_9 0x0013 #9 Envelope, 3 7/8 x 8 7/8 inches
        case env9 = 0x0013

        /// DMPAPER_ENV_10 0x0014 #10 Envelope, 4 1/8 x 9 1/2 inches
        case env10 = 0x0014

        /// DMPAPER_ENV_11 0x0015 #11 Envelope, 4 1/2 x 10 3/8 inches
        case env11 = 0x0015

        /// DMPAPER_ENV_12 0x0016 #12 Envelope, 4 3/4 x 11 inches
        case env12 = 0x0016

        /// DMPAPER_ENV_14 0x0017 #14 Envelope, 5 x 11 1/2 inches
        case env14 = 0x0017

        /// DMPAPER_ENV_C5 0x001C C5 Envelope, 162 x 229 millimeters
        case envC5 = 0x001C

        /// DMPAPER_ENV_C3 0x001D C3 Envelope, 324 x 458 millimeters
        case envC3 = 0x001D

        /// DMPAPER_ENV_C4 0x001E C4 Envelope, 229 x 324 millimeters
        case envC4 = 0x001E

        /// DMPAPER_ENV_C6 0x001F C6 Envelope, 114 x 162 millimeters
        case envC6 = 0x001F

        /// DMPAPER_ENV_C65 0x0020 C65 Envelope, 114 x 229 millimeters
        case envC65 = 0x0020

        /// DMPAPER_ENV_B4 0x0021 B4 Envelope, 250 x 353 millimeters
        case envB4 = 0x0021

        /// DMPAPER_ENV_B5 0x0022 B5 Envelope, 176 x 250 millimeters
        case envB5 = 0x0022

        /// DMPAPER_ENV_B6 0x0023 B6 Envelope, 176 x 125 millimeters
        case envB6 = 0x0023

        /// DMPAPER_ENV_DL 0x001B DL Envelope, 110 x 220 millimeters
        case envDL = 0x001B

        /// DMPAPER_ENV_ITALY 0x0024 Italy Envelope, 110 x 230 millimeters
        case envItaly = 0x0024

        /// DMPAPER_ENV_MONARCH 0x0025 Monarch Envelope, 3 7/8 x 7 1/2 inches
        case envMonarch = 0x0025

        /// DMPAPER_ENV_PERSONAL 0x0026 6 3/4 Envelope, 3 5/8 x 6 1/2 inches
        case envPersonal = 0x0026

        /// DMPAPER_ESHEET 0x001A E Sheet, 34 x 44 inches
        case eSheet = 0x001A

        /// DMPAPER_EXECUTIVE 0x0007 Executive, 7 1/4 x 10 1/2 inches
        case executive = 0x0007

        /// DMPAPER_FANFOLD_US 0x0027 US Std Fanfold, 14 7/8 x 11 inches
        case fanfold = 0x0027

        /// DMPAPER_FANFOLD_STD_GERMAN 0x0028 German Std Fanfold, 8 1/2 x 12 inches
        case fanfoldStdGerman = 0x0028

        /// DMPAPER_FANFOLD_LGL_GERMAN 0x0029 German Legal Fanfold, 8 x 13 inches
        case fanfoldLglGerman = 0x0029

        /// DMPAPER_FOLIO 0x000E Folio, 8 1/2 x 13-inch paper
        case folio = 0x000E

        /// DMPAPER_JAPANESE_POSTCARD_ROTATED 0x0051 Japanese Postcard Rotated, 148 x 100 millimeters
        case japanesePostcardRotated = 0x0051

        /// DMPAPER_JENV_CHOU3 0x0049 Japanese Envelope Chou #3
        case jenvChou3 = 0x0049

        /// DMPAPER_JENV_CHOU3_ROTATED 0x0056 Japanese Envelope Chou #3 Rotated
        case jenvChou3Rotated = 0x0056

        /// DMPAPER_JENV_CHOU4 0x004A Japanese Envelope Chou #4
        case jenvChou4 = 0x004A

        /// DMPAPER_JENV_CHOU4_ROTATED 0x0057 Japanese Envelope Chou #4 Rotated
        case jenvChou4Rotated = 0x0057

        /// DMPAPER_JENV_KAKU2 0x0047 Japanese Envelope Kaku #2
        case jenvKaku2 = 0x0047

        /// DMPAPER_JENV_KAKU2_ROTATED 0x0054 Japanese Envelope Kaku #2 Rotated
        case jenvKaku2Rotated = 0x0054

        /// DMPAPER_JENV_KAKU3 0x0048 Japanese Envelope Kaku #3
        case jenvKaku3 = 0x0048

        /// DMPAPER_JENV_KAKU3_ROTATED 0x0055 Japanese Envelope Kaku #3 Rotated
        case jenvKaku3Rotated = 0x0055

        /// DMPAPER_JENV_YOU4 0x005B Japanese Envelope You #4
        case jenvYou4 = 0x005B

        /// DMPAPER_JENV_YOU4_ROTATED 0x005C Japanese Envelope You #4 Rotated
        case jenvYou4Rotated = 0x005C

        /// DMPAPER_LEDGER 0x0004 Ledger, 17 x 11 inches
        case ledger = 0x0004

        /// DMPAPER_LETTER_ROTATED 0x004B Letter Rotated, 11 by 8 1/2 inches
        case letterRotated = 0x004B

        /// DMPAPER_LETTERSMALL 0x0002 Letter Small, 8 1/2 x 11 inches
        case letterSmall = 0x0002

        /// DMPAPER_NOTE 0x0012 Note, 8 1/2 x 11-inches
        case note = 0x0012

        /// DMPAPER_P16K 0x005D PRC 16K, 146 x 215 millimeters
        case p16K = 0x005D

        /// DMPAPER_P16K_ROTATED 0x006A PRC 16K Rotated, 215 x 146 millimeters
        case p16KRotated = 0x006A

        /// DMPAPER_P32K 0x005E PRC 32K, 97 x 151 millimeters
        case p32K = 0x005E

        /// DMPAPER_P32K_ROTATED 0x006B PRC 32K Rotated, 151 x 97 millimeters
        case p32KRotated = 0x006B

        /// DMPAPER_P32KBIG 0x005F PRC 32K(Big) 97 x 151 millimeters
        case p32KBig = 0x005F

        /// DMPAPER_P32KBIG_ROTATED 0x006C PRC 32K(Big) Rotated, 151 x 97 millimeters
        case p32KBigRotated = 0x006C

        /// DMPAPER_PENV_1 0x0060 PRC Envelope #1, 102 by 165 millimeters
        case penv1 = 0x0060

        /// DMPAPER_PENV_1_ROTATED 0x006D PRC Envelope #1 Rotated, 165 x 102 millimeters
        case penv1Rotated = 0x006D

        /// DMPAPER_PENV_2 0x0061 PRC Envelope #2, 102 x 176 millimeters
        case penv2 = 0x0061

        /// DMPAPER_PENV_2_ROTATED 0x006E PRC Envelope #2 Rotated, 176 x 102 millimeters
        case penv2Rotated = 0x006E

        /// DMPAPER_PENV_3 0x0062 PRC Envelope #3, 125 x 176 millimeters
        case penv3 = 0x0062

        /// DMPAPER_PENV_3_ROTATED 0x006F PRC Envelope #3 Rotated, 176 x 125 millimeters
        case penv3Rotated = 0x006F

        /// DMPAPER_PENV_4 0x0063 PRC Envelope #4, 110 x 208 millimeters
        case penv4 = 0x0063

        /// DMPAPER_PENV_4_ROTATED 0x0070 PRC Envelope #4 Rotated, 208 x 110 millimeters
        case penv4Rotated = 0x0070

        /// DMPAPER_PENV_5 0x0064 PRC Envelope #5, 110 x 220 millimeters
        case penv5 = 0x0064

        /// DMPAPER_PENV_5_ROTATED 0x0071 PRC Envelope #5 Rotated, 220 x 110 millimeters
        case penv5Rotated = 0x0071

        /// DMPAPER_PENV_6 0x0065 PRC Envelope #6, 120 x 230 millimeters
        case penv6 = 0x0065

        /// DMPAPER_PENV_6_ROTATED 0x0072 PRC Envelope #6 Rotated, 230 x 120 millimeters
        case penv6Rotated = 0x0072

        /// DMPAPER_PENV_7 0x0066 PRC Envelope #7, 160 x 230 millimeters
        case penv7 = 0x0066

        /// DMPAPER_PENV_7_ROTATED 0x0073 PRC Envelope #7 Rotated, 230 x 160 millimeters
        case penv7Rotated = 0x0073

        /// DMPAPER_PENV_8 0x0067 PRC Envelope #8, 120 x 309 millimeters
        case penv8 = 0x0067

        /// DMPAPER_PENV_8_ROTATED 0x0074 PRC Envelope #8 Rotated, 309 x 120 millimeters
        case penv8Rotated = 0x0074

        /// DMPAPER_PENV_9 0x0068 PRC Envelope #9, 229 x 324 millimeters
        case penv9 = 0x0068

        /// DMPAPER_PENV_9_ROTATED 0x0075 PRC Envelope #9 Rotated, 324 x 229 millimeters
        case penv9Rotated = 0x0075

        /// DMPAPER_PENV_10 0x0069 PRC Envelope #10, 324 x 458 millimeters
        case penv10 = 0x0069

        /// DMPAPER_PENV_10_ROTATED 0x0076 PRC Envelope #10 Rotated, 458 x 324 millimeters
        case penv10Rotated = 0x0076

        /// DMPAPER_QUARTO 0x000F Quarto, 215 x 275 millimeter paper
        case quarto = 0x000F

        /// DMPAPER_STATEMENT 0x0006 Statement, 5 1/2 x 8 1/2 inches
        case statement = 0x0006

        /// DMPAPER_TABLOID 0x0003 Tabloid, 11 x 17 inches
        case tabloid = 0x0003
    }
    
    /// dmDefaultSource (2 bytes): If the DM_DEFAULTSOURCE bit is set in the dmFields field, this field specifies the paper source.
    /// The value of this field SHOULD be one of the following, or it MAY be a device-specific value that is greater than or equal to 0x0100
    public enum PaperSource: UInt16 {
        /// DMBIN_UPPER 0x0001 Select the upper paper bin. This value is also used for the paper source for printers that only have one paper bin.
        case upper = 0x0001

        /// DMBIN_LOWER 0x0002 Select the lower bin.
        case lower = 0x0002

        /// DMBIN_MIDDLE 0x0003 Select the middle paper bin.
        case middle = 0x0003

        /// DMBIN_MANUAL 0x0004 Manually select the paper bin.
        case manual = 0x0004

        /// DMBIN_ENVELOPE 0x0005 Select the auto envelope bin.
        case envelope = 0x0005

        /// DMBIN_ENVMANUAL 0x0006 Select the manual envelope bin.
        case envManual = 0x0006

        /// DMBIN_AUTO 0x0007 Auto-select the bin.
        case auto = 0x0007

        /// DMBIN_TRACTOR 0x0008 Select the bin with the tractor paper.
        case tractor = 0x0008

        /// DMBIN_SMALLFMT 0x0009 Select the bin with the smaller paper format.
        case smallFmt = 0x0009

        /// DMBIN_LARGEFMT 0x000A Select the bin with the larger paper format.
        case largeFmt = 0x000A

        /// DMBIN_LARGECAPACITY 0x000B Select the bin with large capacity.
        case largeCapacity = 0x000B

        /// DMBIN_CASSETTE 0x000E Select the cassette bin.
        case casette = 0x000E

        /// DMBIN_FORMSOURCE 0x000F Select the bin with the required form.
        case formSource = 0x000F
    }
    
    /// dmPrintQuality (2 bytes): If the DM_PRINTQUALITY bit is set in the dmFields field, this field specifies the printer resolution. The value of
    /// this field MUST be either a positive value that specifies a device-dependent resolution in dots per inch (DPI) or one of the following four
    /// predefined device-independent values that are mapped to a device-specific resolution in an implementation-specific manner.
    public enum PrintQuality: UInt16 {
        /// DMRES_HIGH 0xFFFC High-resolution printouts
        case high = 0xFFFC
        
        /// DMRES_MEDIUM 0xFFFD Medium-resolution printouts
        case medium = 0xFFFD
        
        /// DMRES_LOW 0xFFFE Low-resolution printouts
        case low = 0xFFFE
        
        /// DMRES_DRAFT 0xFFFF Draft-resolution printouts
        case draft = 0xFFFF
    }
    
    /// dmColor (2 bytes): If the DM_COLOR bit is set in the dmFields field, this field specifies the color mode to use with color printers. The
    /// value of this field MUST be one of the following.
    public enum Color: UInt16, DataStreamCreatable {
        /// DMRES_MONOCHROME 0x0001 Use monochrome printing mode.
        case monochrome = 0x0001
    
        /// DMRES_COLOR 0x0002 Use color printing mode.
        case color = 0x0002
    }
    
    /// dmDuplex (2 bytes): If the DM_DUPLEX bit is set in the dmFields field, this field specifies duplex or double-sided printing for printers that
    /// are capable of duplex printing. The value of this field MUST be one of the following.
    public enum Duplex: UInt16 {
        /// DMDUP_SIMPLEX 0x0001 Normal (non-duplex) printing.
        case simplex = 0x0001
    
        /// DMDUP_VERTICAL 0x0002 Long-edge binding; that is, the long edge of the page is vertical.
        case vertical = 0x0002
        
        /// DMDUP_HORIZONTAL 0x0003 Short-edge binding; that is, the long edge of the page is horizontal.
        case horizontal = 0x0003
    }
    
    /// dmTTOption (2 bytes): If the DM_TTOPTION bit is set in the dmFields field, this field specifies how TrueType fonts MUST be printed.
    /// The value of this field MUST be one of the following.
    public enum TTOption: UInt16 {
        /// DMTT_BITMAP 0x0001 Prints TrueType fonts as graphics. This is the default action for dot-matrix printers.
        case bitmap = 0x0001
        
        /// DMTT_DOWNLOAD 0x0002 Downloads TrueType fonts as soft fonts. This is the default action for Hewlett-Packard printers that
        /// use printer control language (PCL).
        case download = 0x0002
        
        /// DMTT_SUBDEV 0x0003 Substitutes device fonts for TrueType fonts. This is the default action for PostScript printers.
        case subDev = 0x0003
        
        /// DMTT_DOWNLOAD_OUTLINE 0x0004 Downloads TrueType fonts as outline soft fonts.<96>
        case downloadOutline = 0x0004
    }
    
    /// dmCollate (2 bytes): If the DM_COLLATE bit is set in the dmFields field, this field specifies whether collation is used when printing multiple
    /// copies. The value of this field is one of the following:
    public enum Collate: UInt16 {
        /// DMCOLLATE_FALSE 0x0000 Do not collate when printing multiple copies.
        case `false` = 0x0000
        
        /// DMCOLLATE_TRUE 0x0001 Collate when printing multiple copies.
        case `true` = 0x0001
    }
    
    /// dmNup (4 bytes): If the DM_NUP bit is set in the dmFields, this field specifies the responsibility for performing page layout for N-Up
    /// Printing. It is one of the following values:
    public enum Nup: UInt16 {
        /// DMNUP_SYSTEM 0x00000001 The print server does the page layout.
        case system = 0x00000001
        
        /// DMNUP_ONEUP 0x00000002 The application does the page layout.
        case oneUp = 0x00000002
    }
    
    /// dmICMMethod (4 bytes): If the DM_ICMMETHOD bit is set in the dmFields field, this field specifies how Image Color Management (ICM)
    /// is handled. For a non-ICM application, this field determines if ICM is enabled or disabled. For ICM applications, the system examines
    /// this field to determine how to handle ICM support. The value of this field is one of the following predefined values or a printer driver-defined
    /// value greater than or equal to 0x00000100.
    public enum ICMMethod: UInt32 {
        /// DMICMMETHOD_NONE 0x00000001 Specifies that ICM is disabled.
        case none = 0x00000001
        
        /// DMICMMETHOD_SYSTEM 0x00000002 Specifies that ICM is handled by the system on which the page description language (PDL)
        /// data is generated.
        case system = 0x00000002
        
        /// DMICMMETHOD_DRIVER 0x00000003 Specifies that ICM is handled by the printer driver.
        case driver = 0x00000003
        
        /// DMICMMETHOD_DEVICE 0x00000004 Specifies that ICM is handled by the destination device.
        case device = 0x00000004
    }
    
    /// dmICMIntent (4 bytes): If the DM_ICMINTENT bit is set in the dmFields field, this field specifies which color matching method, or intent,
    /// is used by default. This field is primarily for non-ICM applications. ICM applications can establish intents by using the ICM functions.
    /// The value of this field is one of the following predefined values, or a printer driver defined value greater than or equal to 0x00000100.
    public enum ICMIntent: UInt32 {
        /// DMICM_SATURATE 0x00000001 Color matching SHOULD be optimized for color saturation.
        case saturate = 0x00000001
        
        /// DMICM_CONTRAST 0x00000002 Color matching SHOULD optimize for color contrast.
        case contrast = 0x00000002
        
        /// DMICM_COLORIMETRIC 0x00000003 Color matching SHOULD optimize to match the exact color requested.
        case colorIMetric = 0x00000003
        
        /// DMICM_ABS_COLORIMETRIC 0x00000004 Color matching SHOULD optimize to match the exact color requested without white
        /// point mapping.
        case absColorIMetric = 0x00000004
    }
    
    /// dmMediaType (4 bytes): If the DM_MEDIATYPE bit is set in the dmFields field, this field specifies the type of media to print on. The value
    /// of this field is one of the following predefined values or else a printer driver-defined value greater than or equal to 0x00000100.
    public enum MediaType: UInt32 {
        /// DMMEDIA_STANDARD 0x00000001 Plain paper
        case standard = 0x00000001
        
        /// DMMEDIA_TRANSPARENCY 0x00000002 Transparent film
        case transparency = 0x00000002
        
        /// DMMEDIA_GLOSSY 0x00000003 Glossy paper
        case glossy = 0x00000003
    }
    
    /// dmDitherType (4 bytes): If the DM_DITHERTYPE bit is set in the dmFields field, this field specifies how dithering is to be done. The value
    /// of this field is one of the following predefined values or else a printer driver-defined value greater than or equal to 0x00000100.
    public enum DitherType: UInt32 {
        /// DMDITHER_NONE 0x00000001 No dithering.
        case none = 0x00000001

        /// DMDITHER_COARSE 0x00000002 Dithering with a coarse brush.
        case coarse = 0x00000002

        /// DMDITHER_FINE 0x00000003 Dithering with a fine brush.
        case fine = 0x00000003

        /// DMDITHER_LINEART 0x00000004 Line art dithering, a special dithering method that produces well defined borders between
        /// black, white, and gray scaling.
        case lineArt = 0x00000004

        /// DMDITHER_ERRORDIFFUSION 0x00000005 Error diffusion dithering.<97>
        case errorDiffusion = 0x00000005

        /// DMDITHER_RESERVED6 0x00000006 Same as DMDITHER_LINEART.
        case reserved6 = 0x00000006

        /// DMDITHER_RESERVED7 Same as DMDITHER_LINEART. 0x00000007
        case reserved7 = 0x00000007
        
        /// DMDITHER_RESERVED8 0x00000008 Same as DMDITHER_LINEART.
        case reserved8 = 0x00000008
        
        /// DMDITHER_RESERVED9 0x00000009 Same as DMDITHER_LINEART.
        case reserved9 = 0x00000009

        /// DMDITHER_GRAYSCALE 0x0000000A Device does gray scaling.
        case grayscale = 0x0000000A
    }
}
