//
//  UIViewController.swift
//  SwiftMVVM
//
//  Created by Vitor Otero Machado on 12/07/2018.
//  Copyright © 2018 TeCApp. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func findTopMostViewController() -> UIViewController {
        return self.parent?.findTopMostViewController() ?? self
    }
    
}
