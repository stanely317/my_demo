//
//  myCollectionViewCell.swift
//  my_demo
//
//  Created by Class on 2022/4/11.
//

import UIKit

class myCollectionViewCell: UICollectionViewCell {

    static let identifier = "myCollectionViewCell"
    
    @IBOutlet weak var LiveImageView: UIImageView!
    @IBOutlet weak var online_num: UILabel!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var tag1: UILabel!
    @IBOutlet weak var tag2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
