//
//  TransactionDetailInteractor.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 12/10/23.
//

import Foundation

class TransactionDetailInteractor: TransactionDetailPresenterToInteractorProtocol {
    
    var presenter: TransactionDetailInteractorToPresenterProtocol?
    
    func fetchPayQRISRequest(request: TransactionRequest) {
        FirestoreService.shared.createTransaction(with: request, completion: { result, error in
            if let error = error {
                self.presenter?.onErrorPayQRIS(error: error)
                
                return
            }
            
            self.presenter?.onSuccessPayQRIS()
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
}
