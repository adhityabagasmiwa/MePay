//
//  UserDefaults.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 12/10/23.
//

import Foundation

extension UserDefaults {
    
    func setOnboarded(value: Bool) {
        set(value, forKey: UserDefaultsKeys.onBoarding.rawValue)
    }
    
    func getOnboarded()-> Bool {
        return bool(forKey: UserDefaultsKeys.onBoarding.rawValue)
    }
    
    func setUserData(value: User?) {
        guard let userData = value else {
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userData.rawValue)
            return
        }
        do {
            let encoder = JSONEncoder()
            let encodedUserData = try encoder.encode(userData)
            set(encodedUserData, forKey: UserDefaultsKeys.userData.rawValue)
        } catch {
            
        }
    }
    
    func getUserData() -> User? {
        if let userData = UserDefaults.standard.data(forKey: UserDefaultsKeys.userData.rawValue) {
            do {
                let decoder = JSONDecoder()
                let decodedUserData = try decoder.decode(User.self, from: userData)
                return decodedUserData
            } catch {
                
            }
        }
        
        return nil
    }
    
    func clearUserData() {
        setUserData(value: nil)
        setOnboarded(value: false)
    }
}
