//
//  UserDefaultManager.swift
//  Nimble Code Challenge
//
//  Created by Thien Huynh on 3/27/22.
//

import Foundation

class UserDefaultsManager {
    
    static let shared: UserDefaultsManager = UserDefaultsManager()
    
    enum Key: String {
        case accessToken
        case refreshToken
    }
    
    var accessToken: String? {
        get {
            return UserDefaults.standard.value(forKey: Key.accessToken.rawValue) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.accessToken.rawValue)
        }
    }
    
    var refreshToken: String? {
        get {
            return UserDefaults.standard.value(forKey: Key.refreshToken.rawValue) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.refreshToken.rawValue)
        }
    }
}
