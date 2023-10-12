//
//  ScannerQRRouter.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 11/10/23.
//

import Foundation

class ScannerQRRouter: ScannerQRPresenterToRouterProtocol {
    
    static func createModule() -> ScannerQRViewController {
        let view = ScannerQRViewController()
        let presenter: ScannerQRViewToPresenterProtocol = ScannerQRPresenter()
        let router: ScannerQRPresenterToRouterProtocol = ScannerQRRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        
        return view
    }
}
