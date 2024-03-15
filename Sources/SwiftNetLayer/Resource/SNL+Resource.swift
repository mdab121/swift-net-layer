//
//  File.swift
//
//
//  Created by Oleh Hudeichuk on 17.12.2019.
//

import Foundation
import SwiftExtensionsPack

public struct RequestPerSecondOptions {
    var requestCounter: UInt = .init(0)
    var lastRequestTime: UInt = .init(Date().toSeconds())
    public var requestPerSecond: UInt = 100
    /// usleep - delay before retry request
    public var retryDelaySecond: UInt32 = 10000
}

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
    
    /// Request Per Second WatchDog
    public var requestPerSecondOptions: SafeValue<RequestPerSecondOptions>? = nil
    public var allowRequest: Bool {
        guard let requestPerSecondOptions else { return true }
        let currentTime: UInt = Date().toSeconds()
        var allow: Bool = false
        if currentTime > requestPerSecondOptions.value.lastRequestTime {
            requestPerSecondOptions.change { $0.lastRequestTime = currentTime }
            requestPerSecondOptions.change { $0.requestCounter = 1 }
            allow = true
        }
        if requestPerSecondOptions.value.requestCounter < requestPerSecondOptions.value.requestPerSecond {
            requestPerSecondOptions.change { $0.requestCounter += 1 }
            allow = true
        } else {
            allow = false
        }
        return allow
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
