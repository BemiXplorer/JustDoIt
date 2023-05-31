//
//  ViewController.swift
//  JustDoIt
//
//  Created by apple on 29/05/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var getStartedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getStartedButton.layer.cornerRadius = getStartedButton.frame.height / 2
        getStartedButton.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }

    @IBAction func goToTasklist(_ sender: Any) {
        if let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tasklistView") as? TaskListViewController{
                    let nav = self.navigationController
                    //push
                    nav?.pushViewController(destinationVC, animated: true)
                }
    }
    
    
}

