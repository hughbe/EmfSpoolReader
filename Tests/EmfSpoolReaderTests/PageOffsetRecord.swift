@testable import EmfSpoolReader
import DataStream
import XCTest

final class PageOffsetRecordTests: XCTestCase {
    func testExample() throws {
        do {
            /// [MS-EMFSPOOL] 3.2.5 EMRI_BW_METAFILE_EXT Example 1
            /// This section provides an example of the EMRI_BW_METAFILE_EXT record, specified in section 2.2.3.2.
            let data: [UInt8] = [
                0x0E, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0xB8, 0x4A, 0x06, 0x00, 0x00, 0x00, 0x00, 0x00
            ]
            var dataStream = DataStream(data)
            let record = try PageOffsetRecord(dataStream: &dataStream)
            XCTAssertEqual(.EMRI_BW_METAFILE_EXT, record.ulID)
            XCTAssertEqual(0x0000008, record.cjSize)
            XCTAssertEqual(0x0000000000064AB8, record.offset)
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
