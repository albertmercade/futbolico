//
//  StandingsTitleTableViewCell.swift
//  Futbolico
//
//  Created by Albert Mercadé on 12/07/2020.
//  Copyright © 2020 Albert Mercadé. All rights reserved.
//

import UIKit

class StandingsTitleTableViewCell: UITableViewCell {
    @IBOutlet weak var playedGamesLabel: UILabel!
    @IBOutlet weak var goalDifferenceLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
