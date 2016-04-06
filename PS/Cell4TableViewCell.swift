//
//  Cell4TableViewCell.swift
//  PS
//
//  Created by Radu Tothazan on 05/04/16.
//  Copyright © 2016 radutot. All rights reserved.
//

import UIKit

class Cell4TableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hourStartLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var presentatorLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
