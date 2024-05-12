//
//  TopSelectedTableViewCell.swift
//  LionTravel
//
//  Created by LoganMacMini on 2024/4/4.
//

import UIKit

protocol TopSelectedCellDelegate: AnyObject {
    func didRequestToShowDetail(forURL url: URL)
}

class TopSelectedTableViewCell: UITableViewCell {
    
    weak var delegate: TopSelectedCellDelegate?

    static let identifier = "TopTableViewCell"
    
    private var timer: Timer?
    
    var pages = [UIViewController]()
    
    private var images: [UIImage] = [UIImage]()
    
    private let pageViewControler : UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        
        return pageVC
    }()
    
    
    private let pageControl: UIPageControl = {
       let pageCtl = UIPageControl()
//        pageCtl.numberOfPages = 4
        pageCtl.currentPage = 0
        pageCtl.pageIndicatorTintColor = UIColor.lightGray  //未選定的頁數顯示顏色
        pageCtl.currentPageIndicatorTintColor = .black      //選定的頁數顯示顏色
        pageCtl.translatesAutoresizingMaskIntoConstraints = false
        
        return pageCtl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        
        layout()
        startAutoScroll()
        pageViewControler.delegate = self
        pageViewControler.dataSource = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        let pageViewControllerView = pageViewControler.view!
        pageViewControllerView.layer.cornerRadius = 10
        pageViewControllerView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(pageViewControllerView)
        contentView.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageViewControllerView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            pageViewControllerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            pageViewControllerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            pageViewControllerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
                       
            pageControl.topAnchor.constraint(equalTo: pageViewControllerView.bottomAnchor),
            pageControl.centerXAnchor.constraint(equalTo: pageViewControllerView.centerXAnchor),
        ])
    }
    
    public func configure(with contents: [AdContent]) {
        
        pages = contents.map { content -> UIViewController in
            let adVC = AdViewController()
            adVC.delegate = self
            adVC.imageView.image = content.image
            adVC.link = content.link
            return adVC
        }
        
        if let firstPage = pages.first {
            pageViewControler.setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        }
        
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        // 因為UIPageViewController已經加到contentView，所以不需要因為資料而重新做reloadInputViews()
    }
    
    func startAutoScroll() {
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(scrollToNextPage), userInfo: nil, repeats: true)
    }
    
    @objc func scrollToNextPage() {
        guard let currentViewController = pageViewControler.viewControllers?.first,
              let currentIndex = pages.firstIndex(of: currentViewController),
              pages.count > 1 else {
            return
        }
        
        let nextIndex = (currentIndex + 1) % pages.count
        let nextViewController = pages[nextIndex]
        pageViewControler.setViewControllers([nextViewController], direction: .forward, animated: true) { completed in
            if completed {
                self.pageControl.currentPage = nextIndex
            }
        }
    }

}

//MARK: - UIPageViewControllerDataSource
extension TopSelectedTableViewCell: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // 如果previousIndex是第一頁時，回到最後一頁
        if previousIndex < 0 {
            return pages[pages.count - 1]
        } else {
            return pages[previousIndex]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        // 如果nextIndex是最後一頁時，回到第一頁
        if nextIndex >= pages.count {
            return pages.first
        } else {
            return pages[nextIndex]
        }
    }
}

//MARK: - UIPageViewControllerDelegate
extension TopSelectedTableViewCell: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed,
            let visibleViewController = pageViewController.viewControllers?.first,
            let index = pages.firstIndex(of: visibleViewController) {
            
            pageControl.currentPage = index
        }
    }
    
}

extension TopSelectedTableViewCell: AdViewControllerDelegate {
    func didRequestToShowDetail(forURL url: URL) {
        delegate?.didRequestToShowDetail(forURL: url)        
    }
}
