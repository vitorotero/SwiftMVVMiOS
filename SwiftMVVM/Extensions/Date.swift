//
//  Date.swift
//  SwiftMVVM
//
//  Created by Vitor Otero Machado on 13/07/2018.
//  Copyright © 2018 TeCApp. All rights reserved.
//

import Foundation

enum Constants: String {
    case locationBr = "pt_BR"
    case dateTimeBr = "dd/MM/yyyy HH:mm:ss"
    case dateTimeBrHyphen = "dd-MM-yyyy HH:mm:ss"
    case dateBr = "dd/MM/yyyy"
    case dateBrHyphen = "dd-MM-yyyy"
}

extension Date {
    
    static func constants(_ constants: Constants) -> String {
        return constants.rawValue
    }
    
    func toString(withFormat format: Constants) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Date.constants(.locationBr))
        formatter.dateFormat = format.rawValue
        
        return formatter.string(from: self)
    }
    
}
