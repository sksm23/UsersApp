//
//  NetworkManager.swift
//  UsersApp
//
//  Created by Sunil Kumar on 30/06/21.
//

import Foundation

class NetworkManager {
    
    func apiRequestWith(urlString: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                completionHandler(data, response, error)
            }.resume()
        }
    }
}
