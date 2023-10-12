//
//  HomePresenter.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 11/10/23.
//

import Foundation

class HomePresenter: HomeViewToPresenterProtocol {
    
    var view: HomePresenterToViewProtocol?
    var interactor: HomePresenterToInteractorProtocol?
    var router: HomePresenterToRouterProtocol?
    
    var historyTransactions: [Transaction] = []
    var promos: [Promo] = []
    
    var isLoading: Bool = false {
        didSet {
            view?.notifyLoadingStateChanged()
        }
    }
    
    func fetchPromos() {
        isLoading = true
        interactor?.fetchPromos()
    }
    
    func fetchHistoryTransactions() {
        isLoading = true
        interactor?.fetchHistoryTransactions()
    }
    
    func fetchBalance() {
        isLoading = true
        interactor?.fetchBalance()
    }
    
    func fetchUserData() {
        isLoading = true
        interactor?.fetchUserData()
    }
    
    func fetchLogoutRequest() {
        isLoading = true
        interactor?.fetchLogoutRequest()
    }
}

extension HomePresenter: HomeInteractorToPresenterProtocol {
    
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
        view?.onErrorGetBalance(error: error)
        isLoading = false
    }
    
    func onSuccessGetBalance(response: Balance) {
        view?.onSuccessGetBalance(data: response)
        isLoading = false
    }
    
    func onErrorGetBalance(error: Error) {
        view?.onErrorGetBalance(error: error)
        isLoading = false
    }
    
    func onSuccessGetUserData(data: User) {
        view?.onSuccessGetUserData(data: data)
        isLoading = false
    }
    
    func onErrorGetUserData(error: Error) {
        view?.onErrorGetUserData(error: error)
        isLoading = false
    }
    
    func onSuccessLogout() {
        view?.onSuccessLogout()
        isLoading = false
    }
    
    func onErrorLogout(error: Error) {
        view?.onErrorLogout(error: error)
        isLoading = false
    }
}

extension HomePresenter {
    
    func removeAllPromos() {
        promos = []
    }
    
    func removeAllHistoryTransactions() {
        historyTransactions = []
    }
}
