import XCTest
import DataStream
import EmfReader
import EmfPlusReader
import WmfReader
@testable import EmfSpoolReader

final class DumpFileTests: XCTestCase {
    func testDumpEmfSpool() throws {
        /// Not seen:
        /// - EMRI_BW_METAFILE
        for (name, fileExtension) in [
            /*
            ("EMF_SPL-to-EMF_00035", "SPL"),
            ("EMFSpoolfileReader_00003", "SPL"),
            ("EMFSpoolfileReader_00004", "SPL"),
            ("EMFSpoolfileReader_00005", "SPL"),
            ("export_FP00000", "SPL"),
            ("export_FP00001", "SPL"),
            ("export_0000s10", "SPL"),
            ("export_FP00002", "SPL"),
            */
            ("export_FP00003", "SPL"),
            ("export_FP00004", "SPL"),
        ] {
            func dumpWmf(file: WmfFile) throws {
                try file.enumerateRecords { record in
                    print(record)
                    return .continue
                }
            }

            func dumpEmfPlus(file: EmfPlusFile) throws {
                try file.enumerateRecords { record in
                    if case let .object(object) = record {
                        if case .continues = object.objectData {
                            return .continue
                        }
                        if case let .image(image) = object.objectData,
                           case let .metafile(metafile) = image.imageData {
                            var metafileDataStream = DataStream(metafile.metafileData)
                            switch metafile.type {
                            case .wmf, .wmfPlaceable:
                                let wmfFile = try WmfFile(dataStream: &metafileDataStream)
                                try dumpWmf(file: wmfFile)
                            case .emf, .emfPlusDual, .emfPlusOnly:
                                let emfFile = try EmfFile(dataStream: &metafileDataStream)
                                try dumpEmf(file: emfFile)
                            }
                        }
                    }

                    print(record)
                    return .continue
                }
            }
            
            func dumpEmf(file: EmfFile) throws {
                var emfPlusData = Data()
                var emfSpoolData = Data()
                try file.enumerateRecords { record in
                    if case .stretchDIBits = record {
                        print("EMR_STRETCHDIBITS")
                    } else {
                        print(record)
                    }
                    
                    if case let .comment(comment) = record {
                        if case let .commentEmfPlus(emfPlusComment) = comment {
                            emfPlusData += emfPlusComment.emfPlusRecords
                        }
                        if case let .commentEmfSpool(emfSpoolRecord) = comment {
                            emfSpoolData += emfSpoolRecord.emfSpoolRecords
                        }
                    }
                    
                    return .continue
                }
                
                if emfSpoolData.count > 0 {
                    var emfSpoolDataStream = DataStream(emfSpoolData)
                    while emfSpoolDataStream.remainingCount > 0 {
                        let record = try EmfSpoolRecord(dataStream: &emfSpoolDataStream)
                        try dumpEmfSpool(record: record)
                    }
                }
                if emfPlusData.count > 0 {
                    let emfPlusFile = try EmfPlusFile(data: emfPlusData)
                    try dumpEmfPlus(file: emfPlusFile)
                }
            }
            
            func dumpEmfSpool(record: EmfSpoolRecord) throws {
                if case .engineFont = record {
                    print("engineFont")
                } else {
                    print(record)
                }

                if case let .metafileData(pageRecord) = record {
                    if case let .emf(emfFile) = pageRecord.emfMetafile {
                        try dumpEmf(file: emfFile)
                    }
                }
            }

            func dumpEmfSpool(file: EmfSpoolFile) throws {
                try file.enumerateRecords { record in
                    try dumpEmfSpool(record: record)
                    return .continue
                }
            }
            
            let data = try getData(name: name, fileExtension: fileExtension)
            let file = try EmfSpoolFile(data: data)
            try dumpEmfSpool(file: file)
        }
    }

    static var allTests = [
        ("testDumpEmfSpool", testDumpEmfSpool),
    ]
}
