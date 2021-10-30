//
//  ErrorSCAlert.swift
//  Pods-SCAlertController_Example
//
//  Created by takuma ozawa on 2021/10/29.
//

import Foundation

open class ErrorSCAlert: SCAlertController {
    var errorMessage: String?
    
    public convenience init(errorMessage: String?) {
        self.init()
        self.errorMessage = errorMessage
        
        setupAlert()
        
        titleLabel.text = String.localized(ja: "エラー", en: "Error")
        
        if let message = errorMessage {
            messageTextView.text = message
        } else {
            messageTextView.text = ""
            messageTextView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        }
        
    }
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addAction(action: SCAlertAction(title: "OK", type: .cancel, action: {}))
    }
    
    override open func setView() {
        guard let superClass: AnyObject = self.superclass else {
            fatalError("no superclass")
        }
        
        let bundle = Bundle(for: superClass.classForCoder)
        
        guard let resourceBundleURL = bundle.url(forResource: "SCAlert", withExtension: "bundle") else {
            fatalError("bundle not found")
        }
        guard let resourceBundle = Bundle(url: resourceBundleURL) else {
            fatalError("Cannot access bundle")
        }
        guard let alertNib = resourceBundle.loadNibNamed("SCAlert", owner: self, options: nil)?.first else  {
            fatalError("Nib not found")
        }
        guard let alertView = alertNib as? UIView else {
            fatalError("Could not load view")
        }
        
        self.view = alertView
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    }
}
