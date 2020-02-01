//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 20.01.2020.
//

import Foundation

public struct SNLFile: SNLFilePrtcl {

    public var mimeType: String
    public var data: Data
    public var fileName: String

    public init(data: Data, fileName: String, mimeType: String) {
        self.data = data
        self.fileName = fileName
        self.mimeType = mimeType
    }
}
