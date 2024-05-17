//
//  LTButtonMenuView.swift
//  LionTravel
//
//  Created by Logan on 2024/5/10.
//

import UIKit

protocol ButtonMenuDelegate: AnyObject {
    func buttonTapped(btnIdx: Int)
}

class LTButtonMenuView: UIView {
    
    var defaultSelectedIndex: Int = 0 {
        didSet {
            selectDefaultButton()
        }
    }
    
    var allowsScrolling: Bool = true {
        didSet { scrollView?.isScrollEnabled = allowsScrolling }
    }
    
    var showButtonShadow: Bool = true {
        didSet { updateButtonShadows() }
    }
    
    var numberOfButtons: Int = 5 {
        didSet {
            setupButtons()
            updateButtonShadows()
            selectDefaultButton()
        }
    }
    
    var buttonTitles: [String] = [] {
        didSet {
            setupButtons()
            updateButtonShadows()
            selectDefaultButton()
        }
    }
    
    weak var delegate: ButtonMenuDelegate?
    
    @IBOutlet var scrollView: UIScrollView!
    
    private var buttonFontSize: CGFloat = 14
    
    private var buttons: [UIButton] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        Initialize()
    }
    
    private func Initialize() {
        print("Initialize")
        // 从 XIB 加载视图
        let bundle = Bundle(for: type(of: self))
        if let views = bundle.loadNibNamed("LTButtonMenuView", owner: self, options: nil),
           let contentView = views.first as? UIView {
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
//        setupScrollView()
        scrollView.isScrollEnabled = allowsScrolling
        setupButtons()
    }
    
    private func setupScrollView() {
        print("setupScrollView")
        scrollView = UIScrollView()
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        scrollView.isScrollEnabled = allowsScrolling
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    private func setupButtons() {
        print("setupButtons")
        // 清除既有按钮
        buttons.forEach { $0.removeFromSuperview() }
        buttons = []
        
        let count = min(numberOfButtons, buttonTitles.count)
        
        for index in 0..<count {
            let btnStr = buttonTitles[index]
            let button = createButton(withTitle: btnStr, fontSize: buttonFontSize)
            button.tag = index
            scrollView.addSubview(button)
            buttons.append(button)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: scrollView.topAnchor),
                button.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            ])
        }
        
        layoutButtons()
    }
    
    /// 创建一个按钮，并根据给定的标题调整宽度
    /// - Parameters:
    ///   - title: 按钮的标题
    ///   - fontSize: 标题的字体大小
    /// - Returns: 配置好的 UIButton
    func createButton(withTitle title: String, fontSize: CGFloat, shadowVisible: Bool = true) -> UIButton {
        let button = UIButton()
        
        button.backgroundColor = .white
        
        // 设置按钮的标题和颜色
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .selected)
        
        // 设置标题字体
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        
        // 設置shadow
        if shadowVisible {
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 2, height: 2)
            button.layer.shadowRadius = 1
            button.layer.shadowOpacity = 0.5
        } else {
            button.layer.shadowOpacity = 0
        }
        
        // 根据标题计算宽度
        let buttonWidth = widthForButtonTitle(title, font: button.titleLabel!.font)
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        // 设置按钮宽度约束
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: buttonWidth)
        ])
        
        return button
    }
    
    func widthForButtonTitle(_ title: String, font: UIFont) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        
        let titleSize = (title as NSString).size(withAttributes: attributes)
        // 添加适当的内边距
        return titleSize.width + 20
    }
    
    func heightForButtonTitle(_ title: String, font: UIFont) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        
        let titleSize = (title as NSString).size(withAttributes: attributes)
        // 添加适当的顶部和底部内边距
        return titleSize.height + 10  // 例如，上下各增加 5 点的间距
    }
    
    private func layoutButtons() {
        var previousButton: UIButton?
        for button in buttons {
            button.translatesAutoresizingMaskIntoConstraints = false
            
            // 设置按钮的顶部和底部约束
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: scrollView.topAnchor),
                button.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            ])
            
            // 根据按钮标题计算宽度
            let buttonTitle = button.title(for: .normal) ?? ""
            
            let buttonWidth = widthForButtonTitle(buttonTitle, font: button.titleLabel?.font ?? UIFont.systemFont(ofSize: buttonFontSize))
            
            // 为按钮设置宽度约束
            let widthConstraint = button.widthAnchor.constraint(equalToConstant: buttonWidth)
            widthConstraint.isActive = true
            
            // 设置按钮的水平位置约束
            if let previousButton = previousButton {
                NSLayoutConstraint.activate([
                    button.leadingAnchor.constraint(equalTo: previousButton.trailingAnchor, constant: 10)
                ])
            } else {
                NSLayoutConstraint.activate([
                    button.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10)
                ])
            }
            
            // 更新 previousButton 以便下一个循环使用
            previousButton = button
            
        }
        
        // 为滚动视图的内容设置适当的结束约束
        if let lastButton = previousButton {
            NSLayoutConstraint.activate([
                lastButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10)
            ])
        }
        
        
        //        layoutIfNeeded()
        
        // 更新按钮的圆角
        updateButtonCornerRadius()
    }
    
    // 更新按钮的圆角
    private func updateButtonCornerRadius() {
        for button in buttons {
            // 等待自动布局完成后获取按钮的高度
            button.layoutIfNeeded()
            // 将圆角设置为按钮高度的一半
            button.layer.cornerRadius = button.bounds.height / 2
        }
    }
    
    private func updateButtonShadows() {
        for button in buttons {
            if showButtonShadow {
                button.layer.shadowColor = UIColor.black.cgColor
                button.layer.shadowOffset = CGSize(width: 2, height: 2)
                button.layer.shadowRadius = 1
                button.layer.shadowOpacity = 0.5
            } else {
                button.layer.shadowOpacity = 0
            }
        }
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        for button in buttons {
            button.backgroundColor = .white
            button.isSelected = false
        }
        sender.backgroundColor = .darkGray
        sender.isSelected = true
        
        // 确保按钮在 scrollView 中可见
        scrollToButton(button: sender)
        
        delegate?.buttonTapped(btnIdx: sender.tag)
    }
    
    private func scrollToButton(button: UIButton) {
        // 延迟直到下一个布局周期，确保布局已完成
        DispatchQueue.main.async {
            // 计算按钮在 scrollView 中的位置
            let buttonFrame = button.frame
            let scrollVisibleRect = CGRect(x: buttonFrame.origin.x, y: 0, width: buttonFrame.width, height: self.scrollView.frame.height)
//            print("\(scrollVisibleRect)")
            // 滚动到按钮的位置
            self.scrollView.scrollRectToVisible(scrollVisibleRect, animated: true)
        }
    }
    
    public func scrollToButton(btnIdx: Int) {
        print("scrollToButton:\(btnIdx)")
        // 检查索引有效性
        guard btnIdx >= 0 && btnIdx < buttons.count else {
            print("Index \(btnIdx) is out of range.")
            return
        }
        
        // 获取对应的按钮
        let button = buttons[btnIdx]
        defaultSelectedIndex = button.tag
        scrollToButton(button: button)
        selectDefaultButton()
    }
    
    /// 选择默认的按钮
    private func selectDefaultButton() {
        if defaultSelectedIndex < buttons.count {
            let defaultButton = buttons[defaultSelectedIndex]
            buttonTapped(defaultButton)
        }
    }
}
