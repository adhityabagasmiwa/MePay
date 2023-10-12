//
//  TransactionPromoListInteractor.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 12/10/23.
//

import Foundation

class TransactionPromoListInteractor: TransactionPromoListPresenterToInteractorProtocol {
    
    let networkManager = NetworkManager()
    var presenter: TransactionPromoListInteractorToPresenterProtocol?
    
    func fetchPromos(query: String)  {
        let urlString = ApiURL.baseURL.rawValue + Endpoint.promos.rawValue
        
        networkManager.fetchAPI(fromUrl: urlString, forType: [Promo].self, method: .get, parameters: nil, completion: { result in
            switch result {
                case .success(var response):
                    if query != "" {
                        response = response.filter { $0.name.lowercased().contains(query.lowercased()) }
                    }
                    
                    self.presenter?.onSuccessGetPromos(response: response)
                case .failure(let error):
                    self.presenter?.onErrorGetPromos(error: error)
            }
        })
    }
    
    func fetchHistoryTransactions(query: String) {
        
        FirestoreService.shared.fetchHistoryTransaction(completion: { result, error in
            if let error = error {
                self.presenter?.onErrorGetHistoryTransactions(error: error)
                
                return
            }
            
            if var result = result {
                if query != "" {
                    result = result.filter { $0.merchantName.lowercased().contains(query.lowercased()) }
                }
                self.presenter?.onSuccessGetHistoryTransactions(response: result)
            }
        })
    }
}

