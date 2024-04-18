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
//    public var requestPerSecond: UInt
    public var requestLimit: UInt
    public var timeRangeLimitSecond: UInt
    /// nanoseconds - delay before retry request; default: 0.01 s
    public var retryDelaySecond: UInt32
    
    public init(requestLimit: UInt = 100, timeRangeLimitSecond: UInt = 1, retryDelaySecond: UInt32 = 10_000_000) {
        self.requestLimit = requestLimit
        self.timeRangeLimitSecond = timeRangeLimitSecond
        self.retryDelaySecond = retryDelaySecond
    }
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
        let range = currentTime - requestPerSecondOptions.value.lastRequestTime
        if range >= requestPerSecondOptions.value.timeRangeLimitSecond {
            requestPerSecondOptions.change { $0.lastRequestTime = currentTime }
            requestPerSecondOptions.change { $0.requestCounter = 1 }
            allow = true
        }
        if requestPerSecondOptions.value.requestCounter < requestPerSecondOptions.value.requestLimit {
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
                defaultParams: [String: Any]? = nil,
                requestPerSecondOptions: SafeValue<RequestPerSecondOptions>? = nil
    ) {
        self.provider = provider
        self.protocol = `protocol`
        self.domain = domain
        self.version = version
        self.defaultHeaders = defaultHeaders
        self.defaultParams = defaultParams
        self.requestPerSecondOptions = requestPerSecondOptions
    }
}
