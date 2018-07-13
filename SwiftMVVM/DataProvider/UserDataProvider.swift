//
//  UserDataProvider.swift
//  SwiftMVVM
//
//  Created by Vitor Otero Machado on 12/07/2018.
//  Copyright © 2018 TeCApp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol UserDataProviderProtocol {
    func signIn(user: String, password: String) -> Observable<User>
    func getUser(byId id: Int) -> Observable<User>
    func getUserLocal() -> Observable<User>
}

final class UserDataProvider: UserDataProviderProtocol {
    
    private let disposeBag = DisposeBag()
    private let apiServer = APIServer()
    private let userRepository = Repository<User>()
    
    func signIn(user: String, password: String) -> Observable<User> {
        return apiServer.request(UserRouter.login(user: user, password: password), type: User.self)
            .flatMap({ user -> Observable<User> in
                self.userRepository.save(user)
                    .asDriverOnErrorJustComplete()
                    .drive()
                    .disposed(by: self.disposeBag)
                
                return Observable.just(user)
            })
    }
    
    func getUser(byId id: Int) -> Observable<User> {
        return apiServer.request(UserRouter.getUser(id: id), type: User.self)
    }
    
    func getUserLocal() -> Observable<User> {
        return userRepository.query(by: 1)
    }
}
