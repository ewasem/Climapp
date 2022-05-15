//
//  HourViewCell.swift
//  Climapp
//
//  Created by Eduardo Wasem on 13/05/22.
//

import UIKit

class HourViewCell: UITableViewCell {

    
    @IBOutlet weak var imageWeather: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
