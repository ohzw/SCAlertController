//
//  MainViewController.swift
//  SimpleAlert
//
//  Created by takuma ozawa on 2021/10/25.
//

import Foundation
import UIKit
import SCAlertController
 
class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func showAlert(_ sender: Any) {
        
        let alert = SCAlertController(title: "Alert Title", message: "text text text text \n text text text")
        alert.addImageContent(UIImage(named: "apitherapy"), 100)
        let textField = UITextField()
        textField.placeholder = "placeholder"
        alert.addTextField(textField: textField)
        alert.addAction(action: SCAlertAction(title: "textfield value", type: .normal, action: {
            guard let fieldText = textField.text else { return }
            print(fieldText)
        }))
        alert.addAction(action: SCAlertAction(title: "cancel", type: .cancel, action: {
            print("pushed actioin2!")
            let alert = SCAlertController(errorMessage: nil)
            alert.closeOnTapBackground = false
            alert.addImageContent(UIImage(named: "apitherapy"), 100)
            self.present(alert, animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true)
    }
}
