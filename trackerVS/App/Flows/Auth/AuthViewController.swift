//
//  AuthViewController.swift
//  trackerVS
//
//  Created by Home on 04.05.2022.
//

import UIKit

final class AuthViewController: UIViewController, Coordinating {
    // MARK: - Public properties
    var viewModel: AuthViewModel?
    var coordinator: Coordinator?
    
    // MARK: - Outlets
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var loginTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var signUpButton: UIButton!
    @IBOutlet weak private var enterButton: UIButton!
    @IBOutlet weak private var buttonsStackView: UIStackView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        viewModel = AuthViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configUI()
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        removeNotifications()
    }
    
    // MARK: - Methods
    private func configUI() {
        loginTextField.text = "Test"
        passwordTextField.text = "qwerty1234"
    }
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    private func removeNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func hideKeyboardGestre() {
        let hideKeyboardGestre = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(hideKeyboardGestre)
    }
    
    @objc private func keyboardShow(_ notification: NSNotification) {
        let userInfo = notification.userInfo
        let keyboardSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let contentInsert = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 10, right: 0)
        
        scrollView.contentInset = contentInsert
        scrollView.scrollIndicatorInsets = contentInsert
        scrollView.scrollRectToVisible(buttonsStackView.frame, animated: true)
    }
    
    @objc private func keyboardHide() {
        scrollView.contentInset = .zero
    }
    
    @objc private func hideKeyboard() {
        scrollView.endEditing(true)
    }
    
    // MARK: - Actions
    @IBAction private func signUpButtonTap(_ sender: Any) {
        guard let login = loginTextField.text,
              let password = passwordTextField.text,
              !login.isEmpty,
              !password.isEmpty
        else {
            showError(message: "Need enter login and password")
            return
        }
        viewModel?.signUpRequest(login, password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .Success(let user):
                self.showError(message: "User - \(user.login) successfully created/modified.", title:"Success")
            case .Failure(let error):
                self.showError(message: error)
            }
        }
    }
    
    @IBAction private func enterButtonTap(_ sender: Any) {
        guard let login = loginTextField.text,
              let password = passwordTextField.text,
              !login.isEmpty,
              !password.isEmpty
        else {
            showError(message: "Need enter login and password")
            return
        }
        viewModel?.authRequest(login, password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .Success(_):
                self.coordinator?.goToScene(with: .map)
            case .Failure(let error):
                self.showError(message: error)
            }
        }
    }
}
