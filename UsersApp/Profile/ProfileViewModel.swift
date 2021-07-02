//
//  ProfileViewModel.swift
//  Users
//
//  Created by Sunil Kumar on 30/06/21.
//

import Foundation
import RxSwift
import RxCocoa

class ProfileViewModel {
    
    var userDetails = UserDetails()
    let coreDataManager = CoreDataManager()
    var currentUser = BehaviorRelay<UserDetails>(value: UserDetails())
    
    func saveUserDetails() {
        coreDataManager.saveCurrentUserData(userData: userDetails)
    }
    
    func retriveUserDetails() {
        coreDataManager.retrieveCurrentUserData { [weak self] user in
            if let userDetails = user {
                self?.currentUser.accept(userDetails)
            }
        }
    }
    
    func isLoggedInUser() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
}
