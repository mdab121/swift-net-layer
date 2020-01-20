//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 17.12.2019.
//

import Foundation

public struct SNLRequest: SNLRequestPrtcl {

    public var method: SNLHTTPMethod
    public var multipart: Bool
    public var headers: [String: String]?
    public var params: [String: Any]?
    public var hash: String?
    public var body: Data?
    public var files: SNLFiles?

    private var _path: URL!
    public var path: URL {
        set { _path = urlWithDynamicPath(path: newValue) }
        get { _path }
    }

    public var dynamicPathsParts: [String: String] {
        didSet {
            _path = urlWithDynamicPath(path: path)
        }
    }

    public init(method: SNLHTTPMethod,
                path: URL,
                multipart: Bool = false,
                dynamicPathsParts: [String: String]?,
                headers: [String: String]? = nil,
                params: [String: Any]? = nil,
                hash: String? = nil,
                body: Data? = nil,
                files: SNLFiles? = nil)
    {
        self.method = method
        self.multipart = multipart
        self.dynamicPathsParts = (dynamicPathsParts != nil ? dynamicPathsParts! : [:])
        self.headers = headers
        self.params = params
        self.hash = hash
        self.body = body
        self.path = path
        self.files = files
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
