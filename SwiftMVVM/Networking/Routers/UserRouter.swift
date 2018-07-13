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
}

extension UserRouter: RouterType {
    var path: String {
        switch self {
        case .login:
            return "login"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        }
    }
    
    var params: [String : Any]? {
        switch self {
        case let .login(email, password):
            return ["email": email, "password": password]
        }
    }
}
