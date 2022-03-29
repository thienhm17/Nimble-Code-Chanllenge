//
//  LoginVC.swift
//  Nimble Code Challenge
//
//  Created by Thien Huynh on 3/27/22.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var logoBottomSpacing: NSLayoutConstraint!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    var viewModel = LoginVM()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        emailTextField.text = "thienhm@mail.com"
        passwordTextField.text = "12345678"
        bind(to: viewModel)
    }
    
    // MARK: - Event Handler
    
    @IBAction func onLogin(sender: UIButton) {
        viewModel.login(email: emailTextField.text, password: passwordTextField.text)
    }
    
    // MARK: - Private
    
    private func setupUI() {
        // adjust vertical spacing between logo and login view base on screen height
        logoBottomSpacing.constant = 109 * UIScreen.main.bounds.height / 896
        
        // setup textFields
        [emailTextField, passwordTextField].forEach {
            let placeholder = $0 === emailTextField ? "Email" : "Password"
            $0?.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [.foregroundColor: Common.Color.textPlaceholder,
                             .font: UIFont.systemFont(ofSize: 17)])
            $0?.cornerRadius = 12
            $0?.setLeftPaddingPoints(12)
            $0?.setRightPaddingPoints(12)
            $0?.delegate = self
        }
        
        // setup login button
        loginButton.cornerRadius = 12
    }
    
    private func bind(to viewModel: LoginVM) {
        viewModel.loading.observe(on: self) { [weak self] isLoading in
            self?.showLoading(isLoading: isLoading)
        }
        viewModel.error.observe(on: self) { [weak self] errorMessage in
            if let errorMessage = errorMessage {
                self?.showError(message: errorMessage)
            }
        }
        viewModel.loginSuccess.observe(on: self) { [weak self] isLoginSuccess in
            if isLoginSuccess {
                self?.onLoggedIn()
            }
        }
    }

    private func showLoading(isLoading: Bool) {
        isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
    }
    
    private func onLoggedIn() {
        (UIApplication.shared.delegate as? AppDelegate)?.navigateToHome()
    }
    
}

extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // if email text field
        if textField === emailTextField {
            // set focus on password text field
            passwordTextField.becomeFirstResponder()
        
        } else {
            // else send log in
            loginButton.sendActions(for: .touchUpInside)
        }
        
        return true
    }
}
