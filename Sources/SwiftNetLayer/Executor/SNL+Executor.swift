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

    public func execute(_ handler: @escaping (Data?, URLResponse?, Error?) -> Void) throws {
        let provider = resource.provider
        let request = makeRequest()
        try provider.executeRequest(resource: resource, request: request, handler)
    }

    public func execute<ResponseModel: Decodable>(model: ResponseModel.Type,
                                                  _ handler: @escaping (ResponseModel?, URLResponse?, Error?) -> Void) throws
    {
        let provider = resource.provider
        let request = makeRequest()
        try provider.executeRequest(resource: resource, request: request) { (data, response, error) in
            guard let data = data else {
                handler(nil, response, error)
                return
            }
            do {
                let object = try JSONDecoder().decode(model, from: data)
                handler(object, response, error)
            } catch let error {
                handler(nil, response, error)
            }
        }
    }

    public func waitExecute(_ handler: @escaping (Data?, URLResponse?, Error?) -> Void) throws {
        let waitGroup = DispatchGroup()
        waitGroup.enter()
        try execute({ (data, response, error) in
            handler(data, response, error)
            waitGroup.leave()
        })
        waitGroup.wait()
    }

    public func waitExecute<ResponseModel: Decodable>(model: ResponseModel.Type,
                                                      _ handler: @escaping (ResponseModel?, URLResponse?, Error?) -> Void) throws
    {
        let waitGroup = DispatchGroup()
        waitGroup.enter()
        try execute(model: model) { (model, response, error) in
            handler(model, response, error)
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
        let resultHeaders = mergeOptionalDictionary(resourceHeaders, targetHeaders)
        return mergeOptionalDictionary(resultHeaders, requestHeaders)
    }

    private func mergeParams(_ resourceParams: SNLParams?, _ targetParams: SNLParams?, _ requestParams: SNLParams?) -> SNLParams {
        let resultParams = mergeOptionalDictionary(resourceParams, targetParams)
        return mergeOptionalDictionary(resultParams, requestParams)
    }

}

