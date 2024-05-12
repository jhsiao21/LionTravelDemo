import UIKit

protocol LinkedBtnTappedDelegate: AnyObject {
    func buttonIsPressed(tag: Int)
}

final class TravelAtTimeHeaderView: UIView, UIScrollViewDelegate {
    
    let buttonWidth: CGFloat = 80
    let buttonHeight: CGFloat = 35
    let buttonSpacing: CGFloat = 10
    
    weak var linkedBtnTappedDelegate: LinkedBtnTappedDelegate?
    
    private let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    
    private let hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private var buttons : [UIButton] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView.delegate = self
        layout()
        setupButtons()
    }
    
    private func layout() {
                
        scrollView.addSubview(hStackView)
        addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            hStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
    
    private func setupButtons() {
        for type in TravelAtTimeType.allCases {
            let button = createButton(forType: type)
            buttons.append(button)
            hStackView.addArrangedSubview(button)
        }
        
        selectButton(0) //設定預設選中的按鈕
    }
    
    private func createButton(forType travelAtTimeType: TravelAtTimeType) -> UIButton {
        let button = UIButton()
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .semibold),
            .underlineStyle: NSUnderlineStyle.Element().rawValue,
        ]
        
        button.setAttributedTitle(NSAttributedString(string: travelAtTimeType.caseDescription, attributes: titleAttributes), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = buttonHeight / 2
        button.tag = travelAtTimeType.rawValue
        
        button.addTarget(self, action: #selector(LinkedBtTapped), for: .touchUpInside)
        
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        return button
    }
    
    // 快速連結按鈕handler
    @objc private func LinkedBtTapped(_ sender: UIButton) {
        selectButton(sender.tag)
        linkedBtnTappedDelegate?.buttonIsPressed(tag: sender.tag)

        let offset = sender.tag > 2 ? sender.tag : 0
        
        // 按鈕偏移量
        let contentOffsetX = CGFloat(offset) * (buttonWidth + buttonSpacing)
        
        // scrollView的最大可移動偏移量
        let maxOffsetX = scrollView.contentSize.width - scrollView.bounds.width
        
        // 實際偏移量
        // 如果點選的按鈕對應的偏移量超過了最大偏移量，就使用最大偏移量maxOffsetX，否則使用contentOffsetX
        let actualOffsetX = min(contentOffsetX, maxOffsetX)
        
        scrollView.setContentOffset(CGPoint(x: actualOffsetX, y: 0), animated: true)
    }
    
    private func selectButton(_ selected: Int) {
        //        print("selected:\(selected)")
        for button in buttons {
            
            button.backgroundColor = .systemBackground
            button.setTitleColor(UIColor.darkGray, for: .normal)
            
            if button.tag == selected {
                button.backgroundColor = .darkGray
                button.setTitleColor(.white, for: .normal)
            }
        }
    }
    
    func linkToSelectionBtn(btnIdx: Int) {
        print("btnIdx:\(btnIdx)")
        selectButton(btnIdx)
        
        let offset = btnIdx > 2 ? btnIdx : 0
        
        // 按鈕偏移量
        let contentOffsetX = CGFloat(offset) * (buttonWidth + buttonSpacing)
        
        // scrollView的最大可移動偏移量
        let maxOffsetX = scrollView.contentSize.width - scrollView.bounds.width
        
        // 實際偏移量
        // 如果點選的按鈕對應的偏移量超過了最大偏移量，就使用最大偏移量maxOffsetX，否則使用contentOffsetX
        let actualOffsetX = min(contentOffsetX, maxOffsetX)
        
        scrollView.setContentOffset(CGPoint(x: actualOffsetX, y: 0), animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
