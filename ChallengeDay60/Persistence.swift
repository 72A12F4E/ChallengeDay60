//
//  Persistence.swift
//  ChallengeDay60
//
//  Created by Blake McAnally on 2/11/21.
//

import CoreData
import Combine

class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    private var cancellables: Set<AnyCancellable> = []

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ChallengeDay60")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        updateFriends()
    }
    
    func updateFriends() {
        UsersAPI.Client()
            .fetchUsers()
            .catch { error -> AnyPublisher<[UsersAPI.User], Never> in
                print(error)
                return Just([UsersAPI.User]()).eraseToAnyPublisher()
            }
            .sink { users in
                self.storeUsers(users)
            }.store(in: &cancellables)
    }
    
    private func storeUsers(_ users: [UsersAPI.User]) {
        let context = container.viewContext
        
        // Save Tags
        var allTags: Set<String> = []
        for user in users {
            allTags.formUnion(user.tags)
        }
        
        var tagModels: [Tag] = []
        for tag in allTags {
            let tagModel = Tag(context: context)
            tagModel.name = tag
            tagModels.append(tagModel)
        }
        
        // Create Users
        var userModels: [User] = []
        for user in users {
            let userModel = User(context: context)            
            userModel.id = user.id
            userModel.isActive = user.isActive
            userModel.name = user.name
            userModel.age = Int64(user.age)
            userModel.company = user.company
            userModel.email = user.email
            userModel.address = user.address
            userModel.about = user.about
            userModel.registered = user.registered
            userModels.append(userModel)
        }
        
        for (userModel, user) in zip(userModels, users) {
            // Set up self-referential relationship for friends list
            userModels.filter { model in
                user.friends.contains { friend in
                    model.id == friend.id
                }
            }.forEach {
                userModel.addToFriends($0)
            }
            
            // Add Tags
            tagModels.filter {
                user.tags.contains($0.name ?? "")
            }.forEach {
                userModel.addToTags($0)
            }
        }
        
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
