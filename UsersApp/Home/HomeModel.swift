//
//  HomeModel.swift
//  UsersApp
//
//  Created by Sunil Kumar on 01/07/21.
//

import Foundation

class HomeModel {

    let networkManager = NetworkManager()
    let urlString = "http://www.json-generator.com/api/json/get/ceiNKFwyaa?indent=2"
    
    func fetchUserList(completionHandler: @escaping ([UserDetails]?, Error?) -> Void) {
        networkManager.apiRequestWith(urlString: urlString) { data, response, error in
            if let userData = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let users = try jsonDecoder.decode([UserDetails].self, from: userData)
                    completionHandler(users, nil)
                } catch {
                    print("Unable to decode!")
                }
            }
            if let err = error {
                completionHandler(nil, err)
            }
        }
    }

    func fetchUserImage(imageUrl: String ,completionHandler: @escaping (Data?, Error?) -> Void) {
        networkManager.apiRequestWith(urlString: imageUrl) { data, response, error in
            if let imageData = data {
                completionHandler(imageData, nil)
            }
            if let err = error {
                completionHandler(nil, err)
            }
        }
    }
}
