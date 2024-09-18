//
//  AddUserDetail.swift
//  BlogDemo
//
//  Created by Febin Puthalath on 17/09/24.
//

import UIKit

class AddUserDetail: UIViewController {

    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    var documentManager: DocumentManager!
    var userProfileManager: UserProfileManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Get the database instance from the manager
//                let database = DatabaseManager.shared.getDatabase()
//
//                // Initialize DocumentManager with the database instance
//                documentManager = DocumentManager(database: database)
//                
//                // Perform CRUD operations using DocumentManager
//                let docID = documentManager.createDocument(version: 2.0, type: "SDK")
//                documentManager.readDocument(withID: docID)
//                documentManager.updateDocument(withID: docID, language: "Swift")
//                documentManager.deleteDocument(withID: docID)
//                documentManager.queryDocuments(ofType: "SDK")
        // Do any additional setup after loading the view.
        
        DatabaseManager.shared.setupDatabase()
        let database = DatabaseManager.shared.getDatabase()

        // Get the database instance from the manager

        // Initialize DocumentManager with the database instance
        userProfileManager = UserProfileManager(database:database)
        
        
    }
    
    @IBAction func backButtonOnClk(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func saveBtnOnClk(_ sender: Any) {
       
        let userProfile = UserProfile(name: nameTF.text ?? "", email: emailTF.text ?? "")
        userProfileManager.saveUserProfile(userProfile) { id,error in
            if error{
                print("document creation failed")
            }
            else{
                print("document creation successful")
                if let id = id{
                    self.readDoc(id:id)
                }
            }
            
        }
    }
    func readDoc(id:String){
      

//        userProfileManager.readUserProfiles(byName: nameTF.text ?? "") { profiles,result in
//            if (result){
//                print("not able to read")
//            }else{
//                if let profiles = profiles{
//                    print("Found \(profiles.count) profiles")
//                    for profile in profiles {
//                        print("Profile: \(profile.name), \(profile.email)")
//                    }
//                }
//            }
//        }
        userProfileManager.readUserProfile(withID: id) { profiles,result in
            if (result){
                print("not able to read")
            }else{
                if let profiles = profiles{
                    
                   
                    print("Profile: \(profiles.name), \(profiles.email),\(profiles.id ?? "")")
                    
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
