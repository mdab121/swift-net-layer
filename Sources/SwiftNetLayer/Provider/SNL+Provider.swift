//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 17.12.2019.
//

import Foundation

open class SNLProvider: SNLProviderPrtcl {

    required public init() {}

    public func executeRequest(resource: SNLResourcePrtcl, request: SNLRequestPrtcl, _ handler: @escaping (Data?, URLResponse?, Error?) -> Void) throws -> Void
    {
        try executeRequest(url: fullURL(resource, request),
                           method: request.method.rawValue,
                           headers: request.headers,
                           params: request.params,
                           body: request.body,
                           multipart: request.multipart)
        { (data, urlResponse, error) -> Void in
            handler(data, urlResponse, error)
        }
    }

    private func fullURL(_ resource: SNLResourcePrtcl, _ request: SNLRequestPrtcl) -> URL {
        var path = request.path.absoluteString
        if !path["^\\/"] { path = "/\(path)" }
        guard let newURL = URL(string: "\(resource.url.absoluteString)\(path)") else {
            fatalError("NetProvider: Bad new URL")
        }

        return newURL
    }
}
