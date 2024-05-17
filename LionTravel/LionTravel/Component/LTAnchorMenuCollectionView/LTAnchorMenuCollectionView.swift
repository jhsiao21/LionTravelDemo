//
//  LTAnchorMenuCollectionView.swift
//  LionTravel
//
//  Created by Logan on 2024/5/14.
//

import UIKit

class LTAnchorMenuCollectionView: UIView {
    
    @IBOutlet weak var anchorMenuView: LTAnchorMenuView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    private let itemSpace: Int = 10
    
    private let gridSize: Int = 1
        
    private var numberOfButtons: Int = 0
    
    private var numberOfItems: Int = 0
    
    var dataSource: LTAnchorMenuCollectionDataSource? {
        didSet {
            reloadData()
        }
    }
    
    weak var delegate: LTAnchorMenuCollectionDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        Initialize()
    }
    
    private func setupAnchorMenuView() {
//        print("setupAnchorMenuView()")
        
//        anchorMenuView.delegate = self
//        anchorMenuView.dataSource = self
    }
    
    private func setupCollectionView() {
//        print("setupCollectionView()")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupPageControl() {
//        print("setupPageControl()")
//        pageControl.numberOfPages = numberOfItems
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.lightGray  //未選定的頁數顯示顏色
        pageControl.currentPageIndicatorTintColor = .black      //選定的頁數顯示顏色
        pageControl.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func Initialize() {
//        print("Initialize LTAnchorMenuCollectionView")

        let bundle = Bundle(for: type(of: self))
        if let views = bundle.loadNibNamed("LTAnchorMenuCollectionView", owner: self, options: nil),
           let contentView = views.first as? UIView {
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
        setupAnchorMenuView()
        setupCollectionView()
        setupPageControl()
    }
    
    func reloadData() {
//        print("reloadData()")

        guard let datasource = dataSource else { return }
        setNeedsLayout()
        layoutIfNeeded()
        numberOfButtons = datasource.numberOfButtonsToShow()
        numberOfItems = datasource.numberOfItemsInSection()
        
        pageControl.numberOfPages = numberOfItems
        
        anchorMenuView.delegate = self
        anchorMenuView.dataSource = self
        
        collectionView.reloadData()
                
    }
    
    func register(cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        self.collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        return cell
    }
    
    func scrollToItem(itemAt index: Int) {
        
        if collectionView.contentSize.width > 0 && collectionView.contentSize.height > 0 {
            let rowIndex = index * gridSize
            
            if rowIndex < collectionView.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(item: rowIndex, section: 0)
                print("scrollToItem at indexPath:\(indexPath)")
                
//                                    self.collectionView.scrollRectToVisible(CGRect(origin: CGPoint(x: self.collectionView.frame.width * CGFloat(rowIndex), y: 0), size: .zero), animated: true)
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                
            } else {
                print("Calculated rowIndex \(rowIndex) is out of bounds.")
            }
        } else {
            print("CollectionView contentSize is zero, unable to scroll.")
        }
    }
}

//MARK: - UIScrollViewDelegate
extension LTAnchorMenuCollectionView: UIScrollViewDelegate {
        
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // disable decelerating
        targetContentOffset.pointee = scrollView.contentOffset
        
        let scaleIndex = (scrollView.contentOffset.x) / scrollView.bounds.width
        let oldIndex = pageControl.currentPage
        var newIndex = lroundf(Float(scaleIndex))
        if newIndex == oldIndex  {
            let speedX = velocity.x
            if (speedX) > 1 {
                newIndex += 1
            } else if speedX < -1 {
                newIndex -= 1
            }
        }
        
        newIndex = max(0, newIndex)
        newIndex = min(newIndex, numberOfItems - 1) //確保newIndex會是在資料範圍內
        collectionView.scrollToItem(at: IndexPath(item: newIndex, section: 0), at: .centeredHorizontally, animated: true)
        pageControl.currentPage = newIndex
        anchorMenuView.scrollToButton(btnIdx: newIndex)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print("scrollViewDidEndDragging")
    }
        
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print("scrollView.contentOffset.x:\(scrollView.contentOffset.x), scrollView.bounds.width:\(scrollView.bounds.width)")
        
        let visibleIdexPath = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        pageControl.currentPage = visibleIdexPath
        print("visibleIdexPath:\(visibleIdexPath)")
//        anchorMenuView.scrollToButton(btnIdx: visibleIdexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("scrollView.contentOffset.x:\(scrollView.contentOffset.x)")
    }
}

//MARK: - LTAnchorMenu
extension LTAnchorMenuCollectionView: LTAnchorMenuDelegate {
    func button(didSelect view: UIButton, at index: Int) {
        delegate?.button(didSelect: view, at: index)
        
        scrollToItem(itemAt: index)
        pageControl.currentPage = index
    }
}

extension LTAnchorMenuCollectionView: LTAnchorMenuDataSource {
    func numberOfButtonsToShow() -> Int {
//        print("LTAnchorMenuDataSource numberOfButtonsToShow():\(numberOfButtons)")
        
        guard let numberOfButtons = dataSource?.numberOfButtonsToShow() else { return 0
        }
        
        return numberOfButtons
    }
    
    func button(at index: Int) -> UIButton? {
        
        let button = dataSource?.anchorMenuCollectionView(self, cellForButtonAt: index)
        
        return button
    }
}

//MARK: - UICollectionView
extension LTAnchorMenuCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("UICollectionViewDataSource numberOfItemsInSection:\(numberOfItems)")
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        print("collectionView cellForItemAt:\(indexPath.row)")
        
        guard let dataSource = dataSource else {
            return UICollectionViewCell()
        }
        
        let cell = dataSource.anchorMenuCollectionView(self, cellForItemAt: indexPath.item)
        
        return cell
    }
}

extension LTAnchorMenuCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.collectionView(didSelectItemAt: indexPath.row)
        print("click \(indexPath) cell")
    }
}

extension LTAnchorMenuCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = collectionView.bounds.width
        let widthPerItem = availableWidth / CGFloat(self.gridSize)
        
        let availableHeight = collectionView.bounds.height
        let heightPerItem = availableHeight / CGFloat(self.gridSize)
        
        print("indexPath:\(indexPath), availableWidth:\(availableWidth), availableHeight:\(availableHeight)")
        print("indexPath:\(indexPath), widthPerItem:\(widthPerItem), heightPerItem:\(heightPerItem)")
        return CGSize(width: widthPerItem, height: widthPerItem)
        
//        return CGSize(width: 140, height: 140)
    }
}
