//
//  RMUser.swift
//  SwiftMVVM
//
//  Created by Vitor Otero Machado on 13/07/2018.
//  Copyright © 2018 TeCApp. All rights reserved.
//

import Foundation
import RealmSwift

final class RMUser: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var user: String = ""
    @objc dynamic var password: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension RMUser: DomainConvertibleType {
    func asDomain() -> User {
        return User(
            id: id,
            user: user,
            password: password
        )
    }
}

extension User: RealmRepresentable {
    var uid: String {
        return "\(id)"
    }
    
    func asRealm() -> RMUser {
        return RMUser.build { object in
            object.id = id
            object.user = user
            object.password = password
        }
    }
}
