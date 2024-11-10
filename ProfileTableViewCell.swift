//
//  ProfileTableViewCell.swift
//  vajroTak
//
//  Created by Tirumala on 10/11/24.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileTitleLbl: UILabel!
    
    
    @IBOutlet weak var profileSublB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
