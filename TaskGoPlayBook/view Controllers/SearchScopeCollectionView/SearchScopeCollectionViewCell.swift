//
//  SearchScopeCollectionViewCell.swift
//  TaskGoPlayBook
//
//  Created by Bharath  Raj kumar on 21/02/19.
//  Copyright © 2019 Bharath Raj Kumar. All rights reserved.
//

import UIKit

class SearchScopeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backgoundSelectionView: UIView!
    @IBOutlet weak var scopeNameLabel: UILabel!
    @IBOutlet weak var scopeNameButton: UIButton!
    
   override var isSelected: Bool {
        didSet {
            self.backgoundSelectionView.backgroundColor = isSelected ? UIColor(red:0.29, green:0.53, blue:0.21, alpha:1.0) : UIColor(red:0.81, green:0.86, blue:0.89, alpha:1.0)
            self.scopeNameLabel.textColor = isSelected ? UIColor.white : UIColor.black
           
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func scopeSelected()
    {
        
        
    }

}
