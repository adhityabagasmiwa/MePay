//
//  InformationSheetViewController.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 12/10/23.
//

import UIKit

class InformationSheetViewController: UIViewController {

    var onPressConfirmButton: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func onPressConfirmButton(_ sender: Any) {
        onPressConfirmButton?()
        self.dismiss(animated: true)
    }
}
