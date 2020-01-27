//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 27.01.2020.
//

import Foundation

public enum SNLHeaderName: String, CustomStringConvertible {
    case aIM = "A-IM"
    case accept = "Accept"
    case acceptCharset = "Accept-Charset"
    case acceptEncoding = "Accept-Encoding"
    case acceptLanguage = "Accept-Language"
    case acceptDatetime = "Accept-Datetime"
    case accessControlRequestMethod = "Access-Control-Request-Method"
    case accessControlRequestHeaders = "Access-Control-Request-Headers"
    case authorization = "Authorization"
    case cacheControl = "Cache-Control"
    case connection = "Connection"
    case contentLength = "Content-Length"
    case contentType = "Content-Type"
    case cookie = "Cookie"
    case date = "Date"
    case expect = "Expect"
    case forwarded = "Forwarded"
    case from = "From"
    case host = "Host"
    case ifMatch = "If-Match"
    case ifModifiedSince = "If-Modified-Since"
    case ifNoneMatch = "If-None-Match"
    case ifRange = "If-Range"
    case mfUnmodifiedSince = "If-Unmodified-Since"
    case maxForwards = "Max-Forwards"
    case origin = "Origin"
    case pragma = "Pragma"
    case proxyAuthorization = "Proxy-Authorization"
    case range = "Range"
    case referer = "Referer"
    case tE = "TE"
    case userAgent = "User-Agent"
    case upgrade = "Upgrade"
    case via = "Via"
    case warning = "Warning"

    public var description: String { self.rawValue }
}
