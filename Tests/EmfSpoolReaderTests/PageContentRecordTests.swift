@testable import EmfSpoolReader
import DataStream
import XCTest

final class PageContentRecordTests: XCTestCase {
    func testExample() throws {
        do {
            /// [MS-EMFSPOOL] 3.2.2 EMRI_METAFILE_DATA Example 1
            /// This section provides an example of the EMRI_METAFILE_DATA record (section 2.2.3.1).
            let data: [UInt8] = [
                0x0C, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x01, 0x02, 0x03, 0x04
            ]
            var dataStream = DataStream(data)
            let record = try PageContentRecord(dataStream: &dataStream)
            XCTAssertEqual(.EMRI_METAFILE_DATA, record.ulID)
            XCTAssertEqual(0x0000004, record.cjSize)
            guard case let .unknown(metafileData) = record.emfMetafile else {
                fatalError()
            }
            XCTAssertEqual([0x01, 0x02, 0x03, 0x4], metafileData)
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
