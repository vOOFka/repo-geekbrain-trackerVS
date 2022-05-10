//
//  RealmUser.swift
//  trackerVS
//
//  Created by Home on 04.05.2022.
//

import Foundation
import RealmSwift

final class RealmUser: Object {
    @Persisted (primaryKey: true) var login: String
    @Persisted var password: String
    
    convenience init(_ login: String, _ password: String) {
        self.init()
        self.login = login
        self.password = password
    }
}
