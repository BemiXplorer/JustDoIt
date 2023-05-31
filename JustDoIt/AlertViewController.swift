//
//  AlertViewController.swift
//  JustDoIt
//
//  Created by apple on 31/05/23.
//

import UIKit
protocol  AlertViewControllerDelegate : AnyObject{
    func didTapOnOk(_ addedTaskTitle: String)
}
class AlertViewController: UIViewController {
    @IBOutlet weak var alertDescriptionLabel: UILabel!
    @IBOutlet weak var baseView: UIView!
    var titledesctet = String()
    var taskToDelete = String()
    weak var delegate: AlertViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseView.layer.cornerRadius = 15.0
        baseView.layer.masksToBounds = true
        self.alertDescriptionLabel.text = titledesctet
        // Do any additional setup after loading the view.
    }
    @IBAction func tapOnCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func tapOnOk(_ sender: UIButton) {
        delegate?.didTapOnOk(taskToDelete)
        self.dismiss(animated: true, completion: nil)
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
