//
//  LoginViewController.swift
//  SwiftMVVM
//
//  Created by Vitor Otero Machado on 10/07/2018.
//  Copyright © 2018 TeCApp. All rights reserved.
//

import UIKit
import RxSwift

final class LoginViewController: BaseViewController {
    
    private struct Constants {
        static let minimumPasswordLenght = 4
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Properties
    var viewModel: LoginViewModelType!
    
    // MARK: - Life Cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        viewModel = LoginViewModel()
    }
    
    override func didLoad() {
        dismissKeyboardWhenTappedAround()
    }
    
    override func willAppear() {
    }
    
    // MARK: - Methods
    override func bindViewModel() {
        super.bindViewModel()        
        
        viewModel.outputs.activityIndicator
            .drive(isLoading)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isFormValid
            .drive(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                if let text = strongSelf.userTextField.text, text.isMailInvalid {
                    AlertNative.okDialogWith(title: R.string.localizable.titleError(),
                                             message: R.string.localizable.loginViewMailNotValidText()
                        )
                        .show()
                    return
                }
                
                if let text = strongSelf.passwordTextField.text,
                    text.isEmpty || text.count < Constants.minimumPasswordLenght {
                    AlertNative.okDialogWith(title: R.string.localizable.titleError(),
                                             message: R.string.localizable.loginViewPasswordNotValidText()
                        )
                        .show()
                    return
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.signInSuccess
            .drive(onNext: { _ in
                AlertNative.okDialogWith(title: R.string.localizable.titleSuccess(), message: "sucesso").show()
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.signInError
            .drive(onNext: { message in
                AlertNative.okDialogWith(title: R.string.localizable.titleError(), message: message).show()
            }).disposed(by: disposeBag)
        
        viewModel.outputs.getUserSuccess
            .drive(onNext: { user in
                AlertNative.okDialogWith(title: R.string.localizable.titleSuccess(), message: user.user).show()
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.getUserLocalSuccess
            .drive(onNext: { [weak self] user in
                self?.userTextField.text = user.user
                self?.viewModel.inputs.userChanged(user.user)
                
                self?.passwordTextField.text = user.password
                self?.viewModel.inputs.passwordChanged(user.password)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Actions
    @IBAction func userTextFieldValueChanged(_ textField: UITextField) {
        viewModel.inputs.userChanged(textField.text)
    }
    
    @IBAction func passwordTextFieldValueChanged(_ textField: UITextField) {
        viewModel.inputs.passwordChanged(textField.text)
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        viewModel.inputs.signInTapped()
    }
    
    @IBAction func getUserButtonTapped(_ sender: Any) {
        viewModel.inputs.getUserTapped()
    }
    
    @IBAction func getUserLocalButtonTapped(_ sender: Any) {
        viewModel.inputs.getUserLocalTapped()
    }
    
}
