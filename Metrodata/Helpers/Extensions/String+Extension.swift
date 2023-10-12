//
//  String+Extension.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 12/10/23.
//

import Foundation

extension String {
    
    var newLineText: String {
        return self.replacingOccurrences(of: "\\n", with: "\n")
    }
    
    var imageCover: String {
        return ApiURL.imageBaseURL.rawValue + self
    }
    
    func toDouble() -> Double {
        return Double(self) ?? 0
    }
    
    func toInt() -> Int {
        return Int(self) ?? 0
    }
}
