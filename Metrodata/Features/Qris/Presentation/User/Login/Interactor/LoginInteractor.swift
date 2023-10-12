//
//  LoginInteractor.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 11/10/23.
//

import Foundation

class LoginInteractor: LoginPresenterToInteractorProtocol {
    
    var presenter: LoginInteractorToPresenterProtocol?
    
    func fetchLoginRequest(request: UserLoginRequest) {
        FirebaseAuthService.shared.loginUser(with: request, completion: { result, error in
            if let error = error {
                self.presenter?.onErrorLogin(error: error)
                
                return
            }
            
            self.presenter?.onSuccessLogin()
        })
    }
}
