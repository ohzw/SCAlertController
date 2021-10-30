//
//  SimpleAlertViewController.swift
//  SimpleAlert
//
//  Created by takuma ozawa on 2021/10/25.
//

import Foundation
import UIKit

public struct SCAlertAppearance {
    public var windowColor: UIColor?
    public var backgroundDim: CGFloat?
    public var normalActionColor: UIColor?
    public var cancelActionColor: UIColor?
    
    public init(
        windowColor: UIColor = .white,
        backgroundDim: CGFloat = 0.2,
        normalActionColor: UIColor = .systemBlue,
        cancelActionColor: UIColor = .systemRed
    ) {
        self.windowColor = windowColor
        self.backgroundDim = backgroundDim
        self.normalActionColor = normalActionColor
        self.cancelActionColor = cancelActionColor
    }
}

public var SCAlertGlobalAppearance = SCAlertAppearance()

open class SCAlertController: UIViewController {
    public var appearance: SCAlertAppearance = SCAlertGlobalAppearance
    public var closeOnTapBackground = true
    private(set) public var textFields: [UITextField] = []
    
    @IBOutlet public weak var backgroundView: UIView!
    @IBOutlet public weak var windowView: UIView!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var messageTextView: UITextView!
    @IBOutlet public weak var contentStackView: UIStackView!
    @IBOutlet public weak var actionStackView: UIStackView!
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppearance()
    }
    
    open func setupAlert() {
        setView()
        setupAppearance()
        addGestures()
    }
    
    public convenience init(title: String?, message: String?) {
        self.init()
        setupAlert()
        
        setTitle(title: title)
        setMessage(message: message)
    }
    
    public func setTitle(title: String?) {
        if let title = title {
            titleLabel.text = title
        } else {
            titleLabel.isHidden = true
        }
    }
    public func setMessage(message: String?) {
        if let message = message {
            messageTextView.text = message
        } else {
            messageTextView.text = ""
            messageTextView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        }
    }
    
    private func setView() {
        let bundle: Bundle
        if type(of: self) == SCAlertController.self {
            bundle = Bundle(for: self.classForCoder)
        } else { // subclass
            guard let superClass: AnyObject = self.superclass else { fatalError("no superclass") }
            bundle = Bundle(for: superClass.classForCoder)
        }
        
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
    
    public func setupAppearance() {
        backgroundView.backgroundColor = .black.withAlphaComponent(appearance.backgroundDim ?? 0.2)
        windowView.backgroundColor = appearance.windowColor
        windowView.clipsToBounds = false
        windowView.layer.cornerRadius = 6
        windowView.layer.shadowOpacity = 0.1
        windowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        windowView.layer.shadowRadius = CGFloat(50)
        windowView.layer.shadowColor = UIColor.black.cgColor
        windowView.layer.shouldRasterize = true
        windowView.layer.rasterizationScale = UIScreen.main.scale
        
        titleLabel.textColor = textColor(bgColor: windowView.backgroundColor ?? .white)
        messageTextView.textColor = textColor(bgColor: windowView.backgroundColor ?? .white)
    }
    
    public func addGestures() {
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
            action.backgroundColor = appearance.normalActionColor
        case .cancel:
            action.backgroundColor = appearance.cancelActionColor
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
    public static func localized(ja: String, en: String) -> String {
        let lang = NSLocale.preferredLanguages[0].prefix(2)
        return lang == "ja" ? ja : en
    }
}
