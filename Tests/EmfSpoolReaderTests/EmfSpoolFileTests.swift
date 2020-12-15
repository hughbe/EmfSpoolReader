@testable import EmfSpoolReader
import XCTest

final class MetafileTests: XCTestCase {
    func testExample() throws {
        do {
            let data = try getData(name: "EMF_SPL-to-EMF_00035", fileExtension: "SPL")
            let file = try EmfSpoolFile(data: data)
            print(file)
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
