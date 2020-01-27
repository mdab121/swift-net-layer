//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 17.12.2019.
//

import Foundation

public enum SNLHTTPMethod: String, CustomStringConvertible {
    case get
    case post
    case delete
    case patch
    case put

    public var description: String { self.rawValue.uppercased() }
}
