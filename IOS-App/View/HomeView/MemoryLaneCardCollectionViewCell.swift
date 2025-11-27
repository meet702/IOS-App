//
//  MemoryLaneCardCollectionViewCell.swift
//  Home-Test
//
//  Created by SDC-USER on 25/11/25.
//

import UIKit

class MemoryLaneCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardTextLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var viewLabel: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureMemoryLaneCell() {
        cardTextLabel.text = "Let’s take a walk down memory lane!"
        cardTextLabel.textAlignment = .center
//        imageView.image = UIImage(named: memoryLane.image)

//        imageView.layer.cornerRadius = 20
//        imageView.layer.masksToBounds = true
        
        viewLabel.layer.cornerRadius = 34
        viewLabel.clipsToBounds = true
        viewLabel.layer.shadowColor = UIColor.gray.cgColor
        viewLabel.layer.shadowOpacity = 0.2
        viewLabel.layer.shadowOffset = CGSize(width: 0, height: 4)
        viewLabel.layer.shadowRadius = 2
        viewLabel.layer.masksToBounds = false
    }

}
