//
//  RegisterViewController.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 11/10/23.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var confirmationPasswordView: UIView!
    
    weak var presenter: RegisterViewToPresenterProtocol?
    
    lazy var passwordTextField: TextFieldVisibility = {
        let textField = TextFieldVisibility(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width - 40), height: 48))
        
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.placeholder = "Enter your password"
        textField.font = UIFont.SofiaRegularFont(size: 14)
        
        return textField
    }()
    
    lazy var confirmationPasswordTextField: TextFieldVisibility = {
        let textField = TextFieldVisibility(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width - 40), height: 48))
        
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.placeholder = "Enter your confirmation password"
        textField.font = UIFont.SofiaRegularFont(size: 14)
        
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNotification()
        setupPasswordTextField()
        setupDelegate()
        setupHideKeyboardTapOutside()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case fullNameTextField:
                emailTextField.becomeFirstResponder()
            case emailTextField:
                passwordTextField.becomeFirstResponder()
            case passwordTextField:
                confirmationPasswordTextField.becomeFirstResponder()
            default:
                textField.resignFirstResponder()
        }
        
        return false
    }
    
    @IBAction func onPressCreateAccountButton(_ sender: Any) {
        if passwordTextField.text != confirmationPasswordTextField.text  {
            showAlertDialog(title: "Failure", message: "Password and confirm password are not match!")
        } else if isValidToRegister() {
            showAlertDialogConfirmation(
                title: "Confirmation",
                message: "Are you sure this data is correct?",
                action: { _ in
                    if let fullName = self.fullNameTextField.text,
                       let email = self.emailTextField.text,
                       let password = self.passwordTextField.text {
                        let request = UserRegisterRequest(
                            fullName: fullName,
                            email: email,
                            password: password
                        )
                        self.fetchRegisterRequest(request: request)
                    }
                }
            )
        } else {
            showAlertDialog(title: "Failure", message: "Please fill in all fields!")
        }
    }
    
    @IBAction func onPressLoginButton(_ sender: Any) {
        navigateToLogin()
    }
    
    @IBAction func onPressBackButton(_ sender: Any) {
        navigatePop()
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

extension RegisterViewController {
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupPasswordTextField() {
        passwordView.addSubview(passwordTextField)
        confirmationPasswordView.addSubview(confirmationPasswordTextField)
    }
    
    private func setupDelegate() {
        fullNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmationPasswordTextField.delegate = self
    }
    
    private func fetchRegisterRequest(request: UserRegisterRequest) {
        presenter?.fetchRegisterRequest(request: request)
    }
    
    private func navigateToHome() {
        let vc = HomeRouter.createModule()
        navigatePushToPage(vc)
    }
    
    private func navigateToLogin() {
        let vc = LoginRouter.createModule()
        navigatePushToPage(vc)
    }
    
    private func isValidToRegister() -> Bool {
        return fullNameTextField.text != "" && emailTextField.text != "" && (passwordTextField.text != "" && confirmationPasswordTextField.text != "" && passwordTextField.text == confirmationPasswordTextField.text)
    }
}

extension RegisterViewController: RegisterPresenterToViewProtocol {
    
    func notifyLoadingStateChanged() {
        showHideLoading(presenter?.isLoading ?? false)
    }
    
    func onSuccessRegister() {
        navigateToHome()
    }
    
    func onErrorRegister(error: Error) {
        showAlertDialog(title: "Error", message: "Oops, failed to create a new user, please try again!")
    }
}
