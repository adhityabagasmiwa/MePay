//
//  RegisterRouter.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 11/10/23.
//

import Foundation

class RegisterRouter: RegisterPresenterToRouterProtocol {
    
    static func createModule() -> RegisterViewController {
        let view = RegisterViewController()
        let presenter: RegisterInteractorToPresenterProtocol & RegisterViewToPresenterProtocol = RegisterPresenter()
        let interactor: RegisterPresenterToInteractorProtocol = RegisterInteractor()
        let router: RegisterPresenterToRouterProtocol = RegisterRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
}
