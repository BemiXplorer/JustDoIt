//
//  TaskListViewController.swift
//  JustDoIt
//
//  Created by apple on 29/05/23.
//

import UIKit

class TaskListViewController: UIViewController {
    @IBOutlet weak var taskListtableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var emptyListLabel: UILabel!
    var listItems = [TasklistCellModel]()
    var currentTime = String()
    private var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.taskListtableView.reloadData()
        taskListtableView.layer.borderColor = UIColor(named: "tableViewBorderColor")?.cgColor
        taskListtableView.layer.borderWidth = 1
        taskListtableView.layer.cornerRadius = 10.0
        taskListtableView.layer.masksToBounds = true
        
        addButton.layer.cornerRadius = 15.0
        addButton.layer.masksToBounds = true
        let myUserTasks = DBHelper.shared.getAllUserTasks()
        for (_, userTask) in myUserTasks.enumerated() {
            
            listItems.append(userTask)
            
        }
        if listItems.count == 0{
            self.emptyListLabel.isHidden = false
        }else{
            self.emptyListLabel.isHidden = true
        }
        addButton.setImage(UIImage(named: "addicon"), for: .normal)
        addButton.backgroundColor = UIColor(named: "addbuttonBGColor")!
        title = "Task List"
        self.taskListtableView.register(UINib(nibName: "TasklistTableViewCell", bundle: nil), forCellReuseIdentifier: "tasklistcell")
        self.taskListtableView.delegate = self
        self.taskListtableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.startMonitoring()
        
//        self.smartPlugDashboardTableView.reloadData()
    }
    
    @IBAction func onTapAddButton(_ sender: Any) {
        
        if let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addtasklistView") as? AddTasklistViewController{
                    let nav = self.navigationController
                    destinationVC.delegate = self
                    //push
                    nav?.pushViewController(destinationVC, animated: true)
                }
        
    }
    func startMonitoring() {
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
            self.timerAction(timer: self.timer!)
        }
    }
    
    func stopMonitoring() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc private func timerAction(timer:Timer) {
        print("monitoring handler timer fire")
        let mytime = Date()
        let format = DateFormatter()
        format.timeStyle = .short
        format.dateStyle = .none
        self.currentTime = format.string(from: mytime)
        var currentTimeString = self.currentTime.replacingOccurrences(of: ":", with: "", options: .literal, range: nil)
        currentTimeString = currentTimeString.components(separatedBy: " ")[0]
        guard let currentTimeInt = Int(currentTimeString) else {
            // do something with goalOne
            return
        }

        for(cellindex, userTask) in listItems.enumerated(){
            
            var userTimeString = userTask.taskstipulatedTime.replacingOccurrences(of: ":", with: "", options: .literal, range: nil)
            userTimeString = userTimeString.components(separatedBy: " ")[0]
            guard let taskTimeInt = Int(userTimeString) else {
                return
            }
            
            let indexPath = IndexPath(row: cellindex, section: 0)
             
            if let cell = self.taskListtableView.cellForRow(at: indexPath) as? TaskListTableViewCell {
                if currentTimeInt > taskTimeInt{
                    if cell.taskStatusCheckBox.imageView?.image == UIImage(named: "uncheckedbox"){
                        listItems[indexPath.row].taskStatus = false
                        self.taskListtableView.reloadData()
                    }
                }
                 
            }
            
        }
        
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
extension TaskListViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.taskListtableView.dequeueReusableCell(withIdentifier: "tasklistcell") as! TaskListTableViewCell
        cell.delegate = self
        cell.selectionStyle = .none
        cell.taskListCellModel = listItems[indexPath.row]
        cell.row = indexPath.row
        var imageName = listItems[indexPath.row].taskStatusImage
        cell.taskStatusCheckBox.setImage(UIImage(named: imageName), for: .normal)
            return cell
        
    }
    
    
}
extension TaskListViewController : UITableViewDelegate{
    
}

extension TaskListViewController : AddTaskToTaskListDelegate{
    func didTaskAdded(_ addedTask: TasklistCellModel) {
        self.listItems.append(addedTask)
        DBHelper.shared.insertUserTask(self.listItems)
        if listItems.count == 0{
            self.emptyListLabel.isHidden = false
        }else{
            self.emptyListLabel.isHidden = true
        }
        self.taskListtableView.reloadData()
    }
    
    
}

extension TaskListViewController : TaskListTableViewCellDelegate{
    func didTapOnTaskStatusImage(_ addedTask: TasklistCellModel, _ switchImage: String, indexVal: Int) {
        self.listItems.remove(at: indexVal)
        self.listItems.insert(TasklistCellModel(taskStatusImage: switchImage, taskTitle: addedTask.taskTitle, taskStatus: addedTask.taskStatus, taskstipulatedTime: addedTask.taskstipulatedTime), at: indexVal)
        DBHelper.shared.updateUserTasks(switchImage, tasktitle: addedTask.taskTitle)
//        DBHelper.shared.insertUserTask(self.listItems)
        self.taskListtableView.reloadData()
    }
    
    func didTapOnDeleteTask(_ addedTask: TasklistCellModel) {
        
        showCustomAlert(addedTask.taskTitle)
    }
    
    func showCustomAlert(_ taskTitle: String) {
        if let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "customAlertView") as? AlertViewController{
                    let nav = self.navigationController
//                    destinationVC.delegate = self
//        for (i, userTask) in self.listItems.enumerated(){
//            if userTask.taskTitle == addedTask.taskTitle{
//                self.listItems.remove(at: i)
//                self.taskListtableView.reloadData()
//                }
//            }
            destinationVC.delegate = self
            destinationVC.taskToDelete = taskTitle
            destinationVC.titledesctet = "Do you Want to delete" + " \(taskTitle)"+", this action can't be undone."
            destinationVC.view.backgroundColor = UIColor(white: 0, alpha: 0.7)
            destinationVC.modalTransitionStyle = .crossDissolve
//            destinationVC.delegate = self
            destinationVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            destinationVC.view.layer.zPosition = 1;
            nav?.present(destinationVC, animated: true, completion: nil)
            destinationVC.view.layer.zPosition = 1;
                    //push
//                    nav?.pushViewController(destinationVC, animated: true)
                }
        
    }
    
    
}

extension TaskListViewController : AlertViewControllerDelegate{
    func didTapOnOk(_ addedTaskTitle: String) {
        for (i, userTask) in self.listItems.enumerated(){
            if userTask.taskTitle == addedTaskTitle{
                self.listItems.remove(at: i)
                self.taskListtableView.reloadData()
            }
        }
        DBHelper.shared.deleteUserTask(addedTaskTitle)
    }
    
//    func didTapOnOk(_ addedTask: TasklistCellModel) {
//
//    }
}

