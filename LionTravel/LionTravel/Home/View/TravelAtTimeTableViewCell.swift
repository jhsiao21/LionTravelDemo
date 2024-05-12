//
//  HomeTableTravelAtTimeViewCell.swift
//  LionTravel
//
//  Created by LoganMacMini on 2024/4/1.
//

import UIKit

class TravelAtTimeTableViewCell: UITableViewCell {

    static let identifier = "TravelAtTimeTableViewCell"
    
    private var images: [UIImage] = [UIImage]()
    
//    private let travelAtTimeHeaderView = TravelAtTimeHeaderView()
    private let buttonMenuView = LTButtonMenuView()
    
    var collectionViewFlowLayout = UICollectionViewFlowLayout()
        
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    private let pageControl: UIPageControl = {
       let pageCtl = UIPageControl()
        pageCtl.numberOfPages = TravelAtTimeType.allCases.count
        pageCtl.currentPage = 0
        pageCtl.pageIndicatorTintColor = UIColor.lightGray  //未選定的頁數顯示顏色
        pageCtl.currentPageIndicatorTintColor = .black      //選定的頁數顯示顏色
        pageCtl.addTarget(self, action: #selector(changePage(_:)), for: .valueChanged)
        pageCtl.translatesAutoresizingMaskIntoConstraints = false
        
        return pageCtl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
//        travelAtTimeHeaderView.translatesAutoresizingMaskIntoConstraints = false
//        travelAtTimeHeaderView.linkedBtnTappedDelegate = self
        
        setupButtonMenu()
    }
    
    private func setupButtonMenu() {
        
        var buttonTitles: [String] = []
        
        // 設定預設按鈕索引
        buttonMenuView.defaultSelectedIndex = 0
        
        // 设置允许滚动
        buttonMenuView.allowsScrolling = true
        // 设置显示阴影
        buttonMenuView.showButtonShadow = true
        
        // 设置按钮标题
        for type in TravelAtTimeType.allCases {
            buttonTitles.append(type.caseDescription)
        }
        
        buttonMenuView.buttonTitles = buttonTitles
        
        // 设置按钮数量
        buttonMenuView.numberOfButtons = TravelAtTimeType.allCases.count
        
        buttonMenuView.translatesAutoresizingMaskIntoConstraints = false
        buttonMenuView.buttonMenuDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.backgroundColor = .systemBackground
    }
    
    private func layout() {
        contentView.addSubview(buttonMenuView)
        contentView.addSubview(collectionView)
        contentView.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            buttonMenuView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 2),
            buttonMenuView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            buttonMenuView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            buttonMenuView.heightAnchor.constraint(equalToConstant: 35), //跟travelAtTimeHeaderView內的按鈕高度一樣
            
            collectionView.topAnchor.constraint(equalToSystemSpacingBelow: buttonMenuView.bottomAnchor, multiplier: 1),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            pageControl.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor)
        ])
    }
    
    public func configure(with contents: [AdContent]) {
        
        images = contents.map { content -> UIImage in
            return content.image
        }
        
        //selectData array改變就更新collectionView
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    @objc private func changePage(_ sender: UIPageControl) {
        let point = CGPoint(x: (collectionView.bounds.width * CGFloat(sender.currentPage)), y: 0)
        collectionView.setContentOffset(point, animated: true)
    }
}

//MARK: - UICollectionView delegate
extension TravelAtTimeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        cell.configure(image: images[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        
        print("collectionView section:\(indexPath.section) didSelectItemAt:\(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                
        let paddingSpace : CGFloat = 10 * 2 // 2個間隔(左右兩邊)
        let availableWidth = collectionView.bounds.width - paddingSpace
        let widthPerItem = availableWidth / 2 // 每列2個item
        
        let availableHeight = collectionView.bounds.height - paddingSpace
        let heightPerItem = availableHeight / 2 // 每行2個item
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }    
}

extension TravelAtTimeTableViewCell: LinkedBtnTappedDelegate {
    
    func buttonIsPressed(tag: Int) {
        if let travelType = TravelAtTimeType(rawValue: tag) {
            scrollToItem(travelType)
            pageControl.currentPage = travelType.rawValue
        }
    }
    
    func scrollToItem(_ travelType: TravelAtTimeType) {
        
        let rowIndex = travelType.rawValue * 4 //一頁４個cell
        let indexPath = IndexPath(item: rowIndex, section: 0)
        
        print("IndexPath:\(indexPath)")
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

//MARK: - UIScrollViewDelegate
extension TravelAtTimeTableViewCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollView.contentOffset.x:\(scrollView.contentOffset.x), scrollView.bounds.width:\(scrollView.bounds.width)")
        let visibleIdexPath = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        pageControl.currentPage = visibleIdexPath
        buttonMenuView.scrollToButton(btnIdx: visibleIdexPath)
    }
}

extension TravelAtTimeTableViewCell: ButtonMenuDelegate {
    func buttonTapped(btnIdx: Int) {
        print("current button index:\(btnIdx)")
        if let travelType = TravelAtTimeType(rawValue: btnIdx) {
            scrollToItem(travelType)
            pageControl.currentPage = travelType.rawValue
        }
    }
    
    
}
