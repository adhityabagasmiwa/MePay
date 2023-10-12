//
//  TransactionCardTableViewCell.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 11/10/23.
//

import UIKit

class TransactionCardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var receivePaymentLabel: UILabel!
    @IBOutlet weak var typePaymentLabel: UILabel!
    @IBOutlet weak var nominalPaymentLabel: UILabel!
    @IBOutlet weak var datePaymentLabel: UILabel!
    
    static let cellId = "TransactionCardTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setData(_ data: Transaction) {
        mainView.layer.cornerRadius = 8
        logoView.layer.cornerRadius = logoView.frame.height / 2
        
        receivePaymentLabel.text = data.merchantName
        typePaymentLabel.text = data.bankName
        nominalPaymentLabel.text = data.nominal.formatToIDR()
        
        let date = data.createdAt.toString()
        datePaymentLabel.text = date
    }
}
