//
//  PromoDetailRouter.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 12/10/23.
//

import Foundation

class PromoDetailRouter: PromoDetailPresenterToRouterProtocol {
    
    static func createModule(argument: Promo) -> PromoDetailViewController {
        let view = PromoDetailViewController()
        let presenter: PromoDetailViewToPresenterProtocol = PromoDetailPresenter()
        let router: PromoDetailPresenterToRouterProtocol = PromoDetailRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.promo = argument
        presenter.router = router
        
        return view
    }
}
