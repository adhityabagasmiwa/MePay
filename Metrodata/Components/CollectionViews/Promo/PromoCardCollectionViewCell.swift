//
//  PromoCardCollectionViewCell.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 12/10/23.
//

import UIKit
import Kingfisher

class PromoCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var promoImageView: UIImageView!
    @IBOutlet weak var promoTitleLabel: UILabel!
    
    static let cellId = "PromoCardCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    func setupUI() {
        mainView.layer.cornerRadius = 8
        mainView.clipsToBounds = true
        promoImageView.clipsToBounds = true
    }
    
    func setData(_ data: Promo) {
        let patternImageString: String = data.img.formats.medium.hash + data.img.formats.medium.ext
        let imageUrl = URL(string: patternImageString.imageCover)
        promoImageView.kf.setImage(with: imageUrl)
        
        promoTitleLabel.text = data.name
    }

}
