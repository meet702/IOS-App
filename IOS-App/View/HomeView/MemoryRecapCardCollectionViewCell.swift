//
//  MemoryRecapCardCollectionViewCell.swift
//  Home-Test
//
//  Created by SDC-USER on 25/11/25.
//

import UIKit

class MemoryRecapCardCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    
    @IBOutlet weak var viewLabel: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureMemoryRecapCardCell() {
        titleLabel.text = "Memory Recap"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        subTitleLabel.text = "A look back at your beautiful moments"
        subTitleLabel.textAlignment = .center
        subTitleLabel.font = UIFont.systemFont(ofSize: 14)
               
        viewLabel.clipsToBounds = true
        viewLabel.layer.shadowColor = UIColor.orange.cgColor
        viewLabel.layer.shadowOpacity = 0.4
        viewLabel.layer.shadowOffset = CGSize(width: 0, height: 3)
        viewLabel.layer.shadowRadius = 2
        viewLabel.layer.masksToBounds = false
        viewLabel.layer.cornerRadius = 34
    }

}
