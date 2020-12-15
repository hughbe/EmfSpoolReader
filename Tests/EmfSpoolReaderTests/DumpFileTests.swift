import XCTest
import EmfReader
@testable import EmfSpoolReader

final class DumpFileTests: XCTestCase {
    func testDumpEmfSpool() throws {
        /// Not seen:
        /// - EMRI_BW_METAFILE
        
        for (name, fileExtension) in [
            ("EMF_SPL-to-EMF_00035", "SPL"),
            ("EMFSpoolfileReader_00003", "SPL"),
            ("EMFSpoolfileReader_00004", "SPL"),
            ("EMFSpoolfileReader_00005", "SPL"),
            ("export_FP00000", "SPL"),
            ("export_FP00001", "SPL"),
            ("export_0000s10", "SPL"),
            ("export_FP00002", "SPL"),
            ("export_FP00003", "SPL"),
            ("export_FP00004", "SPL"),
        ] {
            func printMetafile(metafile: PageContentRecord.EmfMetafile) throws {
                if case let .emf(emf) = metafile {
                    try emf.enumerateRecords { record in
                        if case .stretchDIBits = record {
                            print("EMR_STRETCHDIBITS")
                        } else {
                            print(record)
                        }
                        return .continue
                    }
                }
            }
            
            let data = try getData(name: name, fileExtension: fileExtension)
            let file = try EmfSpoolFile(data: data)
            try file.enumerateRecords { record in
                print(record)

                if case let .metafileData(pageRecord) = record {
                    try printMetafile(metafile: pageRecord.emfMetafile)
                }

                return .continue
            }
        }
    }

    static var allTests = [
        ("testDumpEmfSpool", testDumpEmfSpool),
    ]
}
