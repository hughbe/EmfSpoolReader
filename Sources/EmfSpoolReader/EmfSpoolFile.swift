//
//  EmfSpoolFile.swift
//
//
//  Created by Hugh Bellamy on 30/11/2020.
//

import DataStream
import Foundation

/// [MS-EMFSPOOL] 1.3 Overview
/// An EMFSPOOL metafile is a sequence of variable-length records that define the page data, page layout, fonts, graphics, and virtual
/// device settings for a print job that renders a graphical image.<1>
/// [MS-EMFSPOOL] 1.3.1 Metafile Structure
/// An EMFSPOOL metafile begins with a header record, which includes the metafile version, its size, the name of the document, and
/// identification of an output device. A metafile is "played back" when its records are parsed and processed, sends the print job to its
/// next destination.
/// EMFSPOOL records contain graphics commands, which specify drawing operations, graphics objects, and properties that define
/// how to render the document, including:
///  The overall structure of the document.
///  The format and content of individual pages.
///  Print device settings, such as paper size.
///  Embedded fonts.
///  Image bitmaps.
///  Injected PostScript commands.
/// This figure shows the following about EMFSPOOL files:
public struct EmfSpoolFile {
    public let header: Header
    private let data: DataStream

    public init(data: Data) throws {
        var dataStream = DataStream(data)
        try self.init(dataStream: &dataStream)
    }

    public init(dataStream: inout DataStream) throws {
        self.header = try Header(dataStream: &dataStream)
        self.data = DataStream(slicing: dataStream, startIndex: dataStream.position, count: dataStream.remainingCount)
    }

    public func enumerateRecords(proc: (EmfSpoolRecord) throws -> MetafileEnumerationStatus) throws {
        var dataStream = self.data
        while dataStream.position < dataStream.count {
            let record = try EmfSpoolRecord(dataStream: &dataStream)
            // Match GDI behaviour by bailing at unknown EMRI_METAFILE records.
            if case let .metafile(pageContentRecord) = record {
                guard case .emf = pageContentRecord.emfMetafile else {
                    return
                }
            }
            
            let result = try proc(record)
            if result == .break {
                break
            }
        }
    }

    public enum MetafileEnumerationStatus {
        case `continue`
        case `break`
    }
}
