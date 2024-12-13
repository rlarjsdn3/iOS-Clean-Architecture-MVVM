//
//  Endpoing.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 11/21/24.
//

import Foundation

enum HttpMethodType: String {
    case get    = "GET"
    case head   = "HEAD"
    case post   = "POST"
    case put    = "PUT"
    case patch  = "PATCH"
    case delete = "DELETE"
}

class Endpoint<R>: ResponseRequestable {
    
    typealias Response = R
    
    let path: String
    let isFullPath: Bool
    let method: HttpMethodType
    let headerParameters: [String : String]
    let queryParametersEncodable: (any Encodable)?
    let queryParameters: [String : Any]
    let bodyParametersEncodable: (any Encodable)?
    let bodyParameters: [String : Any]
    let bodyEncoder: any BodyEncoder
    let responseDecoder: any ResponseDecoder
    
    init(
        path: String,
        isFullPath: Bool = false,
        method: HttpMethodType,
        headerParameters: [String : String] = [:],
        queryParametersEncodable: (any Encodable)? = nil,
        queryParameters: [String : Any] = [:],
        bodyParametersEncodable: (any Encodable)? = nil,
        bodyParameters: [String : Any] = [:],
        bodyEncoder: any BodyEncoder = JSONBodyEncoder(),
        responseDecoder: any ResponseDecoder = JSONResponseDecoder()
    ) {
        self.path = path
        self.isFullPath = isFullPath
        self.method = method
        self.headerParameters = headerParameters
        self.queryParametersEncodable = queryParametersEncodable
        self.queryParameters = queryParameters
        self.bodyParametersEncodable = bodyParametersEncodable
        self.bodyParameters = bodyParameters
        self.bodyEncoder = bodyEncoder
        self.responseDecoder = responseDecoder
    }
    
}


protocol BodyEncoder {
    func encode(_ parameters: [String: Any]) -> Data?
}

struct JSONBodyEncoder: BodyEncoder {
    func encode(_ parameters: [String: Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: parameters)
    }
}

struct AsciiBodyEncoder: BodyEncoder {
    func encode(_ parameters: [String: Any]) -> Data? {
        return parameters.queryString.data(using: String.Encoding.ascii, allowLossyConversion: true)
    }
}

protocol Requestable {
    var path: String { get }
    var isFullPath: Bool { get }
    var method: HttpMethodType { get }
    var headerParameters: [String: String] { get }
    var queryParametersEncodable: (any Encodable)? { get }
    var queryParameters: [String: Any] { get }
    var bodyParametersEncodable: (any Encodable)? { get }
    var bodyParameters: [String: Any] { get }
    var bodyEncoder: any BodyEncoder { get }
    
    func urlRequest(with networkConfig: any NetworkConfigurable) throws -> URLRequest
}

protocol ResponseRequestable: Requestable {
    associatedtype Response
    
    var responseDecoder: any ResponseDecoder { get }
}

enum RequestGenerationError: Error {
    case components
}

extension Requestable {
    
    func url(with config: any NetworkConfigurable) throws -> URL {
        
        let baseURL = config.baseURL.absoluteString.last != "/"
        ? config.baseURL.absoluteString + "/"
        : config.baseURL.absoluteString
        let endpoint = isFullPath ? path : baseURL.appending(path)
        
        guard var urlComponents = URLComponents(
            string: endpoint
        ) else { throw RequestGenerationError.components }
        var urlQueryItems = [URLQueryItem]()
        
        let queryParameters = try queryParametersEncodable?.toDictionary() ?? self.queryParameters
        queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        config.queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        urlComponents.queryItems = urlQueryItems
        guard let url = urlComponents.url else { throw RequestGenerationError.components }
        return url
    }
    
    func urlRequest(with config: any NetworkConfigurable) throws -> URLRequest {
        
        let url = try self.url(with: config)
        var urlRequest = URLRequest(url: url)
        var allHeaders: [String: String] = config.headers
        headerParameters.forEach {
            allHeaders.updateValue($0.value, forKey: $0.value)
        }
        
        let bodyParameters = try bodyParametersEncodable?.toDictionary() ?? self.bodyParameters
        if !bodyParameters.isEmpty {
            urlRequest.httpBody = bodyEncoder.encode(bodyParameters)
        }
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = allHeaders
        return urlRequest
        
    }
    
}


private extension Dictionary {
    var queryString: String {
        return self.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    }
}

private extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData as? [String: Any]
    }
}
