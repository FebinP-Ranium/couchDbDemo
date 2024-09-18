//
//  CouchBaseManager.swift
//  BlogDemo
//
//  Created by Febin Puthalath on 17/09/24.
//

import Foundation
import CouchbaseLiteSwift

class DatabaseManager {
    static let shared = DatabaseManager() // Singleton instance

    private var database: Database?

    // Private initializer to prevent external instantiation
    private init() {}


    // Setup the database
    func setupDatabase(named dbName: String = "todo") {
        do {
            database = try Database(name: dbName)
            print("Database '\(dbName)' initialized successfully.")
        } catch {
            fatalError("Error opening database: \(error.localizedDescription)")
        }
    }

    // Get the current database instance
    func getDatabase() -> Database {
        guard let db = database else {
            fatalError("Database not initialized. Call setupDatabase() first.")
        }
        return db
    }

    // Close the database (optional)
    func closeDatabase() {
        do {
            try database?.close()
            print("Database closed successfully.")
        } catch {
            print("Error closing database: \(error.localizedDescription)")
        }
    }
    func getDatabasePath() -> String? {
        guard let db = database else {
            print("Database not initialized. Call setupDatabase() first.")
            return nil
        }

        // Get the database configuration (which contains the file path)
        let dbPath = db.path
        return dbPath
    }
}
