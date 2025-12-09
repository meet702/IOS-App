//
//  TaskTableViewCell.swift
//  TempApp
//
//  Created by SDC-USER on 25/11/25.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    var onCheckTapped: (() -> Void)?
    //var onTimeChanged: ((Date) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //timePicker.addTarget(self, action: #selector(timeChanged(_:)), for: .valueChanged)

        updateCheckButtonUI()
    }
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        updateCheckButtonUI()
        onCheckTapped?()
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    


    func configure(task: TaskModel) {
        titleLabel.text = task.title
        timePicker.date = task.time
        updateCheckState(isChecked: task.isCompleted)
        
        if let description = task.description, !description.isEmpty {
            descriptionLabel.text = description
            descriptionLabel.isHidden = false
        } else {
            descriptionLabel.isHidden = true
        }
        
        if task.isCompleted {
            titleLabel.textColor = UIColor.lightGray
            descriptionLabel.textColor = UIColor.lightGray
        } else {
            titleLabel.textColor = UIColor.black
            descriptionLabel.textColor = UIColor.systemGray
        }

    }

    func updateCheckState(isChecked: Bool) {
        checkButton.isSelected = isChecked
        updateCheckButtonUI()
    }

    func updateCheckButtonUI() {
        if checkButton.isSelected {
            checkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            checkButton.tintColor = .systemOrange
        } else {
            checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
            checkButton.tintColor = .lightGray
        }
    }

}
