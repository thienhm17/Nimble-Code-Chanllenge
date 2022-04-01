//
//  LoginVM.swift
//  Nimble Code Challenge
//
//  Created by Thien Huynh on 3/27/22.
//

import Foundation
import UIKit

class LoginVM {
    
    let loading = Observable<Bool>(false)
    let error = Observable<String?>(nil)
    let loginSuccess = Observable<Bool>(false)
    
    private let authServices: AuthServicesProtocol
    
    init(authServices: AuthServicesProtocol = AuthServices()) {
        self.authServices = authServices
    }
    
    func login(email: String?, password: String?) {
        guard let email = email, !email.isEmpty,
              let password = password, !password.isEmpty else {
                error.value = "Please input email & password"
            return
        }

        // start loading
        loading.value = true
        // request api endpoint
        authServices.login(email: email, password: password) { [weak self] apiError in
            // stop loading
            self?.loading.value = false
            // if has error
            if let apiError = apiError {
                self?.error.value = apiError.errorMessage
                
            } else {
                // else login successfully
                self?.loginSuccess.value = true
            }
        }
    }
}
