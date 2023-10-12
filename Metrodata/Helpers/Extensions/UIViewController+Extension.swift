//
//  UIViewController+Extension.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 11/10/23.
//

import Foundation
import UIKit
import FittedSheets

protocol TableViewConfigurable: UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView! { get set }
}

extension TableViewConfigurable where Self: UIViewController {
    
    func configureTableView(nibName: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: nibName)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
    }
}

protocol CollectionViewConfigurable: UICollectionViewDelegate, UICollectionViewDataSource {
    var collectionView: UICollectionView! { get set }
}

extension CollectionViewConfigurable where Self: UIViewController {
    
    func configurableCollectionView(nibName: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: nibName)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension UIViewController {
    
    func navigatePushToPage(_ toPage: UIViewController) {
        self.navigationController?.pushViewController(toPage, animated: true)
    }
    
    func navigatePop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func navigateReplacement(toPage vc: UIViewController, withLastIndex index: Int) {
        guard let navigationController = self.navigationController else { return }
        var navigationArray = navigationController.viewControllers
        navigationArray.removeLast(index)
        navigationArray.append(vc)
        self.navigationController?.setViewControllers(navigationArray, animated: true)
    }
    
    func showHideLoading(_ isLoading: Bool) {
        if isLoading {
            view.startLoadingAnimating()
        } else {
            view.stopLoadingAnimating()
        }
    }
    
    func showBottomSheet(controller: UIViewController, sizes: [SheetSize], dismissOnPull: Bool = true, dismissOnOverlayTap: Bool = true) {
        let options = SheetOptions(
            shrinkPresentingViewController: false
        )
        let sheetController = SheetViewController(controller: controller, sizes: sizes, options: options)
        sheetController.dismissOnPull = dismissOnPull
        sheetController.dismissOnOverlayTap = dismissOnOverlayTap
        sheetController.autoAdjustToKeyboard = true
        
        self.present(sheetController, animated: true, completion: nil)
    }
    
    func showAlertDialog(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
            self.dismiss(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertDialogConfirmation(title: String, message: String, action: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: action))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setupHideKeyboardTapOutside() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard)
        )
        
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
