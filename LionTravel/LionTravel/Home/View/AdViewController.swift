//
//  ImageViewController.swift
//  LionTravel
//
//  Created by LoganMacMini on 2024/4/4.
//

import UIKit

protocol AdViewControllerDelegate: AnyObject {
    func didRequestToShowDetail(forURL url: URL)
}

final class AdViewController: UIViewController {
    
    weak var delegate: AdViewControllerDelegate?
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    var link: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        setupTapGesture()
    }
    
    private func layout() {
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTapGesture() {
        print("\(imageView.hashValue)")
        guard let url = link else {
            return
        }
        
        delegate?.didRequestToShowDetail(forURL: url)
    }
}

