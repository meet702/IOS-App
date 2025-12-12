//
//  HeaderViewCaregiver.swift
//  Match the Pairs Test
//
//  Created by SDC-USER on 05/12/25.
//

import UIKit

class HeaderViewCaregiver: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureHeaderCell(text: String) {
        titleLabel.text = text
    }
}
