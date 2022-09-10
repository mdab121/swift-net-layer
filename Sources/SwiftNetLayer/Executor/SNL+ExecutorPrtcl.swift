//
//  SNLExecutorPrtcl.swift
//  
//
//  Created by Oleh Hudeichuk on 20.12.2019.
//

import Foundation

public protocol SNLExecutorPrtcl {

    var resource: SNLResourcePrtcl { get set }
    var method: SNLHTTPMethod { get set }
    var path: URL { get set }
    var multipart: Bool { get set }
    var dynamicPathsParts: SNLDynamicParts? { get set }
    var targetHeaders: SNLHeader? { get set }
    var targetParams: SNLParams? { get set }
    var requestHeaders: SNLHeader? { get set }
    var requestParams: SNLParams? { get set }
    var body: SNLBody? { get set }
    var files: SNLFiles?  { get set }
    var timeoutIntervalForRequest: Double? { get set }
    var timeoutIntervalForResource: Double? { get set }

    func execute(_ handler: @escaping (Data?, URLResponse?, Error?) throws -> Void) throws

    func execute<ResponseModel: Decodable>(model: ResponseModel.Type,
                                           _ handler: @escaping (ResponseModel?, URLResponse?, Error?) throws -> Void) throws

    func waitExecute(_ handler: @escaping (Data?, URLResponse?, Error?) throws -> Void) throws

    func waitExecute<ResponseModel: Decodable>(model: ResponseModel.Type,
                                               _ handler: @escaping (ResponseModel?, URLResponse?, Error?) throws -> Void) throws
}
