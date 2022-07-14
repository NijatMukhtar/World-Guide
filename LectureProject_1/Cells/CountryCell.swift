//
//  CountryCell.swift
//  LectureProject_1
//
//  Created by Nijat Mukhtarov on 30.06.22.
//

import UIKit

class CountryCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    
    var buttonCallback: ((Int) -> ())?
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        buttonCallback?(tag)
    }
    
}
