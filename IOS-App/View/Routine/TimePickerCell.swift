//
//  TimePickerCell.swift
//  TempApp
//
//  Created by SDC-USER on 05/12/25.
//

import UIKit

class TimePickerCell: UITableViewCell {
    
    @IBOutlet weak var timePicker: UIDatePicker!
    var onTimeChanged: ((Date) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        timePicker.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }

    func configure(time: Date) {
        timePicker.date = time
    }

    @objc func valueChanged(_ sender: UIDatePicker) {
        onTimeChanged?(sender.date)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
