//
//  ApiError.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 10/10/23.
//

import Foundation

enum APIError: String, Error {
    case invalidData = "The data received from server is invalid, please try again"
    case invalidResponse = "Invalid response from server"
}
