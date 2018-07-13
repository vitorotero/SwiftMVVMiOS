//
//  BaseViewController.swift
//  SwiftMVVM
//
//  Created by Vitor Otero Machado on 10/07/2018.
//  Copyright © 2018 TeCApp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD

class BaseViewController: UIViewController {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var isLoading = BehaviorRelay<Bool>(value: false)
    var isLoadingBackground = BehaviorRelay<Bool>(value: false)
    private var internalScrollView: UIScrollView?
    private var hud: ActivityIndicator = ActivityIndicator()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        didLoad()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        willAppear()
    }
    
    func bindViewModel() {
        isLoading.asDriver()
            .drive(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.showLoading()
                } else {
                    self?.hideLoading()
                }
            }).disposed(by: disposeBag)
        
        isLoadingBackground.asDriver()
            .drive(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.showLoading(isBackground: true)
                } else {
                    self?.hideLoading()
                }
            }).disposed(by: disposeBag)
    }
    func didLoad() {}
    func willAppear() {}
    
}

// MARK: - PKHUD
extension BaseViewController {
    func showLoading(isBackground: Bool = false) {
        view.endEditing(true)
        let viewController = findTopMostViewController()
        hud.show(onView: viewController.view, withBackground: isBackground)
    }
    
    func hideLoading() {
        hud.hide()
    }
}

// MARK: - UIGestureRecognizerDelegate
extension BaseViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIButton {
            return false
        }
        return true
    }
}

// MARK: - Extension Keyboard Methods
extension BaseViewController {
    func dismissKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = true
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func observeKeyboardNotifications(with scrollView: UIScrollView?) {
        internalScrollView = scrollView
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let info = notification.userInfo,
            let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size,
            let animationDuration = (info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
            else { return }
        
        keyboardWillAppear(with: keyboardSize, duration: animationDuration)
    }
    
    func keyboardWillAppear(with size: CGSize, duration: TimeInterval) {
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: size.height + 15.0, right: 0)
        internalScrollView?.contentInset = contentInsets
        internalScrollView?.scrollIndicatorInsets = contentInsets
        
        var rect = view.frame
        rect.size.height -= size.height
        guard let activeTextField = findActiveTextField(view.subviews) else { return }
        
        if !rect.contains(activeTextField.frame.origin) {
            internalScrollView?.scrollRectToVisible(activeTextField.frame, animated: true)
        }
    }
    
    func findActiveTextField(_ subviews: [UIView]) -> UITextField? {
        for view in subviews {
            if let textField = view as? UITextField, textField.isFirstResponder {
                return textField
            }
            
            return findActiveTextField(view.subviews)
        }
        return nil
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        guard let info = notification.userInfo,
            let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size,
            let animationDuration = (info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
            else { return }
        
        keyboardWillDisappear(with: keyboardSize, duration: animationDuration)
    }
    
    func keyboardWillDisappear(with size: CGSize, duration: TimeInterval) {
        let contentInsets = UIEdgeInsets.zero
        internalScrollView?.contentInset = contentInsets
        internalScrollView?.scrollIndicatorInsets = contentInsets
    }
}
