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
        alert.appearance.normalActionColor = .blue
        alert.addTextField(textField: textField)
        alert.addAction(action: SCAlertAction(title: "textfield value", type: .normal, action: {
            guard let fieldText = textField.text else { return }
            print(fieldText)
        }))
        alert.addAction(action: SCAlertAction(title: "cancel", type: .cancel, action: {
            print("pushed actioin2!")

            let errorAlert = ErrorSCAlert(errorMessage: nil)
            errorAlert.appearance.cancelActionColor = .red
            errorAlert.appearance.normalActionColor = .purple
            errorAlert.closeOnTapBackground = false
            errorAlert.addImageContent(UIImage(named: "apitherapy"), 100)
            errorAlert.appearance.windowColor = .yellow
            self.present(errorAlert, animated: true, completion: {

            })
        }))

        self.present(alert, animated: true)
    }
}
