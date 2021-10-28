//
//  SEAlertAction.swift
//  SimpleAlert
//
//  Created by takuma ozawa on 2021/10/26.
//

import Foundation
import UIKit

public enum SCAlertType {
    case normal
    case cancel
}

open class SCAlertAction: UIButton {
    private var action: (() -> Void)?
    private var buttonHeight: CGFloat = 34
    
    var type: SCAlertType
    
    public convenience init(title: String, type: SCAlertType, action: (() -> Void)? = nil) {
        self.init()
        
        self.type = type
        self.action = action
        
        self.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        self.layer.cornerRadius = 6
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.setTitle(title, for: .normal)
        
        self.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    @objc private func tapped() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.action?()
        }
    }
    
    init() {
        self.type = .normal
        super.init(frame: CGRect.zero)
    }
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
