//
//  ProfileModel.swift
//  UsersApp
//
//  Created by Sunil Kumar on 01/07/21.
//

import Foundation

struct UserDetails: Codable {
    var name = ""
    var age: Int16 = 0
    var gender = ""
    var picture = ""
    var pictureData: Data?
    var _id = ""
    //var isLiked = false
}
