//
//  TransactionPromoListProtocol.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 12/10/23.
//

import Foundation

protocol TransactionPromoListPresenterToInteractorProtocol: AnyObject {
    var presenter: TransactionPromoListInteractorToPresenterProtocol? { get set }
    
    func fetchHistoryTransactions(query: String)
    func fetchPromos(query: String)
}

protocol TransactionPromoListInteractorToPresenterProtocol: AnyObject {
    func onSuccessGetPromos(response: [Promo])
    func onErrorGetPromos(error: APIError)
    
    func onSuccessGetHistoryTransactions(response: [Transaction])
    func onErrorGetHistoryTransactions(error: Error)
}

protocol TransactionPromoListPresenterToViewProtocol: AnyObject {
    func onSuccessGetPromos()
    func onErrorGetPromos(error: APIError)
    
    func onSuccessGetHistoryTransactions()
    func onErrorGetHistoryTransactions(error: Error)
    
    func notifyLoadingStateChanged()
}

protocol TransactionPromoListViewToPresenterProtocol: AnyObject {
    var view: TransactionPromoListPresenterToViewProtocol? { get set }
    var interactor: TransactionPromoListPresenterToInteractorProtocol? { get set }
    var router: TransactionPromoListPresenterToRouterProtocol? { get set }
    
    var promos: [Promo] { get }
    var historyTransactions: [Transaction] { get }
    var isFromTransaction: Bool? { get set }
    
    var isLoading: Bool { get set }
    
    func fetchHistoryTransactions(query: String)
    func fetchPromos(query: String)
}

protocol TransactionPromoListPresenterToRouterProtocol: AnyObject {
    static func createModule(isFromTransaction: Bool) -> TransactionPromoListViewController
}
