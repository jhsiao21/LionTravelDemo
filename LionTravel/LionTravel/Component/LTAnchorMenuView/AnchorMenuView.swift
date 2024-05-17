//
//  AnchorMenuView.swift
//  LionTravel
//
//  Created by Logan on 2024/5/13.
//

import UIKit

class AnchorMenuView: UIView {

    @IBOutlet var scrollView: UIScrollView!
    
    /**
     Horizontal margin of each button
     */
    var spacing: CGFloat = 0.0
    
    /**
     Horizontal inset of a button
     */
    var horizontalInset: CGFloat = 20.0
    
    /**
     Vertical inset of a button
     */
    var verticalInset: CGFloat = 15.0
        
    var defaultSelectedIndex: Int = 0 {
        didSet {
            selectDefaultButton(btnIdx: defaultSelectedIndex)
        }
    }
    
    var allowsScrolling: Bool = true {
        didSet { scrollView?.isScrollEnabled = allowsScrolling }
    }
    
    var dataSource: AnchorMenuDataSource? {
        didSet {
            reloadData()
        }
    }
    
    weak var delegate: AnchorMenuDelegate?
    
    private var numberOfButtons: Int = 0
    
    private var buttons = [UIButton]()
    
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
     1. All buttons removed
     2. Layout
     3. Adding N button to scrollView (N = min(numberOfButtonsToShow, numberOfButtonsToBeVisible)
    */
    func reloadData() {
        removeAllButtons()
        guard let datasource = dataSource else { return }
        setNeedsLayout()
        layoutIfNeeded()
        numberOfButtons = datasource.numberOfButtonsToShow()
        
        var totalWidth: CGFloat = 0.0
        
        for index in 0..<numberOfButtons {
            guard let btn = datasource.button(at: index) else { return }
            addButton(button: btn, atIndex: index)
            print("btnFrame:\(btn.frame)")
            totalWidth += btn.frame.width
            print("totalWidth:\(totalWidth)")
        }
        print("totalWidth:\(totalWidth)")
        scrollView.contentSize = CGSize(width: totalWidth, height: scrollView.frame.height)
        print("scrollView.contentSize:\(scrollView.contentSize)")
        selectDefaultButton(btnIdx: defaultSelectedIndex)
    }
    
    /**
     This method removes all card views from container
    */
    private func removeAllButtons() {        
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
        
        // 依據title計算寬度
        let buttonWidth = widthForButtonTitle(btn.titleLabel!.text!, font: btn.titleLabel!.font)
        
        let buttonHeight = heightForButtonTitle(btn.titleLabel!.text!, font: btn.titleLabel!.font)
        
        let horizontalPosition: CGFloat
        if index == 0 {
            // 第一個按鈕水平位置:0
            horizontalPosition = 0
        } else {
            // 水平位置=前一個按鈕+間距
            horizontalPosition = buttons[index - 1].frame.maxX + self.spacing
        }
        
        btn.frame = CGRect(x: horizontalPosition, y: 0, width: buttonWidth, height: buttonHeight)
        print("*btnFrame:\(btn.frame)")
    }
}

extension AnchorMenuView {
    
    func widthForButtonTitle(_ title: String, font: UIFont) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        
        let titleSize = (title as NSString).size(withAttributes: attributes)
        // 添加适当的内边距
        return titleSize.width + self.horizontalInset
    }
    
    func heightForButtonTitle(_ title: String, font: UIFont) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        
        let titleSize = (title as NSString).size(withAttributes: attributes)
        // 添加适当的顶部和底部内边距
        return titleSize.height + self.verticalInset
    }
    
    func createButton(withTitle title: String, fontSize: CGFloat, shadowVisible: Bool = false) -> UIButton {
        
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        
        if shadowVisible {
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 2, height: 2)
            button.layer.shadowRadius = 1
            button.layer.shadowOpacity = 0.5
        } else {
            button.layer.shadowOpacity = 0
        }
        
        button.addTarget(self, action: #selector(btnTapped(_:)), for: .touchUpInside)
        
        return button
    }
    
    @objc private func btnTapped(_ sender: UIButton) {
        
        print(":\(sender.frame)")
        
        guard let btnIdx = buttons.firstIndex(of: sender) else {
            print("Button not found in the buttons array")
            return
        }
        
        print("click \(sender.titleLabel!.text!) button, index: \(btnIdx)")
        
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

        let buttonFrame = button.frame
        let targetRect = CGRect(x: buttonFrame.origin.x, y: 0, width: buttonFrame.width, height: self.scrollView.frame.height)
        print("targetRect:\(targetRect)")
        print("scrollView.contentSize:\(scrollView.contentSize)")
        self.scrollView.scrollRectToVisible(targetRect, animated: true)

    }
    
    public func scrollToButton(btnIdx: Int) {
        print("scrollToButton:\(btnIdx)")

        guard btnIdx >= 0 && btnIdx < buttons.count else {
            print("Index \(btnIdx) is out of range.")
            return
        }
        
        defaultSelectedIndex = btnIdx

        let button = buttons[btnIdx]
        scrollToButton(button: button)
    }
    
    /// 選擇預設按鈕
    private func selectDefaultButton(btnIdx: Int) {
        if buttons.indices.contains(defaultSelectedIndex) {
            let defaultButton = buttons[defaultSelectedIndex]
            btnTapped(defaultButton)
        }
    }
}
