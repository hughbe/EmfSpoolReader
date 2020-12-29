@testable import EmfSpoolReader
import DataStream
import XCTest

final class EMRI_DEVMODETests: XCTestCase {
    func testExample() throws {
        do {
            /// [MS-EMFSPOOL] 3.2.4 EMRI_DEVMODE Example 1
            /// This section provides an example of the EMRI_DEVMODE record (section 2.2.3.5).
            let data: [UInt8] = [
                0x03, 0x00, 0x00, 0x00, 0x40, 0x04, 0x00, 0x00, 0x5C, 0x00, 0x5C, 0x00,
                0x70, 0x00, 0x72, 0x00, 0x69, 0x00, 0x6E, 0x00, 0x74, 0x00, 0x65, 0x00, 0x72, 0x00, 0x73, 0x00,
                0x65, 0x00, 0x72, 0x00, 0x76, 0x00, 0x65, 0x00, 0x72, 0x00, 0x5C, 0x00, 0x43, 0x00, 0x61, 0x00,
                0x6E, 0x00, 0x6F, 0x00, 0x6E, 0x00, 0x20, 0x00, 0x42, 0x00, 0x75, 0x00, 0x62, 0x00, 0x62, 0x00,
                0x6C, 0x00, 0x65, 0x00, 0x2D, 0x00, 0x4A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x04, 0x00, 0x06,
                0xDC, 0x00, 0x64, 0x03, 0x43, 0xEF, 0x80, 0x07, 0x01, 0x00, 0x01, 0x00, 0xEA, 0x0A, 0x6F, 0x08,
                0x64, 0x00, 0x01, 0x00, 0x0F, 0x00, 0xFD, 0xFF, 0x02, 0x00, 0x01, 0x00, 0xFD, 0xFF, 0x02, 0x00,
                0x01, 0x00, 0x4C, 0x00, 0x65, 0x00, 0x74, 0x00, 0x74, 0x00, 0x65, 0x00, 0x72, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00,
                0x01, 0x00, 0x00, 0x00, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x44, 0x49, 0x4E, 0x55, 0x22, 0x00, 0x00, 0x01,
                0x44, 0x02, 0x18, 0x00, 0x59, 0xD8, 0xB0, 0x99, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x03, 0x00, 0x01, 0x00,
                0x01, 0x00, 0x02, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x53, 0x4D, 0x54, 0x4A, 0x18, 0x00, 0x00, 0x00,
                0x4E, 0x55, 0x4A, 0x42, 0x00, 0x00, 0x01, 0x00, 0x34, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x08, 0x01, 0x00, 0x00, 0x53, 0x4D, 0x54, 0x4A, 0x00, 0x00, 0x00, 0x00,
                0x14, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF4, 0x00, 0x43, 0x00, 0x61, 0x00, 0x6E, 0x00, 0x6F, 0x00,
                0x6E, 0x00, 0x20, 0x00, 0x42, 0x00, 0x75, 0x00, 0x62, 0x00, 0x62, 0x00, 0x6C, 0x00, 0x65, 0x00,
                0x2D, 0x00, 0x4A, 0x00, 0x65, 0x00, 0x74, 0x00, 0x20, 0x00, 0x42, 0x00, 0x4A, 0x00, 0x43, 0x00,
                0x2D, 0x00, 0x35, 0x00, 0x30, 0x00, 0x00, 0x00, 0x49, 0x6E, 0x70, 0x75, 0x74, 0x42, 0x69, 0x6E,
                0x00, 0x4D, 0x41, 0x4E, 0x55, 0x41, 0x4C, 0x00, 0x52, 0x45, 0x53, 0x44, 0x4C, 0x4C, 0x00, 0x55,
                0x6E, 0x69, 0x72, 0x65, 0x73, 0x44, 0x4C, 0x4C, 0x00, 0x50, 0x61, 0x70, 0x65, 0x72, 0x53, 0x69,
                0x7A, 0x65, 0x00, 0x4C, 0x45, 0x54, 0x54, 0x45, 0x52, 0x00, 0x52, 0x65, 0x73, 0x6F, 0x6C, 0x75,
                0x74, 0x69, 0x6F, 0x6E, 0x00, 0x53, 0x54, 0x41, 0x4E, 0x44, 0x41, 0x52, 0x44, 0x00, 0x4D, 0x65,
                0x64, 0x69, 0x61, 0x54, 0x79, 0x70, 0x65, 0x00, 0x53, 0x54, 0x41, 0x4E, 0x44, 0x41, 0x52, 0x44,
                0x00, 0x43, 0x6F, 0x6C, 0x6F, 0x72, 0x4D, 0x6F, 0x64, 0x65, 0x00, 0x43, 0x4D, 0x59, 0x4B, 0x32,
                0x34, 0x00, 0x48, 0x61, 0x6C, 0x66, 0x74, 0x6F, 0x6E, 0x65, 0x00, 0x48, 0x54, 0x5F, 0x50, 0x41,
                0x54, 0x53, 0x49, 0x5A, 0x45, 0x5F, 0x41, 0x55, 0x54, 0x4F, 0x00, 0x4F, 0x72, 0x69, 0x65, 0x6E,
                0x74, 0x61, 0x74, 0x69, 0x6F, 0x6E, 0x00, 0x50, 0x4F, 0x52, 0x54, 0x52, 0x41, 0x49, 0x54, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
            ]
            var dataStream = DataStream(data)
            let record = try EMRI_DEVMODE(dataStream: &dataStream)
            XCTAssertEqual(.EMRI_DEVMODE, record.ulID)
            XCTAssertEqual(0x00000440, record.cjSize)
            XCTAssertEqual("\\\\printerserver\\Canon Bubble-J", record.devmode.dmDeviceName)
            XCTAssertEqual(0x0401, record.devmode.dmSpecVersion)
            XCTAssertEqual(0x0600, record.devmode.dmDriverVersion)
            XCTAssertEqual(0x00DC, record.devmode.dmSize)
            XCTAssertEqual(0x0364, record.devmode.dmDriverExtra)
            XCTAssertEqual(0x43EF8007, record.devmode.dmFields.rawValue)
            XCTAssertTrue(record.devmode.dmFields.contains(.nup))
            XCTAssertTrue(record.devmode.dmFields.contains(.paperSize))
            XCTAssertTrue(record.devmode.dmFields.contains(.orientation))
            XCTAssertTrue(record.devmode.dmFields.contains(.collate))
            XCTAssertTrue(record.devmode.dmFields.contains(.ttOption))
            XCTAssertTrue(record.devmode.dmFields.contains(.yResolution))
            XCTAssertTrue(record.devmode.dmFields.contains(.color))
            XCTAssertTrue(record.devmode.dmFields.contains(.printQuality))
            XCTAssertTrue(record.devmode.dmFields.contains(.defaultSource))
            XCTAssertTrue(record.devmode.dmFields.contains(.copies))
            XCTAssertTrue(record.devmode.dmFields.contains(.icmMethod))
            XCTAssertTrue(record.devmode.dmFields.contains(.ditherType))
            XCTAssertTrue(record.devmode.dmFields.contains(.mediaType))
            XCTAssertTrue(record.devmode.dmFields.contains(.icmIntent))
            XCTAssertEqual(0x0001, record.devmode.dmOrientation)
            XCTAssertEqual(0x0001, record.devmode.dmPaperSize)
            XCTAssertEqual(0x0AEA, record.devmode.dmPaperLength)
            XCTAssertEqual(0x086F, record.devmode.dmPaperWidth)
            XCTAssertEqual(0x0064, record.devmode.dmScale)
            XCTAssertEqual(0x0001, record.devmode.dmCopies)
            XCTAssertEqual(0x000F, record.devmode.dmDefaultSource)
            XCTAssertEqual(0xFFFD, record.devmode.dmPrintQuality)
            XCTAssertEqual(.color, record.devmode.dmColor)
            XCTAssertEqual(0x0001, record.devmode.dmDuplex)
            XCTAssertEqual(0xFFFD, record.devmode.dmYResolution)
            XCTAssertEqual(0x0002, record.devmode.dmTTOption)
            XCTAssertEqual(0x0001, record.devmode.dmCollate)
            XCTAssertEqual("Letter", record.devmode.dmFormName)
            XCTAssertEqual(0x0000, record.devmode.reserved0)
            XCTAssertEqual(0x00000000, record.devmode.reserved1)
            XCTAssertEqual(0x00000000, record.devmode.reserved2)
            XCTAssertEqual(0x00000000, record.devmode.reserved3)
            XCTAssertEqual(0x00000001, record.devmode.dmNup)
            XCTAssertEqual(0x00000000, record.devmode.reserved4)
            XCTAssertEqual(0x00000002, record.devmode.dmICMMethod)
            XCTAssertEqual(0x00000002, record.devmode.dmICMIntent)
            XCTAssertEqual(0x00000001, record.devmode.dmMediaType)
            XCTAssertEqual(0x00000101, record.devmode.dmDitherType)
            XCTAssertEqual(0x00000000, record.devmode.reserved5)
            XCTAssertEqual(0x00000000, record.devmode.reserved6)
            XCTAssertEqual(0x00000000, record.devmode.reserved7)
            XCTAssertEqual(0x00000000, record.devmode.reserved8)
            XCTAssertTrue(record.devmode.dmDriverExtraData.count == 868)
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
