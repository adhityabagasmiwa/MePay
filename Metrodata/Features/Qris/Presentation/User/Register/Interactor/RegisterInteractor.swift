//
//  RegisterInteractor.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 11/10/23.
//

import Foundation

class RegisterInteractor: RegisterPresenterToInteractorProtocol {
    
    var presenter: RegisterInteractorToPresenterProtocol?
    
    func fetchRegisterRequest(request: UserRegisterRequest) {
        FirebaseAuthService.shared.createAuthUser(with: request, completion: { result, error in
            if let error = error {
                self.presenter?.onErrorRegister(error: error)
                
                return
            }
            
            self.presenter?.onSuccessRegister()
        })
    }
}
