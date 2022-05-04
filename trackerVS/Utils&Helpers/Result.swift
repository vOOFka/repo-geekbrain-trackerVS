//
//  Result.swift
//  shopVS
//
//  Created by Home on 03.04.2022.
//

import Foundation

enum Result<T> {
    case Success(T)
    case Failure(String)
    
    func map<P>(f: (T) -> P) -> Result<P> {
        switch self {
        case .Success(let value):
            return .Success(f(value))
        case .Failure(let err):
            return .Failure(err)
        }
    }
    
    func compactMap<P>(_ type: P.Type) -> [P] {
        let newArray: [P] = []
        
        switch self {
        case .Success(let value):
            if let array = value as? Array<P>  {
                return array.compactMap({ $0 })
            } else {
                return newArray
            }
        case .Failure(_):
            return newArray
        }
    }
    
    var description: String {
        get {
            switch self {
            case .Success(let value):
                return "\(value)"
            case .Failure(let message):
                return "\(message)"
            }
        }
    }
}
