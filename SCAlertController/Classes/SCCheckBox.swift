//
//  SCCheckBox.swift
//  SCAlertController
//
//  Created by takuma ozawa on 2021/11/01.
//

public class SCCheckBox: UIButton {
    public override var tintColor: UIColor? {
        didSet { setupUI() }
    }
    
    public var isChecked = false {
        didSet {
            if isChecked {
                setImage(checkedBoxImage, for: .normal)
            } else {
                setImage(boxImage, for: .normal)
            }
        }
    }
    
    lazy var boxImage: UIImage = {
        let path = Bundle(for: self.classForCoder).resourcePath! + "/SCIcons.bundle"
        let bundle = Bundle(path: path)
        let img = UIImage(named: "square-outline", in: bundle, compatibleWith: nil)!
        return img
    }()
    lazy var checkedBoxImage:UIImage = {
        let path = Bundle(for: self.classForCoder).resourcePath! + "/SCIcons.bundle"
        let bundle = Bundle(path: path)
        let img = UIImage(named: "checkmark-square-outline", in: bundle, compatibleWith: nil)!
        return img
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        imageView?.contentMode = .scaleAspectFill
        contentHorizontalAlignment = .fill
        contentVerticalAlignment = .fill
        layer.backgroundColor = UIColor.clear.cgColor
        addTarget(self, action: #selector(toggleCheck), for: .touchUpInside)
        isChecked = false
    }
    
    @objc private func toggleCheck() {
        isChecked = !isChecked
    }
}
