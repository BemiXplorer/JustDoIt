//
//  AddTasklistViewController.swift
//  JustDoIt
//
//  Created by apple on 31/05/23.
//

import UIKit
import DropDown

protocol  AddTaskToTaskListDelegate : AnyObject{
    func didTaskAdded(_ addedTask: TasklistCellModel)
}

class AddTasklistViewController: UIViewController {
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var selectedOptionLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var taskTimeTextField: UITextField!
    weak var delegate: AddTaskToTaskListDelegate? = nil
    let dropDown = DropDown()
    override func viewDidLoad() {
        super.viewDidLoad()
         title = "Add Task"
        dropDownView.layer.borderColor = UIColor.black.cgColor
        dropDownView.layer.borderWidth = 0.5
        dropDownView.layer.cornerRadius = 10.0
        dropDownView.layer.masksToBounds = true
        
        cancelButton.layer.borderColor = UIColor(named: "addTaskButtonBGColor")!.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = cancelButton.frame.height / 2
        cancelButton.layer.masksToBounds = true
        
        addButton.layer.cornerRadius = cancelButton.frame.height / 2
        addButton.layer.masksToBounds = true

        // The view to which the drop down will appear on
        dropDown.anchorView = dropDownView // UIView or UIBarButtonItem

        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["AM", "PM"]
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnDrpDown(_:)))
        dropDownView.addGestureRecognizer(tap)
        dropDownView.addGestureRecognizer(tap)
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.selectedOptionLabel.text = item
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func handleTapOnDrpDown(_ sender: UITapGestureRecognizer? = nil) {
        self.dropDown.show()
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        guard let textfieldTitle = taskTitleTextField.text else {return}
        guard let textfieldTime = taskTimeTextField.text else {return}
        let taskTime = "\(textfieldTime) \(self.selectedOptionLabel.text!)"
        delegate?.didTaskAdded(TasklistCellModel(taskStatusImage: "uncheckedbox", taskTitle: textfieldTitle, taskStatus: true, taskstipulatedTime: taskTime))
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
