//
//  File.swift
//  SwiftMVVM
//
//  Created by Vitor Otero Machado on 10/07/2018.
//  Copyright © 2018 TeCApp. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

enum APIError: Error {
    case http(Error)
    case custom(reason: String)
    case objectSerialization(reason: String)
    case noInternetConnection
    case customJson(json: String)
    case invalidToken(message: String)
    case notFound
    case methodNotAllowed
    case webserviceError
    case badRequest
    case timeout(message: String)
    case lostConnection(message: String)
    case statusMessageJson(json: [String: Any], codeError: Int)
    case decodable(Error, Data)
}

protocol RouterType: URLRequestConvertible {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var paramsJson: [String: Any]? { get }
    var paramsQueryString: [String: Any]? { get }
    var encoding: ParameterEncoding { get }
    var headers: HTTPHeaders? { get }
    var contentType: String { get }
}

extension RouterType {
    var baseURL: URL {
        return URL(string: "http://10.100.77.196/Painel/simpleApi/")!
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var encoding: ParameterEncoding {
        return paramsQueryString != nil ? URLEncoding.queryString :  JSONEncoding.default
    }
    
    var contentType: String {
        return "application/json"
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var urlRequest = try URLRequest(url: url, method: method, headers: headers)
        urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        return paramsQueryString != nil ?
            try encoding.encode(urlRequest, with: paramsQueryString)
            : try encoding.encode(urlRequest, with: paramsJson)
    }
}

final class APIServer {
    private let session: SessionManager
    
    init(session: SessionManager = SessionManager.default) {
        self.session = session
    }
    
    func request<T: Decodable>(_ route: RouterType, type: T.Type) -> Observable<T> {
        return Observable.create { observer in
            let request = self.session
                .request(route)
                .validate()
                .responseData { response in
                    self.printRequest(response)
                    
                    switch response.result {
                    case .success(let value):
                        do {
                            let result = try JSONDecoder().decode(T.self, from: value)
                            observer.onNext(result)
                            observer.onCompleted()
                        } catch {
                            observer.onError(APIError.decodable(error, value))
                        }
                        
                    case .failure(let error):
                        observer.onError(APIError.http(error))
                    }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    private func printRequest(_ response: DataResponse<Data>) {
        if let aaa = response.request, let body = aaa.httpBody {
            print("Request Parameters: \(String(describing: String(data: body, encoding: .utf8)))")
        }
        
        print("Request: \(String(describing: response.request))")
        print("Response: \(String(describing: response.response))")
        print("Error: \(String(describing: response.error))")
        
        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
            print("Data Parsed: \(utf8Text)")
        }
    }
}
