//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 17.12.2019.
//

import Foundation

public protocol SNLResourcePrtcl {

    var provider: SNLProviderPrtcl { get set }
    var `protocol`: SNLProtocolType { get set }
    var domain: String { get set }
    var version: String? { get set }
    var defaultHeaders: [String: String]? { get set }
    var defaultParams: [String: Any]? { get set }
    var url: URL { get }
}

public extension SNLResourcePrtcl {

    var url: URL {
        let version = self.version != nil ? "/\(self.version!)" : ""
        guard let url = URL(string: "\(`protocol`)://\(domain)\(version)") else { fatalError("NetResource: Bad URL") }
        return url
    }
}
