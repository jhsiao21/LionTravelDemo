//
//  SettingViewController.swift
//  Cathaybk_iOS_interview
//
//  Created by LoganMacMini on 2024/1/4.
//

import UIKit

class SettingViewController: UIViewController  {
    
    let viewModel = SettingViewModel()
    
    let shortcutUIView = UIView()
    
    let anchorMenuView = AnchorMenuView()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        layout()
        
        setupCollectionView()
        setupAnchorMenuView()
    }
    
    private func setupAnchorMenuView() {
                
        anchorMenuView.delegate = self
        anchorMenuView.dataSource = self
        anchorMenuView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func style() {
        
    }
    
    private func layout() {
        shortcutUIView.translatesAutoresizingMaskIntoConstraints = false
        shortcutUIView.addSubview(anchorMenuView)
        
        view.addSubview(shortcutUIView)
        
        view.addSubview(collectionView)
        
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            
            shortcutUIView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            shortcutUIView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            shortcutUIView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shortcutUIView.heightAnchor.constraint(equalToConstant: 50),
            
            anchorMenuView.leadingAnchor.constraint(equalTo: shortcutUIView.leadingAnchor),
            anchorMenuView.topAnchor.constraint(equalTo: shortcutUIView.topAnchor),
            anchorMenuView.trailingAnchor.constraint(equalTo: shortcutUIView.trailingAnchor),
            anchorMenuView.heightAnchor.constraint(equalToConstant: 50),
            
            collectionView.topAnchor.constraint(equalTo: shortcutUIView.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 100),
            
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            pageControl.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            
        ])
    }
    
    func scrollToItem(_ travelType: TravelAtTimeType) {
        
        let rowIndex = travelType.rawValue * 4 //一頁４個cell
        let indexPath = IndexPath(item: rowIndex, section: 0)
        
        print("IndexPath:\(indexPath)")
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

//MARK: - UICollectionView delegate
extension SettingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        // Configure the cell
        cell.backgroundColor = .lightGray
        let label = UILabel(frame: cell.bounds)
        label.text = viewModel.item(at: indexPath.row)
        label.textAlignment = .center
        
        // Remove old label views if they exist
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.contentView.addSubview(label)
        
        return cell
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

//MARK: - UIScrollView delegate
extension SettingViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let visibleIdexPath = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        pageControl.currentPage = visibleIdexPath
        
        anchorMenuView.scrollToButton(btnIdx: visibleIdexPath)
    }
}

//MARK: - AnchorMenu delegate
extension SettingViewController: AnchorMenuDataSource {
    
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

extension SettingViewController: AnchorMenuDelegate {
    func button(didSelect view: UIButton, at index: Int) {

        if let travelType = TravelAtTimeType(rawValue: index) {
            scrollToItem(travelType)
            pageControl.currentPage = travelType.rawValue
        }
    }
}
