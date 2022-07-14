//
//  PlaceCell.swift
//  LectureProject_1
//
//  Created by Nijat Mukhtarov on 28.06.22.
//

import UIKit

class PlaceCell: UITableViewCell {

   
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
