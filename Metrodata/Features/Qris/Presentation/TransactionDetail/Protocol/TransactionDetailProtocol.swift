//
//  TransactionDetailProtocol.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 12/10/23.
//

import Foundation

protocol TransactionDetailPresenterToInteractorProtocol: AnyObject {
    var presenter: TransactionDetailInteractorToPresenterProtocol? { get set }
    
    func fetchBalance()
    func fetchPayQRISRequest(request: TransactionRequest)
}

protocol TransactionDetailInteractorToPresenterProtocol: AnyObject {
    func onSuccessGetBalance(response: Balance)
    func onErrorGetBalance(error: Error)
    
    func onSuccessPayQRIS()
    func onErrorPayQRIS(error: Error)
}

protocol TransactionDetailPresenterToViewProtocol: AnyObject {
    func onSuccessGetBalance(data: Balance)
    func onErrorGetBalance(error: Error)
    
    func onSuccessPayQRIS()
    func onErrorPayQRIS(error: Error)
    
    func onSuccessGetTransactionDetail(data: TransactionDetailArgument)
    
    func notifyLoadingStateChanged()
}

protocol TransactionDetailViewToPresenterProtocol: AnyObject {
    var view: TransactionDetailPresenterToViewProtocol? { get set }
    var interactor: TransactionDetailPresenterToInteractorProtocol? { get set }
    var router: TransactionDetailPresenterToRouterProtocol? { get set }
    
    var argument: TransactionDetailArgument? { get set }
    var balance: Balance? { get set }
    
    var hasFinishGetArgument: Bool { get set }
    var isLoading: Bool { get set }
    
    func fetchBalance()
    func fetchPayQRISRequest(request: TransactionRequest)
}

protocol TransactionDetailPresenterToRouterProtocol: AnyObject {
    static func createModule(argument: TransactionDetailArgument) -> TransactionDetailViewController
}
