//
//  LTAnchorMenuView.swift
//  LionTravel
//
//  Created by Logan on 2024/5/13.
//

import UIKit

class LTAnchorMenuView: UIView {

    @IBOutlet var scrollView: UIScrollView!
    
    /**
     Horizontal inset of a button in scrollView
     */
    let horizontalInset: CGFloat = 10.0
    
    private var buttons = [UIButton]()

    var numberOfButtonsToBeVisible = 8
    
    private var numberOfButtonsToShow = 0
    
    var dataSource: AnchorMenuDataSource? {
        didSet {
            reloadData()
        }
    }
    
    weak var delegate: AnchorMenuDelegate?
    
    var defaultSelectedIndex: Int = 0 {
        didSet {
            selectDefaultButton()
        }
    }
    
    var allowsScrolling: Bool = true {
        didSet { scrollView?.isScrollEnabled = allowsScrolling }
    }
    
    var showButtonShadow: Bool = false {
        didSet {
//            updateButtonShadows()
        }
    }
    
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

        let bundle = Bundle(for: type(of: self))
        if let views = bundle.loadNibNamed("LTAnchorMenuView", owner: self, options: nil),
           let contentView = views.first as? UIView {
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }

        scrollView.isScrollEnabled = true
    }
    
    /**
     This method reloads data in Card Container.
     1. All card views removed
     2. Layout
     3. Adding N button to scrollView (N = min(numberOfButtonsToShow, numberOfButtonsToBeVisible)
    */
    func reloadData() {
        removeAllButtons()
        guard let datasource = dataSource else { return }
        setNeedsLayout()
        layoutIfNeeded()
        numberOfButtonsToShow = datasource.numberOfButtonsToShow()
//        defaultSelectedIndex = 0
        
        var totalWidth: CGFloat = 0.0
        for index in 0..<min(numberOfButtonsToShow, numberOfButtonsToBeVisible) {
            guard let btn = datasource.button(at: index) else { return }
            addButton(button: btn, atIndex: index)
            totalWidth += btn.frame.width
        }
        
        scrollView.contentSize = CGSize(width: totalWidth + CGFloat(numberOfButtonsToShow - 1) * horizontalInset, height: scrollView.frame.height)
        
        
    }
    
    /**
     This method removes all card views from container
    */
    private func removeAllButtons() {
        for button in buttons {
            button.removeFromSuperview()
        }
        
        buttons = []
    }
    
    // MARK: - Configurations
    /**
     This method adds card view to the card container view
    */
    private func addButton(button: UIButton, atIndex index: Int) {
        print("addButton")
        
        addButtonFrame(index: index, btn: button)
        button.layer.cornerRadius = button.frame.height / 2
        buttons.append(button)
        
        scrollView.addSubview(button)
    }
    
    /**
     This method creates card view's frame based on index of a card
    */
    private func addButtonFrame(index: Int, btn: UIButton) {
        
        // 根据标题计算宽度
        let buttonWidth = widthForButtonTitle(btn.titleLabel!.text!, font: btn.titleLabel!.font)
        
        // 计算按钮的水平位置：基于前一个按钮的位置和宽度加上间隙
        let horizontalPosition: CGFloat
        if index == 0 {
            // 如果是第一个按钮，则从 scrollView 的 leading 开始加上 horizontalInset
            horizontalPosition = 0
            btn.isSelected = true
        } else {
            // 否则，根据前一个按钮的 maxX 和间距计算新位置
            horizontalPosition = buttons[index - 1].frame.maxX + self.horizontalInset
        }
        
        btn.frame = CGRect(x: horizontalPosition, y: 0, width: buttonWidth, height: scrollView.frame.height)
        print("btnFrame:\(btn.frame)")
    }
}


extension LTAnchorMenuView {
    
    /// 计算给定标题和字体的宽度
    /// - Parameters:
    ///   - title: 按钮的标题
    ///   - font: 字体
    /// - Returns: 标题的宽度
    func widthForButtonTitle(_ title: String, font: UIFont) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        
        let titleSize = (title as NSString).size(withAttributes: attributes)
        // 添加适当的内边距
        return titleSize.width + self.horizontalInset * 2
    }
    
    /// 创建一个按钮，并根据给定的标题调整宽度
    /// - Parameters:
    ///   - title: 按钮的标题
    ///   - fontSize: 标题的字体大小
    /// - Returns: 配置好的 UIButton
    func createButton(withTitle title: String, fontSize: CGFloat) -> UIButton {
        let button = UIButton()
        
        button.backgroundColor = .white
        
        // 设置按钮的标题和颜色
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .selected)
//        button.setBackgroundImage(UIImage(color: .darkGray), for: .selected)
        
        // 设置标题字体
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        
        button.addTarget(self, action: #selector(btnTapped(_:)), for: .touchUpInside)
        
        return button
    }
    
    @objc private func btnTapped(_ sender: UIButton) {
        
        guard let btnIdx = buttons.firstIndex(of: sender) else {
            print("Button not found in the array")
            return
        }
        print("click button:\(sender.titleLabel!.text!), index: \(btnIdx)")
        
        for button in buttons {
            button.backgroundColor = .white
            button.isSelected = false
        }
        sender.backgroundColor = .darkGray
        sender.isSelected = true
        
        scrollToButton(button: sender)
        delegate?.button(didSelect: sender, at: btnIdx)
        
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
        defaultSelectedIndex = btnIdx
        scrollToButton(button: button)
        selectDefaultButton()
    }
    
    /// 选择默认的按钮
    private func selectDefaultButton() {
        if buttons.indices.contains(defaultSelectedIndex) {
            let defaultButton = buttons[defaultSelectedIndex]
            btnTapped(defaultButton)
        }
    }
}
