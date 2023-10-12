//
//  FirebaseAuthService.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 10/10/23.
//

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class FirebaseAuthService {
    static let shared = FirebaseAuthService()
    
    private init() {}
    
    func createAuthUser(with userRegisterRequest: UserRegisterRequest, completion: @escaping (Bool, Error?) -> Void) {
        let fullName = userRegisterRequest.fullName
        let email = userRegisterRequest.email
        let password = userRegisterRequest.password
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let _eror = error {
                completion(false, error)
                
                return
            }
            
            if let result = result {
                let request = UserRegisterRequest(fullName: fullName, email: email, password: password)
                FirestoreService.shared.createUser(with: request, uid: result.user.uid, completion: { result, error in
                    if let error = error {
                        completion(false, error)
                        
                        return
                    }
                    
                    let request = UserLoginRequest(email: email, password: password)
                    self.loginUser(with: request, completion: { result, error in
                        if let error = error {
                            completion(false, error)
                            
                            return
                        }
                        
                        completion(true, nil)
                    })
                })
            }
        }
    }
    
    func loginUser(with userLoginRequest: UserLoginRequest, completion: @escaping (Bool, Error?) -> Void) {
        let email = userLoginRequest.email
        let password = userLoginRequest.password
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { result, error in
            if let error = error {
                completion(false, error)
                
                return
            }
            
            completion(true, nil)
        })
    }
    
    func logoutUser(completion: @escaping (Bool, Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true, nil)
            UserDefaults.standard.clearUserData()
        } catch let error {
            completion(false, error)
        }
    }
    
    func checkAuthenticationUser(completion: @escaping (Bool) -> Void) {
        if Auth.auth().currentUser == nil {
            completion(false)
            
            return
        }
        
        completion(true)
    }
    
    func getUserId() -> String {
        return Auth.auth().currentUser?.uid ?? ""
    }
}
