//
//  MainViewController.swift
//  SimpleAlert
//
//  Created by takuma ozawa on 2021/10/25.
//

import Foundation
import UIKit
import SCAlertController
import Pods_SCAlertController_Example
 
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
            print(textField.text!)
        }))
        alert.addDivider()
        alert.addCheckBox(title: "check box 1")
        alert.addCheckBox(title: "check box 2")
        alert.addCheckBox(title: "check box 3")
        alert.addCheckBox(title: "check box 4")
        alert.addDivider()
        alert.addAction(action: SCAlertAction(title: "check checkboxes", type: .normal, action: {
            for (i, box) in alert.checkBoxes.enumerated() {
                print("box\(i): \(box.isChecked)")
            }
        }))
        
        alert.addAction(action: SCAlertAction(title: "cancel", type: .cancel, action: {
            let errorAlert = ErrorSCAlert(errorMessage: nil)
            errorAlert.appearance.cancelActionColor = .red
            errorAlert.appearance.normalActionColor = .purple
            errorAlert.closeOnTapBackground = false
            errorAlert.addImageContent(UIImage(named: "apitherapy"), 100)
            errorAlert.appearance.windowColor = .yellow
            errorAlert.onDismiss = { print("dismiss error alert") }
            self.present(errorAlert, animated: true, completion: nil)
        }))

        alert.onDismiss = { print("dismiss alert") }
        self.present(alert, animated: true)
        
    }
}
