//
//  LoginViewController.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 11/10/23.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordView: UIView!
    
    weak var presenter: LoginViewToPresenterProtocol?
    
    lazy var passwordTextField: TextFieldVisibility = {
        let textField = TextFieldVisibility(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width - 40), height: 48))
        
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.placeholder = "Enter your password"
        textField.font = UIFont.SofiaRegularFont(size: 14)
        
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPasswordTextField()
        setupDelegate()
        setupHideKeyboardTapOutside()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case emailTextField:
                passwordTextField.becomeFirstResponder()
            default:
                textField.resignFirstResponder()
        }
        
        return false
    }
    
    @IBAction func onPressLoginButton(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            if let email = emailTextField.text, let password = passwordTextField.text {
                let request = UserLoginRequest(email: email, password: password)
                fetchLoginRequest(request: request)
            }
        } else {
            showAlertDialog(title: "Failure", message: "Please input the email and password")
        }
    }
    
    @IBAction func onPressRegisterButton(_ sender: Any) {
        navigateToRegister()
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 16
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}

extension LoginViewController {
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupPasswordTextField() {
        passwordView.addSubview(passwordTextField)
    }
    
    private func setupDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func fetchLoginRequest(request: UserLoginRequest) {
        presenter?.fetchLoginRequest(request: request)
    }
    
    private func navigateToRegister() {
        let vc = RegisterRouter.createModule()
        navigatePushToPage(vc)
    }
    
    private func navigateToHome() {
        let vc = HomeRouter.createModule()
        navigatePushToPage(vc)
    }
}

extension LoginViewController: LoginPresenterToViewProtocol {
    
    func notifyLoadingStateChanged() {
        showHideLoading(presenter?.isLoading ?? false)
    }
    
    func onSuccessLogin() {
        navigateToHome()
    }
    
    func onErrorLogin(error: Error) {
        
    }
}
