//
//  TaskListTableViewCell.swift
//  JustDoIt
//
//  Created by apple on 30/05/23.
//

import UIKit
protocol  TaskListTableViewCellDelegate : AnyObject{
    func didTapOnDeleteTask(_ addedTask: TasklistCellModel)
    func didTapOnTaskStatusImage(_ addedTask: TasklistCellModel,_ switchImage: String, indexVal: Int)
}
class TaskListTableViewCell: UITableViewCell {

    @IBOutlet weak var taskStatusCheckBox: UIButton!
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var taskTimeLabel: UILabel!
    @IBOutlet weak var deleteTakButton: UIButton!
    @IBOutlet weak var taskPendingLabel: UILabel!
    weak var delegate: TaskListTableViewCellDelegate? = nil
    var row : Int = -1
    var taskListCellModel : TasklistCellModel!{
        didSet{
            self.taskTitleLabel.text = taskListCellModel.taskTitle
            self.taskTimeLabel.text = taskListCellModel.taskstipulatedTime
            self.taskPendingLabel.isHidden = taskListCellModel.taskStatus
            self.taskStatusCheckBox.setImage(UIImage(named: taskListCellModel.taskStatusImage), for: .normal)
            self.taskTitleLabel.textColor = taskListCellModel.taskStatus == true ? .black : UIColor(named: "pendingTaskTitleColor")
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.deleteTakButton.setImage(UIImage(named: "cancelicon"), for: .normal)
        self.taskStatusCheckBox.setImage(UIImage(named: "uncheckedbox"), for: .normal)
        self.taskPendingLabel.textColor = UIColor(named: "pendingTextColor")
        // Initialization code
    }
    
    
    @IBAction func tapOnDeleteTask(_ sender: UIButton) {
        delegate?.didTapOnDeleteTask(taskListCellModel)
    }
    @IBAction func tapOnTaskCheckBox(_ sender: UIButton) {
        if taskStatusCheckBox.imageView?.image == UIImage(named: "uncheckedbox"){
            delegate?.didTapOnTaskStatusImage(taskListCellModel,"checkedbox", indexVal: row)
        }else{
            delegate?.didTapOnTaskStatusImage(taskListCellModel,"uncheckedbox", indexVal: row)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
