//
//  TextFieldVisibility.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 11/10/23.
//

import UIKit

class TextFieldVisibility: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.isSecureTextEntry = true
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width - 40), height: 32))
        button.setImage(UIImage(systemName: "eye")?.withTintColor(.separator, renderingMode: .alwaysOriginal), for: .normal)
        button.setImage(UIImage(systemName: "eye.slash")?.withTintColor(.separator, renderingMode: .alwaysOriginal), for: .normal)
        
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8)
            config.baseBackgroundColor = .clear
            button.configuration = config
        } else {
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        }
        
        rightView = button
        rightViewMode = .always
        button.addTarget(self, action: #selector(showHidePassword(_:)), for: .touchUpInside)
    }
    
    @objc private func showHidePassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.isSecureTextEntry = !sender.isSelected
    }
}
