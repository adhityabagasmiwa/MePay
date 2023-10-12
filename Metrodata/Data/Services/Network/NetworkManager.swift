//
//  NetworkManager.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 10/10/23.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol {
    func fetchAPI<T: Decodable>(fromUrl: String, forType type: T.Type, method: HTTPMethod, parameters: Parameters?, completion : @escaping ((Result<T, APIError>) -> Void))
}

class NetworkManager: NetworkManagerProtocol {
    let headers: HTTPHeaders = [
        "accept": "application/json"
        //        "Authorization": "Bearer \(Constants.authToken)"
    ]
    
    func fetchAPI<T>(fromUrl: String, forType type: T.Type, method: HTTPMethod, parameters: Parameters?, completion: @escaping ((Result<T, APIError>) -> Void)) where T : Decodable {
        AF.request(fromUrl, method: method, parameters: parameters, headers: headers)
            .validate(statusCode: 200..<600)
            .responseDecodable(of: type, completionHandler: { response in
                switch response.result {
                    case .success(let data):
                        debugPrint("[LOG - RESPONSE][\(fromUrl)]: ", response)
                        completion(.success(data))
                    case .failure(let error):
                        if let data = response.data {
                            do {
                                let decoder = JSONDecoder()
                                let _ = try decoder.decode(T.self, from: data)
                            } catch let error {
                                debugPrint("[LOG - ERROR - INVALID DATA][\(fromUrl)]: ", error)
                                completion(.failure(.invalidData))
                            }
                        } else {
                            debugPrint("[LOG - ERROR - INVALID RESPONSE][\(fromUrl)]: ", error)
                            completion(.failure(.invalidResponse))
                        }
                }
            }
            )
    }
}
