//
//  UserDataCaretaker.swift
//  trackerVS
//
//  Created by Home on 14.06.2022.
//

import UIKit

final class UserDataCaretaker {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private let key = "AppUserData"
    
    func save(userData: UserData) {
        do {
            let data = try self.encoder.encode(userData)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
    
    func retrieveUserData() -> UserData? {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        do {
            return try self.decoder.decode(UserData.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
}
