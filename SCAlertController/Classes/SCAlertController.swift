//
//  SimpleAlertViewController.swift
//  SimpleAlert
//
//  Created by takuma ozawa on 2021/10/25.
//

import Foundation
import UIKit

public struct SCAlertAppearance {
    let windowColor: UIColor
    let backgroundDim: CGFloat?
    let normalActionColor: UIColor
    let cancelActionColor: UIColor
    
    public init(
        windowColor: UIColor,
        backgroundDim: CGFloat?,
        normalActionColor: UIColor,
        cancelActionColor: UIColor
    ) {
        self.windowColor = windowColor
        self.backgroundDim = backgroundDim
        self.normalActionColor = normalActionColor
        self.cancelActionColor = cancelActionColor
    }
}

public var SCAlertGlobalAppearance = SCAlertAppearance(
    // default appearance
    windowColor: .white,
    backgroundDim: 0.2,
    normalActionColor: .systemBlue,
    cancelActionColor: .systemPink
)

open class SCAlertController: UIViewController {
    
    public var closeOnTapBackground = true
    private(set) public var textFields: [UITextField] = []
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var windowView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var actionStackView: UIStackView!
    
    // Alert - normal
    public convenience init(title: String?, message: String?) {
        self.init()
        
        setView()
        setupAppearance()
        addGestures()
        
        if let title = title {
            titleLabel.text = title
        } else {
            titleLabel.isHidden = true
        }
        
        if let message = message {
            messageTextView.text = message
        } else {
            messageTextView.text = ""
            messageTextView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        }
    }
    
    // Alert - error
    public convenience init(errorMessage: String?) {
        self.init()
        
        setView()
        setupAppearance()
        addGestures()
        
        titleLabel.text = String.localized(ja: "エラー", en: "Error")
        
        if let message = errorMessage {
            messageTextView.text = message
        } else {
            messageTextView.text = ""
            messageTextView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        }
        
        addAction(action: SCAlertAction(title: "OK", type: .cancel, action: {}))
    }
    
    private func setView() {
        let bundle = Bundle(for: self.classForCoder)
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
    
    private func setupAppearance() {
        backgroundView.backgroundColor = .black.withAlphaComponent(SCAlertGlobalAppearance.backgroundDim ?? 0.2)
        windowView.backgroundColor = SCAlertGlobalAppearance.windowColor
        windowView.clipsToBounds = false
        windowView.layer.cornerRadius = 6
        windowView.layer.shadowOpacity = 0.1
        windowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        windowView.layer.shadowRadius = CGFloat(50)
        windowView.layer.shadowColor = UIColor.black.cgColor
        windowView.layer.shouldRasterize = true
        windowView.layer.rasterizationScale = UIScreen.main.scale
        
        titleLabel.textColor = textColor(bgColor: windowView.backgroundColor!)
        messageTextView.textColor = textColor(bgColor: windowView.backgroundColor!)
    }
    
    private func addGestures() {
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapBackground))
        backgroundView.addGestureRecognizer(tapRecognizer)
    }
    
    
    @objc private func dismissAlert() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc private func tapBackground() {
        if closeOnTapBackground {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    public func addImageContent(_ image: UIImage?, _ height: CGFloat?) {
        let imageView = UIImageView(image: image)
        imageView.heightAnchor.constraint(lessThanOrEqualToConstant: height ?? windowView.frame.height).isActive = true
        imageView.contentMode = .scaleAspectFit
        contentStackView.addArrangedSubview(imageView)
    }
    
    public func addAction(action: SCAlertAction) {
        switch action.type {
        case .normal:
            action.backgroundColor = SCAlertGlobalAppearance.normalActionColor
        case .cancel:
            action.backgroundColor = SCAlertGlobalAppearance.cancelActionColor
        }
        
        actionStackView.addArrangedSubview(action)
        action.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
    }
    
    public func addTextField(textField: UITextField) {
        textField.delegate = self
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .done
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textAlignment = .left
        actionStackView.addArrangedSubview(textField)
        textFields.append(textField)
    }
}

extension SCAlertController {
    func textColor(bgColor: UIColor) -> UIColor {
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        
        bgColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        // algorithm from: http://www.w3.org/WAI/ER/WD-AERT/#color-contrast
        brightness = ((r * 299) + (g * 587) + (b * 114)) / 1000;
        if (brightness < 0.5) {
            return .white
        }
        else {
            return .black
        }
    }
}

extension SCAlertController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension String {
    static func localized(ja: String, en: String) -> String {
        let lang = NSLocale.preferredLanguages[0].prefix(2)
        return lang == "ja" ? ja : en
    }
}
