//
//  UIFont+Extension.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 11/10/23.
//

import UIKit

extension UIFont {
    
    static func SofiaRegularFont(size: CGFloat) -> UIFont {
        return UIFont.init(name: "Sofia-Pro-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func SofiaSemiboldFont(size: CGFloat) -> UIFont {
        return UIFont.init(name: "Sofia-Pro-SemiBold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    static func SofiaBoldFont(size: CGFloat) -> UIFont {
        return UIFont.init(name: "Sofia-Pro-Bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
}
