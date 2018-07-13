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
}

final class UserDataProvider: UserDataProviderProtocol {
    func signIn(user: String, password: String) -> Observable<User> {        
        return Observable
            .just(User(id: 0, user: "teste", password: "1234"))
            .delay(TimeInterval.init(1), scheduler: MainScheduler.instance)
    }
}
