//
//  OnboardingViewController.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 11/10/23.
//

import UIKit

class OnboardingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
     
    @IBAction func onPressLoginButton(_ sender: Any) {
        UserDefaults.standard.setOnboarded(value: true)
        navigateToLogin()
    }
}

extension OnboardingViewController {
    
    private func navigateToLogin() {
        let vc = LoginRouter.createModule()
        navigateReplacement(toPage: vc, withLastIndex: 0)
    }
}
