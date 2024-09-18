//
//  ToDo.swift
//  BlogDemo
//
//  Created by Febin Puthalath on 17/09/24.
//

import Foundation
import CouchbaseLiteSwift

// UserProfile model
class ToDo: Codable {
    var id :String?
    var name: String

    init(name: String,id: String? = nil) {
        self.name = name
        self.id = id
    }
    
    // Convert UserProfile to MutableDocument
    func toMutableDocument() -> MutableDocument {
//        let mutableDoc = MutableDocument().setString(String(UUID().uuidString), forKey: "id")
//            .setString(self.name, forKey: "name")
//            .setString(self.email, forKey: "email")
//        return mutableDoc
        let mutableDoc = MutableDocument()
            .setString(String(UUID().uuidString), forKey: "id")
            .setString(self.name, forKey: "name")
        return mutableDoc
    }
    
    // Initialize UserProfile from Document
    static func from(document: Document) -> ToDo? {
        guard let name = document.string(forKey: "name"),let id = document.string(forKey: "id")
               else {
            return nil
        }
        return ToDo(name: name,id: id)
    }
}
