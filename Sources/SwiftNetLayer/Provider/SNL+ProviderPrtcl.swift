//
//  SNL+ProviderPrtcl.swift
//  
//
//  Created by Oleh Hudeichuk on 17.12.2019.
//

import Foundation
import SwiftExtensionsPack

public protocol SNLProviderPrtcl {

    init()

    func executeRequest(url: URL,
                        method: String,
                        headers: [String: String]?,
                        params: [String: Any]?,
                        body: Data?,
                        multipart: Bool,
                        _ handler: @escaping (Data?, URLResponse?, Error?) -> Void) throws

    func executeRequest(resource: SNLResourcePrtcl, request: SNLRequestPrtcl, _ handler: @escaping (Data?, URLResponse?, Error?) -> Void) throws
}


// MARK: Default Realisation NetProviderPrtcl

public extension SNLProviderPrtcl {

    func executeRequest(url: URL,
                        method: String,
                        headers: [String: String]?,
                        params: [String: Any]?,
                        body: Data?,
                        multipart: Bool,
                        _ handler: @escaping (Data?, URLResponse?, Error?) -> Void) throws
    {
        try Net.sendRequest(url: url.absoluteString,
                        method: method,
                        headers: headers,
                        params: params,
                        body: body,
                        multipart: multipart)
        { (data, urlResponse, error) -> Void in
            handler(data, urlResponse, error)
        }
    }
}
