//
//  DataSyncManager.swift
//  BlogDemo
//
//  Created by Febin Puthalath on 17/09/24.
//

import Foundation
import CouchbaseLiteSwift

class DataSyncManager {

    static let shared = DataSyncManager()

    func startReplication(collection: Collection) {
//        // Ensure you have created and configured a local database first
//        let database: Database = DatabaseManager.shared.getDatabase()
//        // Your Couchbase Lite database instance
//
//        // Create the remote endpoint for the cloud (your ngrok URL)
//        let targetEndpoint = URLEndpoint(url: URL(string: "wss://3fb8-123-252-135-114.ngrok-free.app/todo/_sync")!)
//
//        // Set replication configuration
//        var config = ReplicatorConfiguration(database: database, target: targetEndpoint)
//        
//        // Optionally set authentication if your server requires it
//        config.authenticator = BasicAuthenticator(username: "admin", password: "password")
//        
//        // Set the replication type (push and pull)
//        config.replicatorType = .pushAndPull
//
//        
//        // Create a replicator with the configuration
//        let replicator = Replicator(config: config)
//        
//        // Add change listener to monitor replication progress
//        replicator.addChangeListener { change in
//            if let error = change.status.error as NSError? {
//                print("Error replicating: \(error)")
//            } else {
//                print("Replication progress: \(change.status.progress.completed)/\(change.status.progress.total)")
//            }
//        }
//        
//        // Start the replication
//        replicator.start()
        
        
//        guard let targetURL = URL(string: "wss://3fb8-123-252-135-114.ngrok-free.app/todo/_sync") else {
//            fatalError("Invalid URL")
//        }
//        let targetEndpoint = URLEndpoint(url: targetURL)
//        var config = ReplicatorConfiguration(target: targetEndpoint)
//        config.addCollection(collection)
//
//        config.replicatorType = .pushAndPull
//
//        // set auto-purge behavior (here we override default)
//        config.enableAutoPurge = false
//
//        // Configure Sync Mode
//        config.continuous = true
//
//        // Configure Server Security -- only accept self-signed certs
//
//        // Configure Client Security
//        //  Set Authentication Mode
//        config.authenticator = BasicAuthenticator(username: "admin",
//                                                  password: "password")
//
//        /* Optionally set custom conflict resolver call back
//         config.conflictResolver = LocalWinConflictResolver()
//         */
//
//        // Apply configuration settings to the replicator
//        let replicator = Replicator.init( config: config)
//
//        // Optionally add a change listener
//        // Retain token for use in deletion
//        let token = replicator.addChangeListener { change in
//            if change.status.activity == .stopped {
//                print("Replication stopped")
//            } else {
//                print("Replicator is currently : \(replicator.status.activity)")
//            }
//        }
//
//        // Run the replicator using the config settings
//        replicator.start()
//        let database: Database = DatabaseManager.shared.getDatabase()
//        let targetEndpoint = URLEndpoint(url: URL(string: "wss://3fb8-123-252-135-114.ngrok-free.app/todo")!)
//        let authenticator = BasicAuthenticator(username: "admin", password: "password")
//        var replicatorConfig = ReplicatorConfiguration(database: database, target: targetEndpoint)
//        replicatorConfig.authenticator = authenticator
//        replicatorConfig.continuous = true
//        let replicator = Replicator(config: replicatorConfig)
//        replicator.start()
        
//        guard let databasePath = DatabaseManager.shared.getDatabasePath() else{
//            fatalError("Invalid db path")
//        }
//        print(databasePath)
//        let newPath = databasePath.replacingOccurrences(of: "/todo.cblite2/", with: "")
//
//        
//        guard let url = URL(string: "https://3fb8-123-252-135-114.ngrok-free.app/_replicate") else {
//            fatalError("Invalid URL")
//        }
//        // Create a URLRequest
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("Basic " + "admin:password".data(using: .utf8)!.base64EncodedString(), forHTTPHeaderField: "Authorization")
//        
////        let sourceLink = String(String(format: "http://admin:password@%@todo", databasePath))
//        let sourceLink = String(format: "file://%@/todo.cblite2/", newPath)
//        print(sourceLink)
//        // Create a JSON body
//        let body: [String: Any] = [
//            "source": sourceLink,
//            "target": "https://admin:password@3fb8-123-252-135-114.ngrok-free.app/todo",
//            "continuous": true
//        ]
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
//        } catch {
//            print("Error serializing JSON: \(error)")
//        }
//        // Create a URLSession
//        let session = URLSession.shared
//        // Perform the data task
//        let task = session.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error: \(error)")
//                return
//            }
//            guard let data = data else {
//                print("No data")
//                return
//            }
//            // Parse the response (for example, as JSON)
//            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: [])
//                print("Response JSON: \(json)")
//            } catch {
//                print("JSON parsing error: \(error)")
//            }
//        }
//        // Start the task
//        task.resume()
        guard let databasePath = DatabaseManager.shared.getDatabasePath() else {
            fatalError("Invalid db path")
        }

        print(databasePath)

        // Construct the file URL for the Couchbase Lite database
        let newPath = databasePath.replacingOccurrences(of: "/todo.cblite2/", with: "")
        let sourceLink = String(format: "file://%@/todo.cblite2/", newPath) // This is the local database path

        // CouchDB target URL exposed via ngrok
        guard let url = URL(string: "https://3fb8-123-252-135-114.ngrok-free.app/_replicate") else {
            fatalError("Invalid URL")
        }

        // Create a URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic " + "admin:password".data(using: .utf8)!.base64EncodedString(), forHTTPHeaderField: "Authorization") // Assuming authentication is required

        // Create the JSON body with source and target details
        let body: [String: Any] = [
            "source": sourceLink, // Local Couchbase Lite database path
            "target": "https://admin:password@3fb8-123-252-135-114.ngrok-free.app/todo", // CouchDB target URL with auth
            "continuous": true
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Error serializing JSON: \(error)")
        }

        // Create a URLSession
        let session = URLSession.shared

        // Perform the data task
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let data = data else {
                print("No data")
                return
            }
            // Parse the response
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print("Response JSON: \(json)")
            } catch {
                print("JSON parsing error: \(error)")
            }
        }
        // Start the task
        task.resume()

        
    }
    
}
