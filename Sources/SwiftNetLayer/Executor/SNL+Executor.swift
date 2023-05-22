//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 19.12.2019.
//

import Foundation
import SwiftExtensionsPack

public struct SNLExecutor: SNLExecutorPrtcl {
    public var resource: SNLResourcePrtcl
    public var method: SNLHTTPMethod
    public var path: URL
    public var multipart: Bool
    public var dynamicPathsParts: SNLDynamicParts?
    public var targetHeaders: SNLHeader?
    public var targetParams: SNLParams?
    public var requestHeaders: SNLHeader?
    public var requestParams: SNLParams?
    public var body: SNLBody?
    public var files: SNLFiles?
    public var timeoutIntervalForRequest: Double?
    public var timeoutIntervalForResource: Double?

    public func execute(_ handler: @escaping (Data?, URLResponse?, Error?) throws -> Void) throws {
        let provider = resource.provider
        let request = makeRequest()
        try provider.executeRequest(resource: resource, request: request, handler)
    }

    public func execute<ResponseModel: Decodable>(model: ResponseModel.Type,
                                                  _ handler: @escaping (ResponseModel?, URLResponse?, Error?) throws -> Void) throws
    {
        let provider = resource.provider
        let request = makeRequest()
        try provider.executeRequest(resource: resource, request: request) { (data, response, error) in
            do {
                guard let data = data else {
                    try handler(nil, response, error)
                    return
                }
                let object = try JSONDecoder().decode(model, from: data)
                try handler(object, response, error)
            } catch let error {
                try? handler(nil, response, error)
            }
        }
    }
    
    @available(iOS 13, *)
    @available(macOS 12, *)
    @discardableResult
    public func execute() async throws -> (Data?, URLResponse) {
        let provider = resource.provider
        let request = makeRequest()
        return try await provider.executeRequest(resource: resource, request: request)
    }
    
    @available(iOS 13, *)
    @available(macOS 12, *)
    @discardableResult
    public func execute<ResponseModel: Decodable>(model: ResponseModel.Type) async throws -> (ResponseModel?, URLResponse) {
        let provider = resource.provider
        let request = makeRequest()
        let out = try await provider.executeRequest(resource: resource, request: request)
        guard let data = out.0 else { return (nil, out.1) }
        do {
            let object = try JSONDecoder().decode(model, from: data)
            return (object, out.1)
        } catch {
            let dataString: String? = String(data: data, encoding: .utf8)
            throw SEPCommonError.mess("\(dataString ?? "") \(String(describing: error))")
        }
    }

    public func waitExecute(_ handler: @escaping (Data?, URLResponse?, Error?) throws -> Void) throws {
        let waitGroup = DispatchGroup()
        waitGroup.enter()
        try execute({ (data, response, error) in
            try handler(data, response, error)
            waitGroup.leave()
        })
        waitGroup.wait()
    }

    public func waitExecute<ResponseModel: Decodable>(model: ResponseModel.Type,
                                                      _ handler: @escaping (ResponseModel?, URLResponse?, Error?) throws -> Void) throws
    {
        let waitGroup = DispatchGroup()
        waitGroup.enter()
        try execute(model: model) { (model, response, error) in
            try handler(model, response, error)
            waitGroup.leave()
        }
        waitGroup.wait()
    }

    private func makeRequest() -> SNLRequestPrtcl {
        let mergedHeaders = mergeHeaders(resource.defaultHeaders, targetHeaders, requestHeaders)
        let mergedParams = mergeParams(resource.defaultParams, targetParams, requestParams)

        return SNLRequest(method: method,
                          path: path,
                          multipart: multipart,
                          dynamicPathsParts: dynamicPathsParts,
                          headers: mergedHeaders,
                          params: mergedParams,
                          hash: nil,
                          body: body,
                          files: files)
    }

    private func mergeHeaders(_ resourceHeaders: SNLHeader?, _ targetHeaders: SNLHeader?, _ requestHeaders: SNLHeader?) -> SNLHeader {
        var resultHeaders = mergeOptionalDictionary(resourceHeaders, targetHeaders)
        resultHeaders = mergeOptionalDictionary(resultHeaders, requestHeaders)
        return mergeOptionalDictionary(resultHeaders, defaultHeaders())
    }

    private func mergeParams(_ resourceParams: SNLParams?, _ targetParams: SNLParams?, _ requestParams: SNLParams?) -> SNLParams {
        let resultParams = mergeOptionalDictionary(resourceParams, targetParams)
        return mergeOptionalDictionary(resultParams, requestParams)
    }

    private func defaultHeaders() -> SNLHeader {
        var defaultHeaders: SNLHeader = [:]
        if body == nil && requestHeaders?[SNLHeaderName.contentType.description] == nil {
            defaultHeaders[SNLHeaderName.contentType.description] = SNLMIMEType.applicationXFormEncodedData.description
        }
        return defaultHeaders
    }

}

