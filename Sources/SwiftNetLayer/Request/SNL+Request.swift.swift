//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 17.12.2019.
//

import Foundation

public struct SNLRequest: SNLRequestPrtcl {

    public var method: SNLHTTPMethod
    public var path: URL {
        willSet {
            let value = urlWithDynamicPath(path: newValue)
            if value != newValue {
                self.path = value
            }
        }
    }
    public var dynamicPathsParts: [String: String] {
        didSet {
            let value = urlWithDynamicPath(path: path)
            if value != path {
                self.path = value
            }
        }
    }
    public var multipart: Bool
    public var headers: [String: String]?
    public var params: [String: Any]?
    public var hash: String?
    public var body: Data?

    public init(method: SNLHTTPMethod,
                path: URL,
                multipart: Bool = false,
                dynamicPathsParts: [String: String] = [:],
                headers: [String: String]? = nil,
                params: [String: Any]? = nil,
                hash: String? = nil,
                body: Data? = nil)
    {
        self.method = method
        self.path = path
        self.multipart = multipart
        self.dynamicPathsParts = dynamicPathsParts
        self.headers = headers
        self.params = params
        self.hash = hash
        self.body = body
        updatePath()
    }

    private mutating func updatePath() {
        self.path = replacePathsPart(path: path.absoluteString, parts: dynamicPathsParts)
    }

    private func urlWithDynamicPath(path: URL) -> URL {
        return replacePathsPart(path: path.absoluteString, parts: dynamicPathsParts)
    }

    private func replacePathsPart(path: String, parts: [String: String]) -> URL {
        var resultPath = path
        let pattern = "\\/(:[\\s\\S]+?)(\\/|$)"
        guard path[pattern] else {
            guard let url = URL(string: path) else { fatalError("NetRequest: Bad PATH") }
            return url
        }

        for var key in (path.matchesWithRange(pattern) as [Range<String.Index>: String]).values {
            key = key.regexp(pattern)[1] ?? ""
            guard let part = parts[key] else {
                resultPath.replaceAllSelf(key, "")
                continue
            }
            resultPath.replaceAllSelf(key, part)
        }

        resultPath.replaceAllSelf("//", "/")
        resultPath.replaceSelf("/$", "")
        guard let url = URL(string: resultPath) else { fatalError("NetRequest: Bad PATH") }

        return url
    }
}
