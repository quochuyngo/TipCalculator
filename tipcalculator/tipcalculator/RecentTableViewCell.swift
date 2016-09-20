//
//  RecentTableViewCell.swift
//  Tip Calculator
//
//  Created by Quoc Huy Ngo on 9/16/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class RecentTableViewCell: UITableViewCell {

    @IBOutlet weak var billLabel: UILabel!
    @IBOutlet weak var tiplabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
