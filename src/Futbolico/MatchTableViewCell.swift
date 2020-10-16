//
//  MatchTableViewCell.swift
//  Futbolico
//
//  Created by Albert Mercadé on 04/07/2020.
//  Copyright © 2020 Albert Mercadé. All rights reserved.
//

import UIKit

class MatchTableViewCell: UITableViewCell {
    @IBOutlet weak var crestImage1: UIImageView!
    @IBOutlet weak var teamNameLabel1: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var teamNameLabel2: UILabel!
    @IBOutlet weak var crestImage2: UIImageView!
    @IBOutlet weak var liveGifImage: UIImageView!
    @IBOutlet weak var scoreStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        liveGifImage.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
