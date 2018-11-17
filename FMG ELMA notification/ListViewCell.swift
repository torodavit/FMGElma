//
//  ListViewCell.swift
//  ELMA notification
//
//  Created by Tornike Davitashvili on 11/16/18.
//  Copyright © 2018 Tornike Davitashvili. All rights reserved.
//

import UIKit

class ListViewCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var todoRange: UILabel!
    @IBOutlet weak var seenDate: UILabel!
    @IBOutlet weak var rangeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
