//
//  SettingViewController.swift
//  Cathaybk_iOS_interview
//
//  Created by LoganMacMini on 2024/1/4.
//

import UIKit

class SettingViewController: UIViewController  {
 
    let titleLabel = UILabel()
    let menuView = LTButtonMenuView()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(titleLabel)
        
        view.addSubview(menuView)
        
        // 設定預設按鈕索引
        menuView.defaultSelectedIndex = 0
        // 设置允许滚动
        menuView.allowsScrolling = true
        // 设置显示阴影
        menuView.showButtonShadow = true
        // 设置按钮数量
        menuView.numberOfButtons = 6
        // 设置按钮标题
        menuView.buttonTitles = ["團體旅遊", "特惠機票", "自由行", "訂房", "鐵道旅遊", "海外票券", "BB", "CCC", "DDDD"]
        
        menuView.buttonMenuDelegate = self
        menuView.translatesAutoresizingMaskIntoConstraints = false
        style()
        layout()
    }
    
    private func style() {
        titleLabel.text = "SettingViewController"
        titleLabel.font = .boldSystemFont(ofSize: 30)
        titleLabel.textColor = .gray
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            menuView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension SettingViewController : ButtonMenuDelegate {
    func buttonTapped(btnIdx: Int) {
        print("Current button index:\(btnIdx)")
    }
    
}
