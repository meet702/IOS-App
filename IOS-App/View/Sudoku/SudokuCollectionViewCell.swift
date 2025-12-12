//
//  SudokuCollectionViewCell.swift
//  Match the Pairs Test
//
//  Created by SDC-USER on 28/11/25.
//

import UIKit

class SudokuCollectionViewCell: UICollectionViewCell {
    static let reuseId = "SudokuCell"

    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var valueLabel: UILabel!

    // border layers (we keep references so we can update frames on layoutSubviews)
    private var topBorder: CALayer?
    private var leftBorder: CALayer?
    private var bottomBorder: CALayer?
    private var rightBorder: CALayer?

    // styling constants
    private let thinBorderWidth: CGFloat = 0.4
    private let blockBorderWidth: CGFloat = 1.5
    private let borderColor = UIColor.systemGray5.cgColor
    private let blockColor = UIColor.systemGray2.cgColor


    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.clipsToBounds = true
        containerView.backgroundColor = .white

        valueLabel.textAlignment = .center
        valueLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)

        // create all four layers once
        topBorder = CALayer()
        leftBorder = CALayer()
        bottomBorder = CALayer()
        rightBorder = CALayer()

        if let t = topBorder { layer.addSublayer(t) }
        if let l = leftBorder { layer.addSublayer(l) }
        if let b = bottomBorder { layer.addSublayer(b) }
        if let r = rightBorder { layer.addSublayer(r) }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // update border frames according to container bounds
        let bounds = self.bounds
        // We'll set frames in configure(row:col:) where we know required widths; keep default here.
        // Do nothing here — configure will call updateBorders(...) which sets frames and widths.
    }

    func configure(value: Int?, isGiven: Bool, isSelected: Bool, isConflict: Bool, row: Int, col: Int, totalRows: Int = 9, totalCols: Int = 9) {
        // text & color
        if let v = value {
            valueLabel.text = "\(v)"
            valueLabel.textColor = isGiven ? UIColor.systemOrange : UIColor.label
        } else {
            valueLabel.text = ""
        }

        // selection / conflict styling
        if isConflict {
            containerView.backgroundColor = UIColor.systemRed.withAlphaComponent(0.06)
            valueLabel.textColor = .systemRed
        } else {
            containerView.backgroundColor = isSelected ? UIColor.systemGray5 : UIColor.white
            if !isGiven {
                // default color for user-entered is label
                valueLabel.textColor = .label
            }
        }

        // Now update the borders. We'll draw top & left for every cell, and for the last
        // row/col we also draw bottom & right to close the grid edges.
        updateBorders(row: row, col: col, totalRows: totalRows, totalCols: totalCols)
    }

    private func updateBorders(row: Int, col: Int, totalRows: Int, totalCols: Int) {
        // border widths
        let topW = (row % 3 == 0) ? blockBorderWidth : thinBorderWidth
        let leftW = (col % 3 == 0) ? blockBorderWidth : thinBorderWidth
        let bottomW = ((row + 1) % 3 == 0) ? blockBorderWidth : thinBorderWidth
        let rightW = ((col + 1) % 3 == 0) ? blockBorderWidth : thinBorderWidth

        // Use cell bounds to position border layers
        let b = self.bounds

        // Top border
        topBorder?.backgroundColor = (topW == blockBorderWidth ? blockColor : borderColor)
        topBorder?.frame = CGRect(x: 0, y: 0, width: b.width, height: topW)

        // Left border
        leftBorder?.backgroundColor = (leftW == blockBorderWidth ? blockColor : borderColor)
        leftBorder?.frame = CGRect(x: 0, y: 0, width: leftW, height: b.height)

        // Bottom border (draw for last row or always - this ensures grid closes)
        bottomBorder?.backgroundColor = (bottomW == blockBorderWidth ? blockColor : borderColor)
        bottomBorder?.frame = CGRect(x: 0, y: b.height - bottomW, width: b.width, height: bottomW)

        // Right border
        rightBorder?.backgroundColor = (rightW == blockBorderWidth ? blockColor : borderColor)
        rightBorder?.frame = CGRect(x: b.width - rightW, y: 0, width: rightW, height: b.height)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // reset label/background
        valueLabel.text = ""
        containerView.backgroundColor = .white
    }
}

