//
//  HeaderView.swift
//  Home-Test
//
//  Created by SDC-USER on 25/11/25.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureHeaderCell(text: String) {
        titleLabel.text = text
    }
}
