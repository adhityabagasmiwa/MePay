//
//  UIView+Extension.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 12/10/23.
//

import UIKit
import NVActivityIndicatorView

extension UIView {
    private var loadingTag: Int { return 999 }

    class func initFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as! T
    }
    
    func startLoadingAnimating() {
        let loadingView = UIView(frame: self.bounds)
        loadingView.tag = loadingTag
        loadingView.backgroundColor = .black.withAlphaComponent(0.1)
        
        let indicatorLoading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 48, height: 48), type: .ballBeat, color: .accent, padding: 0)
        indicatorLoading.translatesAutoresizingMaskIntoConstraints = false
        indicatorLoading.startAnimating()
        
        loadingView.addSubview(indicatorLoading)
        addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            indicatorLoading.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicatorLoading.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func stopLoadingAnimating() {
        if let loadingView = viewWithTag(loadingTag) {
            loadingView.removeFromSuperview()
        }
    }
}
