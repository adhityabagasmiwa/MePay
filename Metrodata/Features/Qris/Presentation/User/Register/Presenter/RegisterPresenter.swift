//
//  RegisterPresenter.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 11/10/23.
//

import Foundation

class RegisterPresenter: RegisterViewToPresenterProtocol {
    
    var view: RegisterPresenterToViewProtocol?
    var interactor: RegisterPresenterToInteractorProtocol?
    var router: RegisterPresenterToRouterProtocol?
    
    var isLoading: Bool = false {
        didSet {
            view?.notifyLoadingStateChanged()
        }
    }
    
    func fetchRegisterRequest(request: UserRegisterRequest) {
        isLoading = true
        interactor?.fetchRegisterRequest(request: request)
    }
}

extension RegisterPresenter: RegisterInteractorToPresenterProtocol {
    
    func onSuccessRegister() {
        view?.onSuccessRegister()
        isLoading = false
    }
    
    func onErrorRegister(error: Error) {
        view?.onErrorRegister(error: error)
        isLoading = false
    }
}
