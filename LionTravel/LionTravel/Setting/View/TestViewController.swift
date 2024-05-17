//
//  TestViewController.swift
//  LionTravel
//
//  Created by Logan on 2024/5/14.
//

import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet weak var anchorMenuView: AnchorMenuView!
    
    
    let viewModel = SettingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        
        setupAnchorMenuView()
    }

    private func layout() {
        
    }
    
    @IBAction func clickBtn(_ sender: UIButton) {
        print("touch me")
    }

    private func setupAnchorMenuView() {
        anchorMenuView.spacing = 0
        anchorMenuView.delegate = self
        anchorMenuView.dataSource = self
    }

}

extension TestViewController : AnchorMenuDataSource {
    func numberOfButtonsToShow() -> Int {
        return viewModel.numberOfItems()
    }
    
    func button(at index: Int) -> UIButton? {
        let title = viewModel.item(at: index)
        let btn = anchorMenuView.createButton(withTitle: title, fontSize: 14)
        
        return btn
    }
    
}

extension TestViewController: AnchorMenuDelegate {
    func button(didSelect view: UIButton, at index: Int) {
        print("button:\(index)")
    }
}
