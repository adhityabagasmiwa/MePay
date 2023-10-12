//
//  LoginProtocol.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 11/10/23.
//

import Foundation

protocol LoginPresenterToInteractorProtocol: AnyObject {
    var presenter: LoginInteractorToPresenterProtocol? { get set }
    
    func fetchLoginRequest(request: UserLoginRequest)
}

protocol LoginInteractorToPresenterProtocol: AnyObject {
    func onSuccessLogin()
    func onErrorLogin(error: Error)
}

protocol LoginPresenterToViewProtocol: AnyObject {
    func onSuccessLogin()
    func onErrorLogin(error: Error)
    
    func notifyLoadingStateChanged()
}

protocol LoginViewToPresenterProtocol: AnyObject {
    var view: LoginPresenterToViewProtocol? { get set }
    var interactor: LoginPresenterToInteractorProtocol? { get set }
    var router: LoginPresenterToRouterProtocol? { get set }
    
    var isLoading: Bool { get set }
    
    func fetchLoginRequest(request: UserLoginRequest)
}

protocol LoginPresenterToRouterProtocol: AnyObject {
    static func createModule() -> LoginViewController
}
