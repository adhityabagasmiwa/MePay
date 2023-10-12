//
//  Balance.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 12/10/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

struct Balance: Decodable {
    let cardNumber: String
    let nominal: Int
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case nominal
        case cardNumber = "card_number"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cardNumber = try container.decode(String.self, forKey: .cardNumber)
        self.nominal = try container.decode(Int.self, forKey: .nominal)
        
        let timestampCreatedAt = try container.decode(Double.self, forKey: .createdAt)
        self.createdAt = Date(timeIntervalSince1970: timestampCreatedAt)
        
        let timestampUpdatedAt = try container.decode(Double.self, forKey: .updatedAt)
        self.updatedAt = Date(timeIntervalSince1970: timestampUpdatedAt)
    }
}
