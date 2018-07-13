//
//  SharedPreferences.swift
//  SwiftMVVM
//
//  Created by Vitor Otero Machado on 13/07/2018.
//  Copyright © 2018 TeCApp. All rights reserved.
//

import Foundation

final class SharedPreferences {
    
    static func getSharedPreferencesString(key: String) -> String {
        if let prefsString = UserDefaults.standard.value(forKey: key) as? String, prefsString.isNotEmpty {
            return prefsString
        }
        
        return String.emptyValue
    }
    
    static func saveSharedPreferencesString(value: String, key: String) {
        UserDefaults.standard.setValue(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
}
