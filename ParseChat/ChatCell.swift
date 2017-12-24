//
//  ChatCell.swift
//  ParseChat
//
//  Created by Zhaoya Sun on 12/9/17.
//  Copyright © 2017 Zhaoya Sun. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var textMess: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
