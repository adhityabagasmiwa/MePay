//
//  ScannerQRProtocol.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 12/10/23.
//

import Foundation

protocol ScannerQRPresenterToViewProtocol: AnyObject {
    
}

protocol ScannerQRViewToPresenterProtocol: AnyObject {
    var view: ScannerQRPresenterToViewProtocol? { get set }
    var router: ScannerQRPresenterToRouterProtocol? { get set }
}

protocol ScannerQRPresenterToRouterProtocol: AnyObject {
    static func createModule() -> ScannerQRViewController
}
