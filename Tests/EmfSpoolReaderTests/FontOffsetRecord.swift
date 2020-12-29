@testable import EmfSpoolReader
import DataStream
import XCTest

final class FontOffsetRecordTests: XCTestCase {
    func testExample() throws {
        do {
            /// [MS-EMFSPOOL] 3.2.3 EMRI_ENGINE_FONT_EXT Example
            /// This section provides an example of the EMRI_ENGINE_FONT_EXT record specified in section 2.2.3.4.
            let data: [UInt8] = [
                0x0F, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x74, 0x43, 0x06, 0x00, 0x00, 0x00, 0x00, 0x00
            ]
            var dataStream = DataStream(data)
            let record = try FontOffsetRecord(dataStream: &dataStream)
            XCTAssertEqual(.EMRI_ENGINE_FONT_EXT, record.ulID)
            XCTAssertEqual(0x0000008, record.cjSize)
            XCTAssertEqual(0x00064374, record.offsetLow)
            XCTAssertEqual(0x00000000, record.offsetHigh)
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
