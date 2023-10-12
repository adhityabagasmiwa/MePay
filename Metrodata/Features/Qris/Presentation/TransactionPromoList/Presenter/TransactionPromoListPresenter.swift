//
//  TransactionPromoListPresenter.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 12/10/23.
//

import Foundation

class TransactionPromoListPresenter: TransactionPromoListViewToPresenterProtocol {
    
    var view: TransactionPromoListPresenterToViewProtocol?
    var interactor: TransactionPromoListPresenterToInteractorProtocol?
    var router: TransactionPromoListPresenterToRouterProtocol?
    
    var historyTransactions: [Transaction] = []
    var promos: [Promo] = []
    var isFromTransaction: Bool?
    
    var isLoading: Bool = false {
        didSet {
            view?.notifyLoadingStateChanged()
        }
    }
    
    func fetchPromos(query: String) {
        isLoading = true
        interactor?.fetchPromos(query: query)
    }
    
    func fetchHistoryTransactions(query: String) {
        isLoading = true
        interactor?.fetchHistoryTransactions(query: query)
    }
}

extension TransactionPromoListPresenter: TransactionPromoListInteractorToPresenterProtocol {
    
    func onSuccessGetPromos(response: [Promo]) {
        if response.count > 0 {
            removeAllPromos()
            
            for promo in response {
                promos.append(promo)
            }
            
            view?.onSuccessGetPromos()
            isLoading = false
        }
    }
    
    func onErrorGetPromos(error: APIError) {
        view?.onErrorGetPromos(error: error)
        isLoading = false
    }
    
    func onSuccessGetHistoryTransactions(response: [Transaction]) {
        removeAllHistoryTransactions()
        
        for data in response {
            historyTransactions.append(data)
        }
        
        view?.onSuccessGetHistoryTransactions()
        isLoading = false
    }
    
    func onErrorGetHistoryTransactions(error: Error) {
        view?.onErrorGetHistoryTransactions(error: error)
        isLoading = false
    }
}

extension TransactionPromoListPresenter {
    
    func removeAllPromos() {
        promos = []
    }
    
    func removeAllHistoryTransactions() {
        historyTransactions = []
    }
}
