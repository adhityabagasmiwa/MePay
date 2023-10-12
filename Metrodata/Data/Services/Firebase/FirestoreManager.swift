//
//  FirestoreManager.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 10/10/23.
//

import FirebaseCore
import FirebaseFirestore

class FirestoreManager {
    static let env = "dev"
    
    static let db = Firestore.firestore()
    static let root = db.collection(env).document(env)
    
    static func referenceForTransactions(completion: @escaping ([DocumentSnapshot]?, Error?) -> Void) {
        root
            .collection(FirebaseKeys.CollectionPath.transactions)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(querySnapshot?.documents, nil)
                }
            }
    }
    
    static func referenceForTransaction(uid: String) -> DocumentReference {
        return root
            .collection(FirebaseKeys.CollectionPath.transactions)
            .document(uid)
    }
    
    static func referenceForBalance(uid: String) -> DocumentReference {
        return root
            .collection(FirebaseKeys.CollectionPath.balances)
            .document(uid)
    }
    
    static func referenceForUser(uid: String) -> DocumentReference {
        return root
            .collection(FirebaseKeys.CollectionPath.users)
            .document(uid)
    }
}
