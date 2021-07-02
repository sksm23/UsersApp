//
//  HomeViewModel.swift
//  UsersApp
//
//  Created by Sunil Kumar on 01/07/21.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {
    
    var usersList = BehaviorRelay<[UserDetails]>(value: [])
    let homeModel = HomeModel()
    var displayUserList: [UserDetails] = []
    var likedUserList: [UserDetails] = []
    let coreDataManager = CoreDataManager()
    
    func segregateUsersWith(index: Int) {
        getLikedProfileList()
        if index == 0 { // first segment index
            displayUserList = usersList.value.filter { $0.gender == "male" }
        } else {
            displayUserList = usersList.value.filter { $0.gender == "female" }
        }
    }
    
    func userDetailsAt(index: Int) -> (UserDetails, Bool) {
        let user = displayUserList[index]
        let isLiked = likedUserList.filter({ $0._id == user._id }).count > 0
        return (user, isLiked)
    }
    
    // Core data
    func updateLikedProfile(user: UserDetails, like: Bool) {
        coreDataManager.saveLikedUserData(userData: user, isLike: like)
        getLikedProfileList()
    }
    
    func getLikedProfileList() {
        coreDataManager.retrieveLikedUserList { [weak self] userList in
            if let list = userList {
                self?.likedUserList = list
            }
        }
    }
    
    // Api
    func fetchUserList() {
        homeModel.fetchUserList { [weak self] users, error in
            if let list = users {
                self?.usersList.accept(list)
            }
            if let localizedDescription = error?.localizedDescription {
                print(localizedDescription)
            }
        }
    }
}
