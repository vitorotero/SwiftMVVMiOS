//
//  ActivityIndicator.swift
//  SwiftMVVM
//
//  Created by Vitor Otero Machado on 13/07/2018.
//  Copyright © 2018 TeCApp. All rights reserved.
//

import Foundation
import UIKit

final class ActivityIndicator {
    
    private var container: UIView = UIView()
    private var loadingView: UIView = UIView()
    private var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
    init() {
        container.backgroundColor = UIColor.rgba(0, 0, 0, 0.3)
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        actInd.color = UIColor.rgba(68, 68, 68, 1.0)
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
    }
    
    func show(onView uiView: UIView, withBackground isBackground: Bool = false) {
        container.frame = uiView.frame
        container.center = uiView.center
        
        if isBackground {
            container.backgroundColor = UIColor.rgba(255, 255, 255, 0.5)
            loadingView.backgroundColor = UIColor.rgba(68, 68, 68, 0.7)
            actInd.color = .white
        }
        
        loadingView.center = uiView.center
        
        uiView.addSubview(container)
        actInd.startAnimating()
    }
    
    func hide() {
        actInd.stopAnimating()
        container.removeFromSuperview()
    }
    
}
