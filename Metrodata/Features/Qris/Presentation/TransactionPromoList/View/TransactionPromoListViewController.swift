//
//  TransactionPromoListViewController.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 12/10/23.
//

import UIKit

class TransactionPromoListViewController: UIViewController, CollectionViewConfigurable, TableViewConfigurable {

    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var transactionSectionView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var promoSectionView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var presenter: TransactionPromoListViewToPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupDelegate()
        setupCell()
        setArgument()
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

extension TransactionPromoListViewController {
    
    private func fetchData(isTransaction: Bool, query: String) {
        if isTransaction {
            presenter?.fetchHistoryTransactions(query: query)
        } else {
            presenter?.fetchPromos(query: query)
        }
    }
    
    private func setupDelegate() {
        searchBar.delegate = self
    }

    private func setupCell() {
        configureTableView(nibName: TransactionCardTableViewCell.cellId)
        configurableCollectionView(nibName: PromoCardCollectionViewCell.cellId)
    }
    
    private func setupUI() {
        searchBar.searchTextField.layer.cornerRadius = 16
        searchBar.searchTextField.layer.masksToBounds = true
    }
    
    private func setArgument() {
        guard let isFromTransaction = presenter?.isFromTransaction else { return }
        
        navigationTitleLabel.text = isFromTransaction ? "Recent Transactions" : "Promo"
        searchBar.placeholder = isFromTransaction ? "Search recent transactions" : "Search promo"
        transactionSectionView.isHidden = !isFromTransaction
        promoSectionView.isHidden = isFromTransaction
        
        fetchData(isTransaction: isFromTransaction, query: "")
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
}

extension TransactionPromoListViewController: TransactionPromoListPresenterToViewProtocol {
    
    func notifyLoadingStateChanged() {
        showHideLoading(presenter?.isLoading ?? false)
    }
    
    func onSuccessGetPromos() {
        collectionView.reloadData()
    }
    
    func onErrorGetPromos(error: APIError) {
        
    }
    
    func onSuccessGetHistoryTransactions() {
        tableView.reloadData()
    }
    
    func onErrorGetHistoryTransactions(error: Error) {
        
    }
}


extension TransactionPromoListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.promos.count ?? 0
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

extension TransactionPromoListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let promos = presenter?.promos {
            let promo = promos[indexPath.row]
            navigateToPromoDetail(promo)
        }
    }
}

extension TransactionPromoListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.historyTransactions.count ?? 0
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

extension TransactionPromoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let transactions = presenter?.historyTransactions {
            let transaction = transactions[indexPath.row]
            navigateToTransactionDetail(transaction)
        }
    }
}

extension TransactionPromoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != "" {
            guard let isFromTransaction = presenter?.isFromTransaction else { return }
            
            fetchData(isTransaction: isFromTransaction, query: searchBar.text ?? "")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            guard let isFromTransaction = presenter?.isFromTransaction else { return }
            
            fetchData(isTransaction: isFromTransaction, query: "")
        }
    }
}

