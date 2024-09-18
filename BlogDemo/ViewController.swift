//
//  ViewController.swift
//  BlogDemo
//
//  Created by Febin Puthalath on 12/09/24.
//

import UIKit
import CouchbaseLiteSwift
class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    var documentManager: DocumentManager!
    var userProfileManager: UserProfileManager!
    var userprofiles = [UserProfile]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize the database using DatabaseManager
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "userTableCell", bundle: .main), forCellReuseIdentifier: "userTableCell")

                DatabaseManager.shared.setupDatabase()
                let database = DatabaseManager.shared.getDatabase()

                // Get the database instance from the manager

                // Initialize DocumentManager with the database instance
//                userProfileManager = UserProfileManager(database:database)
        
        documentManager = DocumentManager(database: database)
//
//                // Perform CRUD operations using DocumentManager
//                let docID = documentManager.createDocument(version: 2.0, type: "SDK")
//                documentManager.readDocument(withID: docID)
//                documentManager.updateDocument(withID: docID, language: "Swift")
//                documentManager.queryDocuments(ofType: "SDK")
//                documentManager.deleteDocument(withID: docID)
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
       // getUsersList()
        saveToDo()
    }
    func saveToDo(){
        let todo = ToDo(name: "test from iOS 7")
        documentManager.saveToDo(todo) { collection,id,error in
            if error{
                print("document creation failed")
            }
            else{
                print("document creation successful")
                print(id ?? "")
                self.readDoc(id: id ?? "")
                DataSyncManager.shared.startReplication(collection: collection)
              
            }
            
        }
        
    }
 
    
    func readDoc(id:String){
        documentManager.listAllTodo{ profiles,error in
            if error{
                print("error in listing document")
            }else{
                if let profiles = profiles{
                    print("Found \(profiles.count) profiles")
                    for profile in profiles {
                        print("Profile: \(profile.name)")
                    }
                  
                   
                }
            }
        }
    }
    func getUsersList(){
       
        userProfileManager.listAllUserProfiles { profiles,error in
            if error{
                print("error in listing document")
            }else{
                if let profiles = profiles{
                    print("Found \(profiles.count) profiles")
                    for profile in profiles {
                        print("Profile: \(profile.name), \(profile.email)")
                    }
                    DispatchQueue.main.async {
                        self.userprofiles.removeAll()
                        self.userprofiles = profiles
                        print(self.userprofiles.count)
                        self.tableView.reloadData()
                    }
                   
                }
            }
        }
    }
    
    @IBAction func addButtonOnClk(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addDoc = storyboard.instantiateViewController(withIdentifier: "AddUserDetail") as! AddUserDetail
        self.navigationController?.pushViewController(addDoc, animated: true)
        
    }
    // MARK: - UITableViewDataSource
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return userprofiles.count// Number of cells
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "userTableCell", for: indexPath) as!userTableCell
            cell.setUserDetails(name: userprofiles[indexPath.row].name, email: userprofiles[indexPath.row].email)
            return cell
        }

        // MARK: - UITableViewDelegate
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let UpdateUserVC = storyboard.instantiateViewController(withIdentifier: "UpdateUserVC") as! UpdateUserVC
            UpdateUserVC.userDetail = userprofiles[indexPath.row]
            self.navigationController?.pushViewController(UpdateUserVC, animated: true)
           
        }
    
}

