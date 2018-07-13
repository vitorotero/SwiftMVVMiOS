//
//  ErrorNetworking.swift
//  SwiftMVVM
//
//  Created by Vitor Otero Machado on 12/07/2018.
//  Copyright © 2018 TeCApp. All rights reserved.
//

import Foundation
import RxAlamofire
import Alamofire
import ObjectMapper

class ErrorNetworkingParse {
    
    static func getMessage(error: Error) -> String {
        var message = R.string.localizable.genericMessageError()
        
        if let errorParsed = error as? URLError, errorParsed.code == .notConnectedToInternet {
            message = R.string.localizable.noInternet()
        }
        
        if let errorParsed = error as? APIError {
            switch errorParsed {
            case .noInternetConnection:
                message = R.string.localizable.noInternet()
            case .timeout(let msg):
                message = msg
            default:
                message = R.string.localizable.genericMessageError()
            }
        }
        
        return message
    }
}
