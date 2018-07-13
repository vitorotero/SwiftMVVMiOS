//
//  UIAlertController.swift
//  SwiftMVVM
//
//  Created by Vitor Otero Machado on 12/07/18.
//  Copyright © 2018 TeCApp. All rights reserved.
//

import UIKit

extension UIAlertController {
    func show(completion: @escaping () -> Void = { }) {
        if let window = UIApplication.shared.keyWindow, let rootView = window.rootViewController {
            rootView.present(self, animated: true, completion: completion)
        }
    }
}

final class AlertNative {
    
    static func okDialogWith(title: String?,
                             message: String,
                             completion: @escaping () -> Void = {  } ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: R.string.localizable.titleOK(), style: .cancel) { _ in completion() }
        alert.addAction(okAction)
        
        return alert
    }
    
}
