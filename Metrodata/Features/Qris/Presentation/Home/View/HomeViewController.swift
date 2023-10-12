//
//  HomeViewController.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 11/10/23.
//

import UIKit

class HomeViewController: UIViewController, TableViewConfigurable, CollectionViewConfigurable {
    
    @IBOutlet weak var scannerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewTransactionConstraints: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userBalanceLabel: UILabel!
    
    weak var presenter: HomeViewToPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupCell()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func onPressScanQRButton(_ sender: Any) {
        navigateToScanQRIS()
    }
    
    @IBAction func onPressLogoutButton(_ sender: Any) {
        showAlertDialogConfirmation(
            title: "Confirmation",
            message: "Are you sure to logout?",
            action: { _ in
                self.fetchLogoutRequest()
            }
        )
    }
    
    @IBAction func onPressSeeAllTransactionButton(_ sender: Any) {
        navigateToTransactionPromo(isFromTransaction: true)
    }
    
    @IBAction func onPressSeeAllPromoButton(_ sender: Any) {
        navigateToTransactionPromo(isFromTransaction: false)
    }
}

extension HomeViewController {
    
    private func setupUI() {
        scannerView.layer.cornerRadius = 8
        scannerView.clipsToBounds = true
    }
    
    private func setupCell() {
        configureTableView(nibName: TransactionCardTableViewCell.cellId)
        configurableCollectionView(nibName: PromoCardCollectionViewCell.cellId)
    }
    
    private func fetchData() {
        presenter?.fetchPromos()
        presenter?.fetchHistoryTransactions()
        presenter?.fetchBalance()
        presenter?.fetchUserData()
    }
    
    private func fetchLogoutRequest() {
        presenter?.fetchLogoutRequest()
    }
    
    private func setUserBalance(_ data: Balance) {
        userBalanceLabel.text = data.nominal.formatToIDR()
    }
    
    private func setUserData(_ data: User) {
        nameLabel.text = data.fullName
    }
    
    private func navigateToScanQRIS() {
        let vc = ScannerQRRouter.createModule()
        navigatePushToPage(vc)
    }
    
    private func navigateToPromoDetail(_ data: Promo) {
        let vc = PromoDetailRouter.createModule(argument: data)
        navigatePushToPage(vc)
    }
    
    private func navigateToTransactionDetail(_ data: Transaction) {
        let argument = TransactionDetailArgument(isFromHistoryTransaction: true, data: data)
        let vc = TransactionDetailRouter.createModule(argument: argument)
        navigatePushToPage(vc)
    }
    
    private func navigateToLogin() {
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.checkAuthentication()
        }
    }
    
    private func navigateToTransactionPromo(isFromTransaction: Bool) {
        let vc = TransactionPromoListRouter.createModule(isFromTransaction: isFromTransaction)
        navigatePushToPage(vc)
    }
}

extension HomeViewController: HomePresenterToViewProtocol {
    
    func notifyLoadingStateChanged() {
        showHideLoading(presenter?.isLoading ?? false)
    }
    
    func onSuccessGetPromos() {
        collectionView.reloadData()
    }
    
    func onErrorGetPromos(error: APIError) {
        
    }
    
    func onSuccessGetHistoryTransactions() {
        if let transactions = presenter?.historyTransactions {
            let count = transactions.count > 3 ? 3 : transactions.count
            tableViewTransactionConstraints.constant = CGFloat(count * 86)
            tableView.reloadData()
        }
    }
    
    func onErrorGetHistoryTransactions(error: Error) {
        
    }
    
    func onSuccessGetBalance(data: Balance) {
        setUserBalance(data)
    }
    
    func onErrorGetBalance(error: Error) {
        
    }
    
    func onSuccessGetUserData(data: User) {
        setUserData(data)
    }
    
    func onErrorGetUserData(error: Error) {
        
    }
    
    func onSuccessLogout() {
        navigateToLogin()
    }
    
    func onErrorLogout(error: Error) {
        showAlertDialog(title: "Error", message: "Oops, failed to logout, please try again!")
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = presenter?.promos.count ?? 0
        return count > 3 ? 3 : count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PromoCardCollectionViewCell.cellId, for: indexPath) as! PromoCardCollectionViewCell
        cell.mainView.translatesAutoresizingMaskIntoConstraints = false
        cell.mainView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 48).isActive = true
        
        guard let promos = presenter?.promos else { return cell }
        
        let promo = promos[indexPath.row]
        cell.setData(promo)
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let promos = presenter?.promos {
            let promo = promos[indexPath.row]
            navigateToPromoDetail(promo)
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = presenter?.historyTransactions.count ?? 0
        return count > 3 ? 3 : count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCardTableViewCell.cellId, for: indexPath) as! TransactionCardTableViewCell
        
        guard let transactions = presenter?.historyTransactions else { return cell }
        
        let transaction = transactions[indexPath.row]
        cell.setData(transaction)
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = .zero
        cell.selectionStyle = .none
        
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let transactions = presenter?.historyTransactions {
            let transaction = transactions[indexPath.row]
            navigateToTransactionDetail(transaction)
        }
    }
}
