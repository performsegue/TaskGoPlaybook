//
//  TournamentTableViewCell.swift
//  TaskGoPlayBook
//
//  Created by Bharath  Raj kumar on 22/02/19.
//  Copyright © 2019 Bharath Raj Kumar. All rights reserved.
//

import UIKit

class TournamentTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var sportTypelabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
