//
//  TransactionDetailPresenter.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 12/10/23.
//

import Foundation

class TransactionDetailPresenter: TransactionDetailViewToPresenterProtocol {
    
    var view: TransactionDetailPresenterToViewProtocol?
    var interactor: TransactionDetailPresenterToInteractorProtocol?
    var router: TransactionDetailPresenterToRouterProtocol?
    
    var hasFinishGetArgument: Bool = false
    var balance: Balance?
    
    var argument: TransactionDetailArgument? {
        didSet {
            if hasFinishGetArgument == false {
                view?.onSuccessGetTransactionDetail(data: argument!)
                isLoading = false
            }
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            view?.notifyLoadingStateChanged()
        }
    }
    
    func fetchPayQRISRequest(request: TransactionRequest) {
        isLoading = true
        interactor?.fetchPayQRISRequest(request: request)
    }
    
    func fetchBalance() {
        isLoading = true
        interactor?.fetchBalance()
    }
}

extension TransactionDetailPresenter: TransactionDetailInteractorToPresenterProtocol {
    
    func onSuccessPayQRIS() {
        view?.onSuccessPayQRIS()
        isLoading = false
    }
    
    func onErrorPayQRIS(error: Error) {
        view?.onErrorPayQRIS(error: error)
        isLoading = false
    }
    
    func onSuccessGetBalance(response: Balance) {
        balance = response
        view?.onSuccessGetBalance(data: response)
        isLoading = false
    }
    
    func onErrorGetBalance(error: Error) {
        view?.onErrorGetBalance(error: error)
        isLoading = false
    }
}
