//
//  TransactionDetailRouter.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 12/10/23.
//

import Foundation

class TransactionDetailRouter: TransactionDetailPresenterToRouterProtocol {
    
    static func createModule(argument: TransactionDetailArgument) -> TransactionDetailViewController {
        let view = TransactionDetailViewController()
        let presenter: TransactionDetailInteractorToPresenterProtocol & TransactionDetailViewToPresenterProtocol = TransactionDetailPresenter()
        let interactor: TransactionDetailPresenterToInteractorProtocol = TransactionDetailInteractor()
        let router: TransactionDetailPresenterToRouterProtocol = TransactionDetailRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.argument = argument
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
}

struct TransactionDetailArgument {
    let isFromHistoryTransaction: Bool
    let data: Transaction
}


