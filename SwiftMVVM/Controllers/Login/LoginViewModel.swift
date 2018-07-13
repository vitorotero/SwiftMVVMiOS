//
//  LoginViewModel.swift
//  SwiftMVVM
//
//  Created by Vitor Otero Machado on 10/07/2018.
//  Copyright © 2018 TeCApp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoginViewModelInput {
    func userChanged(_ value: String?)
    func passwordChanged(_ value: String?)
    func signInTapped()
    func getUserTapped()
}

protocol LoginViewModelOutput {
    var isFormValid: Driver<Void> { get }
    var activityIndicator: Driver<Bool> { get }
    var signInSuccess: Driver<Void> { get }
    var signInError: Driver<String> { get }
    
    var getUserSuccess: Driver<User> { get }
}

protocol LoginViewModelType {
    var inputs: LoginViewModelInput { get }
    var outputs: LoginViewModelOutput { get }
}

final class LoginViewModel: LoginViewModelType, LoginViewModelInput, LoginViewModelOutput {
    
    let isFormValid: SharedSequence<DriverSharingStrategy, Void>
    let activityIndicator: SharedSequence<DriverSharingStrategy, Bool>
    let signInSuccess: SharedSequence<DriverSharingStrategy, Void>
    let signInError: SharedSequence<DriverSharingStrategy, String>
    
    let getUserSuccess: SharedSequence<DriverSharingStrategy, User>
    
    init(userDataProvider: UserDataProviderProtocol = UserDataProvider()) {
        let errorTracker = ErrorTracker()
        let activityTracker = ActivityTracker()
        activityIndicator = activityTracker.asDriver()
        
        let user = userProperty.asDriverOnErrorJustComplete().whenNil(returns: "")
        let password = passwordProperty.asDriverOnErrorJustComplete().whenNil(returns: "")
        
        let formInputs = Driver.combineLatest(
            user,
            password
        ) { (user: $0, password: $1) }
        let trySignIn = Observable.merge(signInTappedProperty)
        
        isFormValid = trySignIn.asDriverOnErrorJustComplete()
        let isInputsValid = Driver.merge(.of(false), formInputs.map(validateForm))
        
        signInSuccess = trySignIn
            .withLatestFrom(isInputsValid)
            .skipWhile({ !$0 })
            .withLatestFrom(formInputs)
            .asDriverOnErrorJustComplete()
            .flatMapLatest { (inputs) -> Driver<Void> in
                return userDataProvider.signIn(user: inputs.user, password: inputs.password)
                    .trackActivity(activityTracker)
                    .trackError(errorTracker)
                    .mapToVoid()
                    .asDriverOnErrorJustComplete()
        }
        
        signInError = errorTracker.asDriver()
            .flatMapLatest({ error in
                let errorMessage = ErrorNetworkingParse.getMessage(error: error)
                return SharedSequence.just(errorMessage)
            })
        
        getUserSuccess = getUserTappedProperty
            .asDriverOnErrorJustComplete()
            .flatMapLatest({ _ in
                return userDataProvider.getUser(byId: 0)
                    .trackActivity(activityTracker)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            })
    }
    
    private let userProperty = PublishSubject<String?>()
    func userChanged(_ value: String?) {
        userProperty.onNext(value)
    }
    
    private let passwordProperty = PublishSubject<String?>()
    func passwordChanged(_ value: String?) {
        passwordProperty.onNext(value)
    }
    
    private let signInTappedProperty = PublishSubject<Void>()
    func signInTapped() {
        signInTappedProperty.onNext(())
    }
    
    private let getUserTappedProperty = PublishSubject<Void>()
    func getUserTapped() {
        getUserTappedProperty.onNext(())
    }
    
    var inputs: LoginViewModelInput { return self }
    var outputs: LoginViewModelOutput { return self }
}

private func validateForm(email: String, password: String) -> Bool {
    return email.isMailValid && password.isNotEmpty && password.count > 3
}
