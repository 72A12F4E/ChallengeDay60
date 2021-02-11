//
//  UsersAPI.swift
//  ChallengeDay60
//
//  Created by Blake McAnally on 2/11/21.
//

import Foundation
import Combine

enum UsersAPI {
    struct User: Codable {
        let id: UUID
        let isActive: Bool
        let name: String
        let age: Int
        let company: String
        let email: String
        let address: String
        let about: String
        let registered: Date
        let tags: [String]
        let friends: [Friend]
    }

    struct Friend: Codable {
        let id: UUID
        let name: String
    }
    
    class Client {
        private let friendsURL = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
        
        private lazy var decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return decoder
        }()
        
        func fetchUsers() -> AnyPublisher<[User], Error> {
            URLSession.shared.dataTaskPublisher(for: friendsURL)
                .map(\.data)
                .decode(type: [User].self, decoder: decoder)
                .eraseToAnyPublisher()
        }
    }
}
