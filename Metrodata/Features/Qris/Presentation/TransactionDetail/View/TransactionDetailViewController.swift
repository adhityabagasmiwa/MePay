//
//  TransactionDetailViewController.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 12/10/23.
//

import UIKit

class TransactionDetailViewController: UIViewController {

    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var userBalanceLabel: UILabel!
    @IBOutlet weak var balanceSectionView: UIView!
    @IBOutlet weak var balanceCardView: UIView!
    @IBOutlet weak var successPaymentSectionView: UIView!
    
    @IBOutlet weak var numberReferencesLabel: UILabel!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var nominalLabel: UILabel!
    @IBOutlet weak var bottomButton: UIButton!
    
    weak var presenter: TransactionDetailViewToPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func onPressBackButton(_ sender: Any) {
        navigatePop()
    }
    
    @IBAction func onPressBottomButton(_ sender: Any) {
        guard let argument = presenter?.argument else { return }
        let isFromHistoryTransaction = argument.isFromHistoryTransaction
        
        if isFromHistoryTransaction {
            navigatePop()
        } else {
            showAlertDialogConfirmation(
                title: "Confirmation",
                message: "Are you sure to pay this transaction?",
                action: { _  in
                    guard let argument = self.presenter?.argument else { return }
                    if argument.data.nominal > self.presenter?.balance?.nominal ?? 0 {
                        self.showAlertDialog(title: "Failed", message: "Your balance is not enough")
                    } else {
                        self.fetchPayQRIS(argument.data)
                    }
                }
            )
        }
    }
}

extension TransactionDetailViewController {
    
    private func setupUI() {
        balanceCardView.layer.cornerRadius = 8
        balanceCardView.clipsToBounds = true
        bottomButton.layer.cornerRadius = bottomButton.frame.height / 2
    }
    
    private func fetchData() {
        presenter?.fetchBalance()
    }
    
    private func fetchPayQRIS(_ data: Transaction) {
        let request = TransactionRequest(id: data.transactionId, merchantName: data.merchantName, bankName: data.bankName, amount: data.nominal)
        presenter?.fetchPayQRISRequest(request: request)
    }
    
    private func setUserBalance(_ data: Balance) {
        userBalanceLabel.text = data.nominal.formatToIDR()
    }
    
    private func setData(_ argument: TransactionDetailArgument) {
        presenter?.argument = argument
        
        let userData = UserDefaults.standard.getUserData()
        let isFromHistoryTransaction = argument.isFromHistoryTransaction
        
        navigationTitleLabel.text = isFromHistoryTransaction ? "Transaction Detail" : "Confirmation Payment"
        balanceSectionView.isHidden = isFromHistoryTransaction
        successPaymentSectionView.isHidden = !isFromHistoryTransaction
        numberReferencesLabel.text = argument.data.transactionId.toString()
        bankNameLabel.text = argument.data.bankName
        merchantNameLabel.text = argument.data.merchantName
        dateLabel.text = argument.data.createdAt.toString()
        senderNameLabel.text = userData?.fullName
        nominalLabel.text = argument.data.nominal.formatToIDR()
        bottomButton.setTitle(isFromHistoryTransaction ? "Back Home" : "Pay Now", for: .normal)
        bottomButton.titleLabel?.font = UIFont.SofiaRegularFont(size: 16)
        
        if !isFromHistoryTransaction {
            fetchData()
        }
    }
    
    private func navigateToHome() {
        let vc = HomeRouter.createModule()
        navigatePushToPage(vc)
    }
    
    private func showSuccessBottomSheet() {
        let vc = InformationSheetViewController()
        vc.onPressConfirmButton = {
            self.navigateToHome()
        }
        
        showBottomSheet(controller: vc, sizes: [.fixed(600)], dismissOnPull: false)
    }
}

extension TransactionDetailViewController: TransactionDetailPresenterToViewProtocol {
    
    func onSuccessPayQRIS() {
        showSuccessBottomSheet()
    }
    
    func onErrorPayQRIS(error: Error) {
        showAlertDialog(title: "Error", message: "Oops, failed to payment this transaction, please try again!")
    }
    
    func notifyLoadingStateChanged() {
        showHideLoading(presenter?.isLoading ?? false)
    }
    
    func onSuccessGetBalance(data: Balance) {
        setUserBalance(data)
    }
    
    func onErrorGetBalance(error: Error) {
        
    }
    
    func onSuccessGetTransactionDetail(data: TransactionDetailArgument) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            self.setData(data)
            self.presenter?.hasFinishGetArgument = true
        })
    }
}
