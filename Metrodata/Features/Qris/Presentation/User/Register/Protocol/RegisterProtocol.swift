//
//  RegisterProtocol.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 11/10/23.
//

import Foundation

protocol RegisterPresenterToInteractorProtocol: AnyObject {
    var presenter: RegisterInteractorToPresenterProtocol? { get set }
    
    func fetchRegisterRequest(request: UserRegisterRequest)
}

protocol RegisterInteractorToPresenterProtocol: AnyObject {
    func onSuccessRegister()
    func onErrorRegister(error: Error)
}

protocol RegisterPresenterToViewProtocol: AnyObject {
    func onSuccessRegister()
    func onErrorRegister(error: Error)
    
    func notifyLoadingStateChanged()
}

protocol RegisterViewToPresenterProtocol: AnyObject {
    var view: RegisterPresenterToViewProtocol? { get set }
    var interactor: RegisterPresenterToInteractorProtocol? { get set }
    var router: RegisterPresenterToRouterProtocol? { get set }
    
    var isLoading: Bool { get set }
    
    func fetchRegisterRequest(request: UserRegisterRequest)
}

protocol RegisterPresenterToRouterProtocol: AnyObject {
    static func createModule() -> RegisterViewController
}
