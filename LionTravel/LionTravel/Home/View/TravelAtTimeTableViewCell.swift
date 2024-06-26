//
//  HomeTableTravelAtTimeViewCell.swift
//  LionTravel
//
//  Created by LoganMacMini on 2024/4/1.
//

import UIKit

class TravelAtTimeTableViewCell: UITableViewCell {
    
    private let itemSpace: Int = 10
    
    private let columnCount: Int = 2
    
    private let rowCount: Int = 2

    static let identifier = "TravelAtTimeTableViewCell"
    
    private var images: [UIImage] = [UIImage]()

    private let anchorMenuView = AnchorMenuView()
            
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
        pageCtl.translatesAutoresizingMaskIntoConstraints = false
        
        return pageCtl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupAnchorMenuView()
    }
        
    private func setupAnchorMenuView() {
        
        anchorMenuView.translatesAutoresizingMaskIntoConstraints = false
        anchorMenuView.dataSource = self
        anchorMenuView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.backgroundColor = .systemBackground
    }
    
    private func layout() {
        contentView.addSubview(anchorMenuView)
        contentView.addSubview(collectionView)
        contentView.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            
            anchorMenuView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 2),
            anchorMenuView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            anchorMenuView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            anchorMenuView.heightAnchor.constraint(equalToConstant: 35), //跟travelAtTimeHeaderView內的按鈕高度一樣
            collectionView.topAnchor.constraint(equalToSystemSpacingBelow: anchorMenuView.bottomAnchor, multiplier: 1),
            
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
    
    func scrollToItem(_ travelType: TravelAtTimeType) {
        
        let rowIndex = travelType.rawValue * 4 //一頁４個cell
        let indexPath = IndexPath(item: rowIndex, section: 0)
        
        print("IndexPath:\(indexPath)")
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
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
                
//        let paddingSpace : CGFloat = 10 * 2 // 2個間隔(左右兩邊)
//        let availableWidth = collectionView.bounds.width - paddingSpace
//        let widthPerItem = availableWidth / 2 // 每列2個item
//        
//        let availableHeight = collectionView.bounds.height - paddingSpace
//        let heightPerItem = availableHeight / 2 // 每行2個item
//        print("indexPath:\(indexPath), availableWidth:\(availableWidth), availableHeight:\(availableHeight)")
//        print("indexPath:\(indexPath), widthPerItem:\(widthPerItem), heightPerItem:\(heightPerItem)")
//        return CGSize(width: widthPerItem, height: heightPerItem)
        
        let paddingSpace : CGFloat = CGFloat(self.itemSpace * (self.columnCount))
        let availableWidth = collectionView.bounds.width - paddingSpace
        let widthPerItem = availableWidth / CGFloat(self.columnCount)
        
        let availableHeight = collectionView.bounds.height - paddingSpace
        let heightPerItem = availableHeight / CGFloat(self.rowCount)
        
        print("indexPath:\(indexPath), availableWidth:\(availableWidth), availableHeight:\(availableHeight)")
        print("indexPath:\(indexPath), widthPerItem:\(widthPerItem), heightPerItem:\(heightPerItem)")
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
}


//MARK: - UIScrollViewDelegate
extension TravelAtTimeTableViewCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollView.contentOffset.x:\(scrollView.contentOffset.x), scrollView.bounds.width:\(scrollView.bounds.width)")
        let visibleIdexPath = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        pageControl.currentPage = visibleIdexPath
        
        anchorMenuView.scrollToButton(btnIdx: visibleIdexPath)
    }
}

extension TravelAtTimeTableViewCell: AnchorMenuDataSource {
    
    func numberOfButtonsToShow() -> Int {
        return TravelAtTimeType.allCases.count
    }
    
    func button(at index: Int) -> UIButton? {
        // 這裏可以使用createButton實作按鈕標題、樣式或自行建立UIButton
        let title = MockData.titles[index]
        let button = anchorMenuView.createButton(withTitle: title, fontSize: 14)

        return button
    }
}

extension TravelAtTimeTableViewCell: AnchorMenuDelegate {
    func button(didSelect view: UIButton, at index: Int) {

        if let travelType = TravelAtTimeType(rawValue: index) {
            scrollToItem(travelType)
            pageControl.currentPage = travelType.rawValue
        }
    }
}


