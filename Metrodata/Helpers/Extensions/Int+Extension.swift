//
//  Int+Extension.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 11/10/23.
//

import Foundation

extension Int {
    
    func toDouble() -> Double {
        return Double(self)
    }
    
    func toString() -> String {
        return String(self)
    }
    
    func formatToIDR() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "id_ID")
        
        let amountInDecimal = Decimal(self)
        if let formattedAmount = numberFormatter.string(from: NSDecimalNumber(decimal: amountInDecimal)) {
            return formattedAmount
        } else {
            return "Invalid amount"
        }
    }
}
