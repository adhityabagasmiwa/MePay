//
//  Transaction.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 12/10/23.
//

import Foundation

struct Transaction: Decodable {
    let transactionId: Int
    let merchantName: String
    let bankName: String
    let nominal: Int
    let createdAt: Date
    let uid: String
    
    enum CodingKeys: String, CodingKey {
        case nominal
        case uid
        case transactionId = "transaction_id"
        case merchantName = "merchant_name"
        case bankName = "bank_name" 
        case createdAt = "created_at"
    }
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.transactionId = try container.decode(Int.self, forKey: .transactionId)
//        self.merchantName = try container.decode(String.self, forKey: .merchantName)
//        self.nominal = try container.decode(Int.self, forKey: .nominal)
//        
//        let timestamp = try container.decode(Double.self, forKey: .createdAt)
//        self.createdAt = Date(timeIntervalSince1970: timestamp)
//        
//        self.uid = try container.decode(String.self, forKey: .uid)
//    }
}

struct TransactionQR {
    let id: Int
    let sourceBank: String
    let merchantName: String
    let amount: Int
}
