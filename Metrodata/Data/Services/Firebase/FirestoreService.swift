//
//  FirestoreService.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 10/10/23.
//

import FirebaseCore
import FirebaseFirestore

class FirestoreService {
    static let shared = FirestoreService()
    
    private init() {}
    
    func fetchUser(completion: @escaping (User?, Error?) -> Void) {
        let uid = FirebaseAuthService.shared.getUserId()
        
        FirestoreManager.referenceForUser(uid: uid).getDocument(completion: { snapshot, error in
            if let error = error {
                completion(nil, error)
                
                return
            }
            
            if let snapshot = snapshot, snapshot.exists {
                if let timestampCreatedAt = snapshot.get("created_at") as? Timestamp {
                    let secondsCreatedAt = timestampCreatedAt.seconds
                    
                    var updatedData = snapshot.data() ?? [:]
                    updatedData["created_at"] = secondsCreatedAt
                    
                    if let jsonData = try? JSONSerialization.data(withJSONObject: updatedData, options: []) {
                        if let jsonString = String(data: jsonData, encoding: .utf8) {
                            do {
                                let result = try SwiftUtility.decodeJSON(jsonString, as: User.self)
                                UserDefaults.standard.setUserData(value: result)
                                completion(result, nil)
                            } catch {
                                debugPrint("[LOG][ERROR] - DECODE JSON]: ", error.localizedDescription)
                            }
                        } else {
                            debugPrint("[LOG][ERROR]: Failed to convert data to string")
                        }
                    } else {
                        debugPrint("[LOG][ERROR]: Failed to convert dictionary to data")
                    }
                }
            }
        })
    }
    
    func createUser(with request: UserRegisterRequest, uid: String, completion: @escaping (Bool, Error?) -> Void) {
        let timestamp = Timestamp(date: Date())
        
        let requestCreateUser: [String: Any] = [
            "email": request.email,
            "full_name": request.fullName,
            "password": request.password,
            "uid": uid,
            "created_at": timestamp
        ] as [String : Any]
        
        FirestoreManager.referenceForUser(uid: uid).setData(requestCreateUser) { error in
            if let error = error {
                completion(false, error)
                
                return
            }
            
            completion(true, nil)
        }
    }
    
    func createNewBalance(uid: String, completion: @escaping (Bool, Error?) -> Void) {
        let timestamp = Timestamp(date: Date())
        let cardNumber = "CN\(Date().toString(format: "ddyyyyhmma"))"
        
        let requestNewBalances: [String: Any] = [
            "card_number": cardNumber,
            "created_at": timestamp,
            "updated_at": timestamp,
            "nominal": 0
        ] as [String : Any]
        
        FirestoreManager.referenceForBalance(uid: uid).setData(requestNewBalances) { error in
            if let error = error {
                completion(false, error)
                
                return
            }
            
            completion(true, nil)
        }
    }
    
    func fetchBalance(completion: @escaping (Balance?, Error?) -> Void) {
        let uid = FirebaseAuthService.shared.getUserId()
        
        FirestoreManager.referenceForBalance(uid: uid).getDocument { snapshot, error in
            if let error = error {
                completion(nil, error)
                
                return
            }
            
            if let snapshot = snapshot, snapshot.exists {
                if let timestampCreatedAt = snapshot.get("created_at") as? Timestamp, let timestampUpdatedAt = snapshot.get("updated_at") as? Timestamp {
                    let secondsCreatedAt = timestampCreatedAt.seconds
                    let secondsUpdatedAt = timestampUpdatedAt.seconds
                    
                    var updatedData = snapshot.data() ?? [:]
                    updatedData["created_at"] = secondsCreatedAt
                    updatedData["updated_at"] = secondsUpdatedAt
                    
                    if let jsonData = try? JSONSerialization.data(withJSONObject: updatedData, options: []) {
                        if let jsonString = String(data: jsonData, encoding: .utf8) {
                            do {
                                let result = try SwiftUtility.decodeJSON(jsonString, as: Balance.self)
                                completion(result, nil)
                            } catch {
                                debugPrint("[LOG][ERROR] - DECODE JSON]: ", error.localizedDescription)
                            }
                        } else {
                            debugPrint("[LOG][ERROR]: Failed to convert data to string")
                        }
                    } else {
                        debugPrint("[LOG][ERROR]: Failed to convert dictionary to data")
                    }
                }
            }
        }
    }
    
    func fetchHistoryTransaction(completion: @escaping ([Transaction]?, Error?) -> Void) {
        let uid = FirebaseAuthService.shared.getUserId()
        
        FirestoreManager.referenceForTransactions(completion: { snapshots, error in
            if let snapshots = snapshots {
                var snaphotsData = []
                for snapshot in snapshots {
                    snaphotsData.append(snapshot.data() as Any)
                }
                
                var resultsData = []
                for snapshotData in snaphotsData {
                    if let snapshotDataDict = snapshotData as? [String: Any], let timestamp = snapshotDataDict["created_at"] as? Timestamp {
                        let seconds = timestamp.seconds
                        
                        var updatedData = snapshotDataDict
                        updatedData["created_at"] = seconds
                        
                        resultsData.append(updatedData)
                    }
                }
                
                if let jsonData = try? JSONSerialization.data(withJSONObject: resultsData, options: []) {
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        do {
                            let result = try SwiftUtility.decodeJSON(jsonString, as: [Transaction].self)
                            let filteredData = result.sorted(by: {$0.createdAt > $1.createdAt} ).filter { $0.uid == uid }
                            completion(filteredData, nil)
                        } catch {
                            debugPrint("[LOG][ERROR] - DECODE JSON]: ", error.localizedDescription)
                        }
                    } else {
                        debugPrint("[LOG][ERROR]: Failed to convert data to string")
                    }
                } else {
                    debugPrint("[LOG][ERROR]: Failed to convert dictionary to data")
                }
            }
        })
    }
    
    func createTransaction(with request: TransactionRequest, completion: @escaping (Bool, Error?) -> Void) {
        let uid = FirebaseAuthService.shared.getUserId()
        let refId = UUID().uuidString
        let timestamp = Timestamp(date: Date())
        
        let requestTransaction: [String: Any] = [
            "transaction_id": request.id,
            "merchant_name": request.merchantName,
            "bank_name": request.bankName,
            "nominal": request.amount,
            "uid": uid,
            "created_at": timestamp
        ] as [String : Any]
        
        FirestoreManager.referenceForTransaction(uid: refId).setData(requestTransaction) { error in
            if let error = error {
                completion(false, error)
                
                return
            }
            
            self.updateBalance(uid: uid, amount: request.amount, completion: { result, error in
                if let error = error {
                    completion(false, error)
                    
                    return
                }
                
                completion(true, nil)
            })
        }
    }
    
    func updateBalance(uid: String, amount: Int, completion: @escaping (Bool, Error?) -> Void) {
        fetchBalance(completion: { result, error in
            if let error = error {
                debugPrint("[LOG][ERROR] - GET BALANCE]: ", error.localizedDescription)
                
                return
            }
            
            if let result = result {
                let newBalance = result.nominal - amount
                let timestamp = Timestamp(date: Date())
                
                let fields: [AnyHashable: Any] = [
                    "nominal": newBalance,
                    "updated_at": timestamp
                ]
                
                FirestoreManager.referenceForBalance(uid: uid).updateData(fields, completion: { error in
                    if let error = error {
                        completion(false, error)
                    } else {
                        completion(true, nil)
                    }
                })
            }
        })
    }
}
