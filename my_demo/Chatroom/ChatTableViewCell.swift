//
//  ChatTableViewCell.swift
//  my_demo
//
//  Created by Class on 2022/4/14.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var ChatContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
