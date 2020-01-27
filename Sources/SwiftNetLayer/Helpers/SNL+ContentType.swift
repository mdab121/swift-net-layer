//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 27.01.2020.
//

import Foundation

enum SNLContentType: String, CustomStringConvertible {

    // APPLICATION
    case applicationAtom = "application/atom+xml"
    case applicationEDIX12 = "application/EDI-X12"
    case applicationEDIFACT = "application/EDIFACT"
    case applicationJson = "application/json"
    case applicationJavascript = "application/javascript"
    case applicationOctetStream = "application/octet-stream"
    case applicationOgg = "application/ogg"
    case applicationPDF = "application/pdf"
    case applicationPostScript = "application/postscript"
    case applicationSOAP = "application/soap+xml"
    case applicationFontWoff = "application/font-woff"
    case applicationxXHTML = "application/xhtml+xml"
    case applicationDTD = "application/xml-dtd"
    case applicationXOP = "application/xop+xml"
    case applicationZIP = "application/zip"
    case applicationGzip = "application/gzip"
    case applicationBitTorrent = "application/x-bittorrent"
    case applicationTeX = "application/x-tex"
    case applicationXML = "application/xml"
    case applicationDOC = "application/msword"

    // X
    case applicationXFormEncodedData = "application/x-www-form-urlencoded"
    case applicationXDVI = "application/x-dvi"
    case applicationXLaTeX = "application/x-latex"
    case applicationXTrueType = "application/x-font-ttf"
    case applicationXAdobeFlash = "application/x-shockwave-flash"
    case applicationXStuffIt = "application/x-stuffit"
    case applicationXRAR = "application/x-rar-compressed"
    case applicationXTarball = "application/x-tar"
    case applicationXJQuery = "text/x-jquery-tmpl"
    case applicationXJavascript = "application/x-javascript"

    // IMAGE
    case imageGIF = "image/gif"
    case imageJPEG = "image/jpeg"
    case imagePJPEG = "image/pjpeg"
    case imagePNG = "image/png"
    case imageSVG = "image/svg+xml"
    case imageTIFF = "image/tiff"
    case imageICO = "image/vnd.microsoft.icon"
    case imageWBMP = "image/vnd.wap.wbmp"
    case imageWebP = "image/webp"

    // MULTIPART
    case multipartMixed = "multipart/mixed"
    case multipartAlternative = "multipart/alternative"
    case multipartRelated = "multipart/related"
    case multipartFormData = "multipart/form-data"
    case multipartSigned = "multipart/signed"
    case multipartEncrypted = "multipart/encrypted"

    // TEXT
    case textCMD = "text/cmd"
    case textCSS = "text/css"
    case textCSV = "text/csv"
    case textHTML = "text/html"
    case textJavaScript = "text/javascript"
    case textPlain = "text/plain"
    case textPHP = "text/php"
    case textXML = "text/xml"
    case textMarkdown = "text/markdown"
    case textCacheManifest = "text/cache-manifest"

    public var description: String { self.rawValue }
}
