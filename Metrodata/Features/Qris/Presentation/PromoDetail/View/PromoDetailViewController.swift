//
//  PromoDetailViewController.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 12/10/23.
//

import UIKit

class PromoDetailViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    weak var presenter: PromoDetailViewToPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func onPressBackButton(_ sender: Any) {
        navigatePop()
    }
}

extension PromoDetailViewController {
    
    private func setData(_ data: Promo) {
        let patternImageString: String = data.img.formats.medium.hash + data.img.formats.medium.ext
        let imageUrl = URL(string: patternImageString.imageCover)
        backgroundImageView.kf.setImage(with: imageUrl)
        
        titleLabel.text = data.name
        descriptionLabel.text = data.desc.newLineText
    }
}

extension PromoDetailViewController: PromoDetailPresenterToViewProtocol {
    
    func onSuccessGetPromoDetail(promo: Promo) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            self.setData(promo)
            self.presenter?.hasFinishGetArgument = true
        })
    }
}
