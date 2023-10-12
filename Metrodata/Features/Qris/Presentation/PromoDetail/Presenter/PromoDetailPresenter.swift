//
//  PromoDetailPresenter.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 12/10/23.
//

import Foundation

class PromoDetailPresenter: PromoDetailViewToPresenterProtocol {
    
    var view: PromoDetailPresenterToViewProtocol?
    var router: PromoDetailPresenterToRouterProtocol?
    
    var hasFinishGetArgument: Bool = false
    
    var promo: Promo? {
        didSet {
            if hasFinishGetArgument == false {
                view?.onSuccessGetPromoDetail(promo: promo!)
            }
        }
    }
}
