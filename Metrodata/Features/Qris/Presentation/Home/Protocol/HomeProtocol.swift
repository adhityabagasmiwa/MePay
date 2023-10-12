//
//  HomeProtocol.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 11/10/23.
//

import Foundation

protocol HomePresenterToInteractorProtocol: AnyObject {
    var presenter: HomeInteractorToPresenterProtocol? { get set }
    
    func fetchUserData()
    func fetchBalance()
    func fetchHistoryTransactions()
    func fetchPromos()
    func fetchLogoutRequest()
}

protocol HomeInteractorToPresenterProtocol: AnyObject {
    func onSuccessGetPromos(response: [Promo])
    func onErrorGetPromos(error: APIError)
    
    func onSuccessGetHistoryTransactions(response: [Transaction])
    func onErrorGetHistoryTransactions(error: Error)
    
    func onSuccessGetBalance(response: Balance)
    func onErrorGetBalance(error: Error)
    
    func onSuccessGetUserData(data: User)
    func onErrorGetUserData(error: Error)
    
    func onSuccessLogout()
    func onErrorLogout(error: Error)
}

protocol HomePresenterToViewProtocol: AnyObject {
    func onSuccessGetPromos()
    func onErrorGetPromos(error: APIError)

    func onSuccessGetHistoryTransactions()
    func onErrorGetHistoryTransactions(error: Error)
    
    func onSuccessGetBalance(data: Balance)
    func onErrorGetBalance(error: Error)
    
    func onSuccessGetUserData(data: User)
    func onErrorGetUserData(error: Error)
    
    func onSuccessLogout()
    func onErrorLogout(error: Error)
    
    func notifyLoadingStateChanged()
}

protocol HomeViewToPresenterProtocol: AnyObject {
    var view: HomePresenterToViewProtocol? { get set }
    var interactor: HomePresenterToInteractorProtocol? { get set }
    var router: HomePresenterToRouterProtocol? { get set }
    
    var promos: [Promo] { get }
    var historyTransactions: [Transaction] { get }
    
    var isLoading: Bool { get set }
    
    func fetchUserData()
    func fetchBalance()
    func fetchHistoryTransactions()
    func fetchPromos()
    func fetchLogoutRequest()
}

protocol HomePresenterToRouterProtocol: AnyObject {
    static func createModule() -> HomeViewController
}
