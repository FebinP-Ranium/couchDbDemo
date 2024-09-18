//
//  UpdateUserVC.swift
//  BlogDemo
//
//  Created by Febin Puthalath on 17/09/24.
//

import UIKit

class UpdateUserVC: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    var userProfileManager: UserProfileManager!
    var userDetail : UserProfile!

    override func viewDidLoad() {
        super.viewDidLoad()
        DatabaseManager.shared.setupDatabase()
        let database = DatabaseManager.shared.getDatabase()
        userProfileManager = UserProfileManager(database:database)
        nameTF.text = userDetail.name
        emailTF.text = userDetail.email

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonOnClk(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func deleteBtnOnClk(_ sender: Any) {
        if let id = userDetail.id{
            userProfileManager.deleteUserProfile(withID: id) { result in
                switch result {
                case false:
                    print("Successfully deleted user profile.")
                case true:
                    print("Error deleting user profile.)")
                }
            }
        }
    }
    
    @IBAction func updateBtnOnClk(_ sender: Any) {
        let updatedProfile = UserProfile(name: nameTF.text ?? "", email: emailTF.text ?? "")
        if let id = userDetail.id{
            userProfileManager.updateUserProfile(withID: id, updatedProfile: updatedProfile) { result in
                switch result {
                case false:
                    print("Successfully updated user profile.")
                    self.navigationController?.popViewController(animated: true)
                case true:
                    print("Error updating user profile")
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
