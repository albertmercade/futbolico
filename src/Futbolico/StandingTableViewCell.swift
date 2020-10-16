//
//  StandingTableViewCell.swift
//  Futbolico
//
//  Created by Albert Mercadé on 03/07/2020.
//  Copyright © 2020 Albert Mercadé. All rights reserved.
//

import UIKit

class StandingTableViewCell: UITableViewCell {
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var crestImage: UIImageView!
    @IBOutlet weak var playedGamesLabel: UILabel!
    @IBOutlet weak var goalDiffLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
