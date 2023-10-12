//
//  User.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 12/10/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

struct User: Codable {
    let createdAt: Date
    let email: String
    let fullName: String
    let password: String
    let uid: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
        case uid
        case fullName = "full_name"
        case createdAt = "created_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.fullName = try container.decode(String.self, forKey: .fullName)
        self.email = try container.decode(String.self, forKey: .email)
        self.password = try container.decode(String.self, forKey: .password)
        self.uid = try container.decode(String.self, forKey: .uid)
        
        let timestampCreatedAt = try container.decode(Double.self, forKey: .createdAt)
        self.createdAt = Date(timeIntervalSince1970: timestampCreatedAt)
    }
}
