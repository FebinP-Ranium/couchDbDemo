//
//  UserprofileManager.swift
//  BlogDemo
//
//  Created by Febin Puthalath on 17/09/24.
//

import Foundation
import CouchbaseLiteSwift

class UserProfileManager {
    private let collection: Collection

    init(database: Database) {
        self.collection = try! database.defaultCollection()
    }
    
    // Create or Update a UserProfile
    func saveUserProfile(_ userProfile: UserProfile,completion: @escaping (String?,Bool) -> ()) {
        do {
            let mutableDoc = userProfile.toMutableDocument()
            print(mutableDoc)
            try collection.save(document: mutableDoc)
            completion(mutableDoc.id,false)
        } catch {
            completion(nil,true)
        }
    }
    
    // Read a UserProfile by ID
    func readUserProfile(withID id: String, completion: @escaping (UserProfile?,Bool) -> Void) {
        do {
            if let document = try collection.document(id: id) {
                if let profile = UserProfile.from(document: document) {
                    completion(profile,false)
                } else {
                    completion(nil,true)
                }
            } else {
                completion(nil,true)
            }
        } catch {
            completion(nil,true)
        }
    }
    
    // Read multiple UserProfiles by name
    func readUserProfiles(byName name: String, completion: @escaping ([UserProfile]?,Bool) -> Void) {

        let database = DatabaseManager.shared.getDatabase()
        let query = QueryBuilder
                  .select(SelectResult.all())
                  .from(DataSource.database(database))
                  .where(Expression.property("name").equalTo(Expression.string(name)))

              // Run the query.
              do {
                  let result = try query.execute()
                  print("Number of rows :: \(result.allResults().count)")
              } catch {
                  fatalError("Error running the query")
              }
        
        
    }
   
   


    func listAllUserProfiles(completion: @escaping ([UserProfile]?, Bool) -> Void) {
        let query = QueryBuilder
            .select(SelectResult.expression(Meta.id), // Select the document ID explicitly
                    SelectResult.property("name"),
                    SelectResult.property("email"))
            .from(DataSource.collection(collection))

        do {
            let results = try query.execute()
            var profiles: [UserProfile] = []

            for row in results {
                // Fetch the document ID using Meta.id
                if let documentId = row.string(forKey: "id"), // This is the Couchbase document ID
                   let name = row.string(forKey: "name"),
                   let email = row.string(forKey: "email") {

                    print("\(documentId): \(name), \(email)")
                    
                    // Create a UserProfile object
                    let profile = UserProfile(name: name, email: email, id: documentId)
                    profiles.append(profile)
                } else {
                    print("Skipping row due to missing data.")
                }
            }

            completion(profiles, false)
        } catch {
            print("Error executing query: \(error)")
            completion(nil, true)
        }
    }

    func updateUserProfile(withID id: String, updatedProfile: UserProfile, completion: @escaping (Bool) -> Void) {
        do {
                    // Fetch the existing document
            if let document = try collection.document(id: id) {
                        // Start a new transaction
                        try collection.database.inBatch {
                            // Convert the document to a mutable form
                            let mutableDoc = document.toMutable()
                            // Update the document with new properties
                            mutableDoc.setString(updatedProfile.name, forKey: "name")
                            mutableDoc.setString(updatedProfile.email, forKey: "email")

                            
                            // Save the updated document
                            try collection.save(document:mutableDoc )
                            print("Document updated successfully!")
                        }
                    } else {
                        print("Document with ID \(id) not found.")
                    }
                } catch {
                    print("Error updating document: \(error)")
                }
        
        
    }
    


    
    // Delete a UserProfile by ID
    func deleteUserProfile(withID id: String, completion: @escaping (Bool) -> Void) {
        do {
            if let document = try collection.document(id: id) {
                try collection.delete(document: document)
                completion(false)
            } else {
                completion(true)
            }
        } catch {
            completion(true)
        }
    }
}
