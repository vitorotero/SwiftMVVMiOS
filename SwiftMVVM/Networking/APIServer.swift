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
    case decodable(Error)
}

protocol RouterType: URLRequestConvertible {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var params: [String: Any]? { get }
    var encoding: ParameterEncoding { get }
    var headers: HTTPHeaders? { get }
    var contentType: String { get }
}

extension RouterType {
    var baseURL: URL {
        return URL(string: "")!
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    var contentType: String {
        return "application/json"
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var urlRequest = try URLRequest(url: url, method: method, headers: headers)
        urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        return try encoding.encode(urlRequest, with: params)
    }
}

final class APIServer {
    private let session: SessionManager
    
    init(session: SessionManager = SessionManager.default) {
        self.session = session
    }
    
    func request<T: Decodable>(_ route: RouterType, type: T.Type) -> Observable<T> {
        return Observable.create { observer in
            let request = self.session.request(route).responseData { response in
                //                if let urlResponse = response.response, 200..<300 ~= urlResponse.statusCode {
                //                    // Handle API error
                //                } else {
                switch response.result {
                case .success(let value):
                    do {
                        let result = try JSONDecoder().decode(T.self, from: value)
                        observer.onNext(result)
                        observer.onCompleted()
                    } catch {
                        observer.onError(APIError.decodable(error))
                    }
                    
                case .failure(let error):
                    observer.onError(APIError.http(error))
                }
                //                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
