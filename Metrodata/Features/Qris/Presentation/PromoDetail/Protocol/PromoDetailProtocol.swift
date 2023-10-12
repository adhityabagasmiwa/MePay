//
//  PromoDetailProtocol.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 12/10/23.
//

import Foundation

protocol PromoDetailPresenterToViewProtocol: AnyObject {
    func onSuccessGetPromoDetail(promo: Promo)
}

protocol PromoDetailViewToPresenterProtocol: AnyObject {
    var view: PromoDetailPresenterToViewProtocol? { get set }
    var router: PromoDetailPresenterToRouterProtocol? { get set }
    
    var hasFinishGetArgument: Bool { get set }
    var promo: Promo? { get set }
}

protocol PromoDetailPresenterToRouterProtocol: AnyObject {
    static func createModule(argument: Promo) -> PromoDetailViewController
}
