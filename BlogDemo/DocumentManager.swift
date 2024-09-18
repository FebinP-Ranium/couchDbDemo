//
//  DocumentManager.swift
//  BlogDemo
//
//  Created by Febin Puthalath on 17/09/24.
//

import Foundation
import CouchbaseLiteSwift

class DocumentManager {
    
    private var database: Database
    private var collection: Collection

    // Initialize the DocumentManager with a database instance
    init(database: Database) {
        self.database = database
        guard let defaultCollection = try? database.defaultCollection() else {
                    fatalError("Failed to get the default collection.")
                }
                self.collection = defaultCollection
    }
    
    // Create a new document
    func createDocument(version: Float, type: String) -> String {
          let mutableDoc = MutableDocument()
              .setFloat(version, forKey: "version")
              .setString(type, forKey: "type")
          
          do {
              try collection.save(document: mutableDoc)
              print("Created document with ID \(mutableDoc.id) and type \(mutableDoc.string(forKey: "type")!)")
          } catch {
              fatalError("Error saving document: \(error.localizedDescription)")
          }
          return mutableDoc.id
      }

    // Read an existing document
    
        func readDocument(withID id: String) {
            if let document = try? collection.document(id: id) {
                print("Read document with ID \(document.id), type = \(document.string(forKey: "type") ?? "N/A")")
            } else {
                print("Document with ID \(id) not found.")
            }
        }
    

    // Update an existing document
    func updateDocument(withID id: String, language: String) {
        if let mutableDoc = try? collection.document(id: id)?.toMutable() {
            mutableDoc.setString(language, forKey: "language")
            do {
                try collection.save(document: mutableDoc)
                if let updatedDoc = try? collection.document(id: mutableDoc.id) {
                    print("Updated document ID \(updatedDoc.id), language = \(updatedDoc.string(forKey: "language")!)")
                }
            } catch {
                fatalError("Error updating document: \(error.localizedDescription)")
            }
        } else {
            print("Document with ID \(id) not found for updating.")
        }
    }

    // Delete a document
    func deleteDocument(withID id: String) {
        if let document = try? collection.document(id: id) {
            do {
                try collection.delete(document: document)
                print("Deleted document with ID \(document.id)")
            } catch {
                fatalError("Error deleting document: \(error.localizedDescription)")
            }
        } else {
            print("Document with ID \(id) not found for deletion.")
        }
    }

    // Query documents of a specific type
    func queryDocuments(ofType type: String) {
        print("Querying documents of type = \(type)")

        // Ensure the collection is used instead of the entire database
        let query = QueryBuilder
            .select(SelectResult.all())
            .from(DataSource.collection(collection))  // Update here to use collection
            .where(Expression.property("type").equalTo(Expression.string(type)))

        do {
            let result = try query.execute()
            print("Number of rows: \(result.allResults().count)")
        } catch {
            fatalError("Error running query: \(error.localizedDescription)")
        }
    }
    
    // Create a new document
    // Create or Update a UserProfile
    func saveToDo(_ toDo: ToDo,completion: @escaping (Collection,String?,Bool) -> ()) {
        do {
            let mutableDoc = toDo.toMutableDocument()
            print(mutableDoc.id)
            
            
            try collection.save(document: mutableDoc)
            if let savedDoc = try collection.document(id: mutableDoc.id) {
                        let revId = savedDoc.revisionID
                print(revId ?? "default value")
                    } else {
                        print("nil")
                    }
            completion(collection,mutableDoc.id,false)
        } catch {
            completion(collection,nil,true)
        }
    }
    func readfromToDo(withID id: String, completion: @escaping (ToDo?,Bool) -> Void) {
        do {
            if let document = try collection.document(id: id) {
                if let profile = ToDo.from(document: document) {
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
    
    func listAllTodo(completion: @escaping ([ToDo]?, Bool) -> Void) {
        let query = QueryBuilder
            .select(SelectResult.expression(Meta.id), // Select the document ID explicitly
                    SelectResult.property("name")
                    )
            .from(DataSource.collection(collection))

        do {
            let results = try query.execute()
            var profiles: [ToDo] = []

            for row in results {
                // Fetch the document ID using Meta.id
                print(row)
                if let documentId = row.string(forKey: "id"),
                   let name = row.string(forKey: "name")
                   {
                    if let savedDoc = try collection.document(id:documentId) {
                                let revId = savedDoc.revisionID
                        print("\(documentId): \(name),\(revId ?? "")")
                       
                            } else {
                                print("nil")
                            }
                   
                    
                    // Create a UserProfile object
                    let profile = ToDo(name: name)
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

}
