//
//  LoginPresenter.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 11/10/23.
//

import Foundation

class LoginPresenter: LoginViewToPresenterProtocol {
    
    var view: LoginPresenterToViewProtocol?
    var interactor: LoginPresenterToInteractorProtocol?
    var router: LoginPresenterToRouterProtocol?
    
    var isLoading: Bool = false {
        didSet {
            view?.notifyLoadingStateChanged()
        }
    }
    
    func fetchLoginRequest(request: UserLoginRequest) {
        isLoading = true
        interactor?.fetchLoginRequest(request: request)
    }
}

extension LoginPresenter: LoginInteractorToPresenterProtocol {
    
    func onSuccessLogin() {
        view?.onSuccessLogin()
        isLoading = false
    }
    
    func onErrorLogin(error: Error) {
        view?.onErrorLogin(error: error)
        isLoading = false
    }
}
