//
//  DataStreamAlign.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

internal extension DataStream {
    mutating func readFourByteAlignmentPadding(startPosition: Int) throws {
        try readByteAlignmentPadding(startPosition: startPosition, alignTo: 4)
    }
    
    mutating func readEightByteAlignmentPadding(startPosition: Int) throws {
        try readByteAlignmentPadding(startPosition: startPosition, alignTo: 8)
    }

    mutating func readByteAlignmentPadding(startPosition: Int, alignTo: Int) throws {
        let excessBytes = (position - startPosition) % alignTo
        if excessBytes > 0 {
            let padding = alignTo - excessBytes
            guard position + padding <= count else {
                throw EmfSpoolReadError.corrupted
            }
            
            position += padding
        }
    }
}
