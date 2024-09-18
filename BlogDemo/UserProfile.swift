//
//  UserProfile.swift
//  BlogDemo
//
//  Created by Febin Puthalath on 17/09/24.
//

import Foundation
import CouchbaseLiteSwift

// UserProfile model
class UserProfile: Codable {
    var id: String?
    var name: String
    var email: String

    init(name: String, email: String,id: String? = nil) {
        self.name = name
        self.email = email
        self.id = id
    }
    
    // Convert UserProfile to MutableDocument
    func toMutableDocument() -> MutableDocument {
//        let mutableDoc = MutableDocument().setString(String(UUID().uuidString), forKey: "id")
//            .setString(self.name, forKey: "name")
//            .setString(self.email, forKey: "email")
//        return mutableDoc
        let mutableDoc = MutableDocument()
            .setString(self.name, forKey: "name")
            .setString(self.email, forKey: "email")
        return mutableDoc
    }
    
    // Initialize UserProfile from Document
    static func from(document: Document) -> UserProfile? {
        guard let name = document.string(forKey: "name"),
              let email = document.string(forKey: "email")
               else {
            return nil
        }
        return UserProfile(name: name, email: email,id: document.id)
    }
}
