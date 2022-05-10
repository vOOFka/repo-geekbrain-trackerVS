//
//  AuthViewModel.swift
//  trackerVS
//
//  Created by Home on 04.05.2022.
//

import Foundation

final class AuthViewModel {
    private let realmService: RealmService = RealmServiceImplimentation()
    private(set) var authResult: Result<RealmUser> = .Failure("Unknow error, please try again later.")
    private(set) var signUpResult: Result<RealmUser> = .Failure("Unknow error, please try again later.")
    
    func authRequest(_ login: String, _ password: String, completion: @escaping (Result<RealmUser>) -> Void) {
        authResult = .Failure("Unknow error, please try again later.")
        do {
            let loginPredicate = NSPredicate(format: "login = %@", login)
            if let user = try realmService.get(RealmUser.self).filter(loginPredicate).toArray().first,
               user.password == password {
                authResult = .Success(user)
            } else {
                authResult = .Failure("Invalid username/password.")
            }
        } catch (let error) {
            authResult = .Failure(error.localizedDescription)
        }
        completion(self.authResult)
    }
    
    func signUpRequest(_ login: String, _ password: String, completion: @escaping (Result<RealmUser>) -> Void) {
        signUpResult = .Failure("Unknow error, please try again later.")
        do {
            let loginPredicate = NSPredicate(format: "login = %@", login)
            let user = try realmService.get(RealmUser.self).filter(loginPredicate).toArray().first ?? RealmUser(login, password)
            
            user.password = password
            let _ = try realmService.update(user)
            signUpResult = .Success(user)

        } catch (let error) {
            signUpResult = .Failure(error.localizedDescription)
        }
        completion(self.signUpResult)
    }
}
