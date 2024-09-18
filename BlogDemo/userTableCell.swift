//
//  userTableCell.swift
//  BlogDemo
//
//  Created by Febin Puthalath on 17/09/24.
//

import UIKit

class userTableCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setUserDetails(name:String,email:String){
        nameLbl.text = name
        emailLbl.text = email
    }
}
