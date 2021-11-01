//
//  ErrorSCAlert.swift
//  Pods-SCAlertController_Example
//
//  Created by takuma ozawa on 2021/10/29.
//

import SCAlertController

class ErrorSCAlert: SCAlertController {
    
    convenience init(errorMessage: String?) {
        self.init()
        
        setupAlert()
        
        setTitle(title: String.localized(ja: "エラー", en: "Error"))
        setMessage(message: errorMessage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addAction(action: SCAlertAction(title: "OK", type: .cancel, action: {}))
    }
}
