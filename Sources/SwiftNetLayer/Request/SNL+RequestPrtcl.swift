//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 17.12.2019.
//

import Foundation

public protocol SNLRequestPrtcl {

    /// method
    var method: SNLHTTPMethod { get set }
    /// path
    var path: URL { get set }
    /// multipart
    var multipart: Bool { get set }
    /// user/:id
    var dynamicPathsParts: [String: String] { get set }
    /// HTTP_HEADER_NAME   VALUE
    var headers: [String: String]? { get set }
    /// ?name=value
    var params: [String: Any]? { get set }
    /// #hash_name
    var hash: String? { get set }
    /// body
    var body: Data? { get set }
    /// files
    var files: SNLFiles? { get set }
    /// session timeoutIntervalForRequest
    var timeoutIntervalForRequest: Double? { get set }
    /// session timeoutIntervalForResource
    var timeoutIntervalForResource: Double? { get set }
}
