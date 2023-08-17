//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 17.08.2023.
//

import Foundation
import SwiftExtensionsPack

public struct SNLError: ErrorCommon {
    public var title: String = "SNLError"
    public var reason: String = ""
    public init() {}
}
