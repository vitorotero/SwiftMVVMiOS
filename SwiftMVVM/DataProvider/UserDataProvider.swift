//
//  UserDataProvider.swift
//  SwiftMVVM
//
//  Created by Vitor Otero Machado on 12/07/2018.
//  Copyright © 2018 TeCApp. All rights reserved.
//

import Foundation
import RxSwift

protocol UserDataProviderProtocol {
    func signIn(user: String, password: String) -> Observable<User>
    func getUser(byId id: Int) -> Observable<User>
}

final class UserDataProvider: UserDataProviderProtocol {
    
    let apiServer = APIServer()
    
    func signIn(user: String, password: String) -> Observable<User> {
        return apiServer.request(UserRouter.login(user: user, password: password), type: User.self)
    }
    
    func getUser(byId id: Int) -> Observable<User> {
        return apiServer.request(UserRouter.getUser(id: id), type: User.self)
    }
}
