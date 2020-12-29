@testable import EmfSpoolReader
import DataStream
import XCTest

final class EMRI_ENGINE_FONTTests: XCTestCase {
    func testExample() throws {
        do {
            /// [MS-EMFSPOOL] 3.2.2.20.1 EMRI_ENGINE_FONT Example
            /// This section provides an example of an EMRI_ENGINE_FONT font definition record, as specified in section 2.2.3.3.1.
            let data: [UInt8] = [
                0x02, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00,
                0xc0, 0x3e, 0x06, 0x00, 0x00, 0x00, 0x00, 0x00
            ]
            var dataStream = DataStream(data)
            let record = try EMRI_ENGINE_FONT(dataStream: &dataStream)
            XCTAssertEqual(.EMRI_ENGINE_FONT, record.ulID)
            XCTAssertEqual(0x0000010, record.cjSize)
            XCTAssertEqual(0x00000000, record.type1ID)
            XCTAssertEqual(0x00000001, record.numFiles)
            XCTAssertEqual([0x00063EC0], record.fileSizes)
            XCTAssertEqual([], record.fileContent)
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
