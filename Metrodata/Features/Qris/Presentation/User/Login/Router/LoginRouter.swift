//
//  LoginRouter.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 11/10/23.
//

class LoginRouter: LoginPresenterToRouterProtocol {
    
    static func createModule() -> LoginViewController {
        let view = LoginViewController()
        let presenter: LoginInteractorToPresenterProtocol & LoginViewToPresenterProtocol = LoginPresenter()
        let interactor: LoginPresenterToInteractorProtocol = LoginInteractor()
        let router: LoginPresenterToRouterProtocol = LoginRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
}
