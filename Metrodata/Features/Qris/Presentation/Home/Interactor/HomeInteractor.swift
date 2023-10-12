//
//  HomeInteractor.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 11/10/23.
//

import Foundation

class HomeInteractor: HomePresenterToInteractorProtocol {
    
    let networkManager = NetworkManager()
    var presenter: HomeInteractorToPresenterProtocol?
    
    func fetchPromos() {
        let urlString = ApiURL.baseURL.rawValue + Endpoint.promos.rawValue
        
        networkManager.fetchAPI(fromUrl: urlString, forType: [Promo].self, method: .get, parameters: nil, completion: { result in
            switch result {
                case .success(let response):
                    self.presenter?.onSuccessGetPromos(response: response)
                case .failure(let error):
                    self.presenter?.onErrorGetPromos(error: error)
            }
        })
    }
    
    func fetchHistoryTransactions() {
        FirestoreService.shared.fetchHistoryTransaction(completion: { result, error in
            if let error = error {
                self.presenter?.onErrorGetHistoryTransactions(error: error)
                
                return
            }
            
            if let result = result {
                self.presenter?.onSuccessGetHistoryTransactions(response: result)
            }
            
        })
    }
    
    func fetchBalance() {
        FirestoreService.shared.fetchBalance { result, error in
            if let error = error {
                self.presenter?.onErrorGetBalance(error: error)
                
                return
            }
            
            if let result = result {
                self.presenter?.onSuccessGetBalance(response: result)
            }
        }
    }
    
    func fetchUserData() {
        FirestoreService.shared.fetchUser(completion: { result, error in
            if let error = error {
                self.presenter?.onErrorGetUserData(error: error)
                
                return
            }
            
            if let result = result {
                self.presenter?.onSuccessGetUserData(data: result)
            }
        })
    }
    
    func fetchLogoutRequest() {
        FirebaseAuthService.shared.logoutUser(completion: { result, error in
            if let error = error {
                self.presenter?.onErrorLogout(error: error)
                
                return
            }
            
            self.presenter?.onSuccessLogout()
        })
    }
}
