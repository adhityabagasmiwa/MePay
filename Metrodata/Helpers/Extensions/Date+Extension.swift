//
//  Date+Extension.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 12/10/23.
//

import Foundation

extension Date {
    
    func toString(format dateFormat: String? = "dd MMM yyyy, h:mm a") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        let formattedDate = dateFormatter.string(from: self)
        
        return formattedDate
    }
}
