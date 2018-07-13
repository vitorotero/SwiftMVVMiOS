//
//  Routers.swift
//  SwiftMVVM
//
//  Created by Vitor Otero Machado on 10/07/2018.
//  Copyright © 2018 TeCApp. All rights reserved.
//

import Foundation
import Alamofire

enum UserRouter {
    case login(user: String, password: String)
    case getUser(id: Int)
}

extension UserRouter: RouterType {
    var path: String {
        switch self {
        case .login, .getUser:
            return "index.php"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .getUser:
            return .get
        }
    }
    
    var paramsJson: [String : Any]? {
        switch self {
        case let .login(email, password):
            return ["user": email, "password": password]
        default: return nil
        }
    }
    
    var paramsQueryString: [String : Any]? {
        switch self {
        case let .getUser(id):
            return ["id": id]
        default: return nil
        }
    }
}
