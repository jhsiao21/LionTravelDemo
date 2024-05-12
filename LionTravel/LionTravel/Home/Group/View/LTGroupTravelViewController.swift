//
//  LTGroupTravelViewController.swift
//  LionTravel
//
//  Created by Logan on 2024/5/9.
//

import UIKit

class LTGroupTravelViewController: UIViewController {

    @IBOutlet var fromLabel: UILabel!
    @IBOutlet var fromStackView: UIStackView!
    @IBOutlet var keywordLabel: UILabel!
    @IBOutlet var keywordStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        layout()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        fromStackView.addGestureRecognizer(tapGesture)
    }
    
    private func style() {
        fromLabel.text = "不限"
        fromLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        
        fromStackView.backgroundColor = .systemGray5
        fromStackView.isLayoutMarginsRelativeArrangement = true
        fromStackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        keywordLabel.text = "輸入產品名稱/關鍵字/團號"
        
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            fromStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: fromStackView.trailingAnchor, multiplier: 2),
            fromStackView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 3),
        ])
    }
    
    @objc private func handleTap() {
        print("click from stack view")
        
        // 創建一個 action sheet 形式的 UIAlertController
        let alertController = UIAlertController(title: "請選擇出發地", message: nil, preferredStyle: .actionSheet)
        
        // 台灣的 16 個縣市
        let cities = ["不限", "基隆", "台北", "新北", "桃園", "新竹", "新竹",
                      "苗栗", "台中", "彰化", "南投", "雲林", "嘉義",
                      "嘉義", "台南", "高雄", "屏東"]
        
        // 為每個縣市添加一個選擇動作
        for city in cities {
            alertController.addAction(UIAlertAction(title: city, style: .default, handler: { action in
                // 當選擇一個縣市時，你可以在這裡處理用戶的選擇
                print("選擇了 \(action.title!)")
                self.fromLabel.text = city
            }))
        }
        
        // 添加取消動作
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        
        // 展示這個 action sheet
        present(alertController, animated: true, completion: nil)
    }


}
