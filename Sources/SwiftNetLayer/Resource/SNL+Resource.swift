//
//  File.swift
//
//
//  Created by Oleh Hudeichuk on 17.12.2019.
//

import Foundation

open class SNLResource: SNLResourcePrtcl {

    public var provider: SNLProviderPrtcl
    public var `protocol`: SNLProtocolType
    public var domain: String
    public var version: String?
    public var defaultHeaders: [String: String]?
    public var defaultParams: [String: Any]?
    public var url: URL {
        let version = self.version != nil ? "/\(self.version!)" : ""
        guard let url = URL(string: "\(`protocol`)://\(domain)\(version)") else { fatalError("NetResource: Bad URL") }
        return url
    }

    public init(provider: SNLProviderPrtcl = SNLProvider(),
                protocol: SNLProtocolType = .http,
                domain: String,
                version: String? = nil,
                defaultHeaders: [String: String]? = nil,
                defaultParams: [String: Any]? = nil)
    {
        self.provider = provider
        self.protocol = `protocol`
        self.domain = domain
        self.version = version
        self.defaultHeaders = defaultHeaders
        self.defaultParams = defaultParams
    }
}
