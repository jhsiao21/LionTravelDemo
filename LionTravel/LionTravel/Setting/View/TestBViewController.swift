//
//  TestBViewController.swift
//  LionTravel
//
//  Created by Logan on 2024/5/15.
//

import UIKit

class TestBViewController: UIViewController {
    
    @IBOutlet weak var anchorMenuCollectionView: LTAnchorMenuCollectionView!
    
    let viewModel = SettingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupAnchorMenuCollectionView()
    }
        
    private func setupAnchorMenuCollectionView() {
        anchorMenuCollectionView.register(cellClass: UICollectionViewCell.self, forCellReuseIdentifier: "cell")
        anchorMenuCollectionView.delegate = self
        anchorMenuCollectionView.dataSource = self
    }
}

//MARK: - LTAnchorMenuCollection
extension TestBViewController: LTAnchorMenuCollectionDataSource {
    func anchorMenuCollectionView(_ view: LTAnchorMenuCollectionView, cellForButtonAt index: Int) -> UIButton {
        let title = viewModel.item(at: index)
        let button = anchorMenuCollectionView.anchorMenuView.createButton(withTitle: title, fontSize: 14)
        
        return button
    }
    
    func numberOfButtonsToShow() -> Int {
        return viewModel.numberOfItems()
    }
    
    func numberOfItemsInSection() -> Int {
        return viewModel.numberOfItems()
    }
    
    func anchorMenuCollectionView(_ view: LTAnchorMenuCollectionView, cellForItemAt index: Int) -> UICollectionViewCell {
        print("cellForItemAt:\(index)")
        let cell = view.dequeueReusableCell(withIdentifier: "cell", for: IndexPath(item: index, section: 0))
        
        // Configure the cell
        cell.backgroundColor = .lightGray
        let label = UILabel(frame: cell.bounds)
        label.text = viewModel.item(at: index)
        label.textAlignment = .center
        
        // Remove old label views if they exist
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.contentView.addSubview(label)
        
        return cell
    }
}

extension TestBViewController: LTAnchorMenuCollectionDelegate {
    func button(didSelect view: UIButton, at index: Int) {
        print("click index:\(index) button")
    }
    
    func collectionView(didSelectItemAt index: Int) {
        print("click index:\(index) cell")
    }
}
