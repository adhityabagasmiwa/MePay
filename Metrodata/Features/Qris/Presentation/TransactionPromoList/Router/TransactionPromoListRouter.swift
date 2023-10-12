//
//  TransactionPromoListRouter.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 12/10/23.
//

import Foundation

class TransactionPromoListRouter:  TransactionPromoListPresenterToRouterProtocol {
    
    static func createModule(isFromTransaction: Bool) ->  TransactionPromoListViewController {
        let view =  TransactionPromoListViewController()
        let presenter:  TransactionPromoListInteractorToPresenterProtocol &  TransactionPromoListViewToPresenterProtocol =  TransactionPromoListPresenter()
        let interactor:  TransactionPromoListPresenterToInteractorProtocol =  TransactionPromoListInteractor()
        let router:  TransactionPromoListPresenterToRouterProtocol =  TransactionPromoListRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.isFromTransaction = isFromTransaction
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
}

