//
//  CoreDataManager.swift
//  UsersApp
//
//  Created by Sunil Kumar on 30/06/21.
//

import UIKit
import CoreData

class CoreDataManager {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - 'CurrentUser'
    func saveCurrentUserData(userData: UserDetails) {
        let persistentContainer = appDelegate.persistentContainer
        persistentContainer.performBackgroundTask { backgroundContext in
            let userEntity = NSEntityDescription.entity(forEntityName: "CurrentUser", in: backgroundContext)!
            let user = CurrentUser(entity: userEntity, insertInto: backgroundContext)
            user.name = userData.name
            user.age = userData.age
            user.gender = userData.gender
            user.picture = userData.pictureData
            do {
                UserDefaults.standard.setValue(true, forKey: "isLoggedIn")
                try backgroundContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func retrieveCurrentUserData(completionHandler: @escaping ((UserDetails?) -> Void)) {
        let persistentContainer = appDelegate.persistentContainer
        persistentContainer.performBackgroundTask { backgroundContext in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrentUser")
            do {
                if let result = try backgroundContext.fetch(fetchRequest) as? [CurrentUser], let user = result.first {
                    var userDetails = UserDetails()
                    userDetails.name = user.name ?? ""
                    userDetails.age = user.age
                    userDetails.gender = user.gender ?? ""
                    userDetails.pictureData = user.picture
                    completionHandler(userDetails)
                }
            } catch {
                print("Failed")
            }
        }
    }
}

// MARK: - 'User' List
extension CoreDataManager {
    
    // MARK: - Current user
    func saveLikedUserData(userData: UserDetails, isLike: Bool) {
        if !isLike { // if not like, then delete
            deleteLikedUserData(userData: userData)
            return
        }
        let persistentContainer = appDelegate.persistentContainer
        persistentContainer.performBackgroundTask { backgroundContext in
            let userEntity = NSEntityDescription.entity(forEntityName: "User", in: backgroundContext)!
            let user = User(entity: userEntity, insertInto: backgroundContext)
            user.name = userData.name
            user.age = userData.age
            user.gender = userData.gender
            user.userId = userData._id
            do {
                try backgroundContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }

    func retrieveLikedUserList(completionHandler: @escaping (([UserDetails]?) -> Void)) {
        let persistentContainer = appDelegate.persistentContainer
        persistentContainer.performBackgroundTask { backgroundContext in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            do {
                if let result = try backgroundContext.fetch(fetchRequest) as? [User]{
                    var userDetailsList: [UserDetails] = []
                    for user in result {
                        var userDetails = UserDetails()
                        userDetails.name = user.name ?? ""
                        userDetails.age = user.age
                        userDetails.gender = user.gender ?? ""
                        userDetails.picture = user.picture ?? ""
                        userDetails._id = user.userId ?? ""
                        userDetailsList.append(userDetails)
                    }
                    completionHandler(userDetailsList)
                }
            } catch {
                print(error)
            }
        }
    }

    func deleteLikedUserData(userData: UserDetails) {
        let viewContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "userId = %@", userData._id)
        do {
            if let result = try viewContext.fetch(fetchRequest) as? [User], let objectToDelete = result.first {
                viewContext.delete(objectToDelete)
            }
            do {
                try viewContext.save()
            }
            catch {
                print(error)
            }
        }
        catch {
            print(error)
        }
    }
}
