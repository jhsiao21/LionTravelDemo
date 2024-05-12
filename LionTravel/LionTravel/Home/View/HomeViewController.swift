//
//  HomeViewController.swift
//  LionTravel
//
//  Created by LoganMacMini on 2024/4/1.
//

import UIKit
import JGProgressHUD

class HomeViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private var viewModel = HomeViewModel()

    private let hStack: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .bottom
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let safeAreaView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 28
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] //設定圓角區域 左上 右上
        
        return view
    }()
    
    private let groupBtn: UIButton = {
        var configuration = UIButton.Configuration.plain() //Creates a configuration for a button with a transparent
        configuration.baseForegroundColor = UIColor.white
        configuration.buttonSize = .small
        
        if let image = UIImage(named: "group_icon")?.resizedImage(newSize: CGSize(width: 45, height: 32)) {
            configuration.image = image
        } else {
            print("Image could not be loaded or resized")
        }
        
        configuration.imagePlacement = .top
        var attributes = AttributeContainer()
        attributes.foregroundColor = UIColor.darkGray
        configuration.attributedSubtitle = AttributedString("團體", attributes: attributes)
        configuration.titleAlignment = .center
        configuration.imagePadding = 10
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(self, action: #selector(groupBtnTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        
        return button
    }()
    
    private let airplaneTicketBtn: UIButton = {
        var configuration = UIButton.Configuration.plain() //Creates a configuration for a button with a transparent
        configuration.baseForegroundColor = UIColor.white
        configuration.buttonSize = .small
        if let image = UIImage(named: "airplane_ticket_icon")?.resizedImage(newSize: CGSize(width: 45, height: 33)) {
            configuration.image = image
        } else {
            print("Image could not be loaded or resized")
        }
        configuration.imagePlacement = .top
        var attributes = AttributeContainer()
        attributes.foregroundColor = UIColor.darkGray
        configuration.attributedSubtitle = AttributedString("機票", attributes: attributes)
        configuration.titleAlignment = .center
        configuration.imagePadding = 10
        let button = UIButton(configuration: configuration, primaryAction: nil)
//        button.addTarget(self, action: #selector(shareBtnTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        
        return button
    }()
    
    private let bookingBtn: UIButton = {
        var configuration = UIButton.Configuration.plain() //Creates a configuration for a button with a transparent
        configuration.baseForegroundColor = UIColor.white
        configuration.buttonSize = .small
        if let image = UIImage(named: "booking_icon")?.resizedImage(newSize: CGSize(width: 45, height: 33)) {
            configuration.image = image
        } else {
            print("Image could not be loaded or resized")
        }
        configuration.imagePlacement = .top
        var attributes = AttributeContainer()
        attributes.foregroundColor = UIColor.darkGray
        configuration.attributedSubtitle = AttributedString("訂房", attributes: attributes)
        configuration.titleAlignment = .center
        configuration.imagePadding = 10
        let button = UIButton(configuration: configuration, primaryAction: nil)
//        button.addTarget(self, action: #selector(shareBtnTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        
        return button
    }()
    
    private let independentTravelBtn: UIButton = {
        var configuration = UIButton.Configuration.plain() //Creates a configuration for a button with a transparent
        configuration.baseForegroundColor = UIColor.white
        configuration.buttonSize = .small
        if let image = UIImage(named: "independent_travel_icon")?.resizedImage(newSize: CGSize(width: 45, height: 33)) {
            configuration.image = image
        } else {
            print("Image could not be loaded or resized")
        }
        configuration.imagePlacement = .top
        var attributes = AttributeContainer()
        attributes.foregroundColor = UIColor.darkGray
        configuration.attributedSubtitle = AttributedString("自由行", attributes: attributes)
        configuration.titleAlignment = .center
        configuration.imagePadding = 10
        let button = UIButton(configuration: configuration, primaryAction: nil)
//        button.addTarget(self, action: #selector(shareBtnTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        
        return button
    }()
    
    private let couponBtn: UIButton = {
        var configuration = UIButton.Configuration.plain() //Creates a configuration for a button with a transparent
        configuration.baseForegroundColor = UIColor.white
        configuration.buttonSize = .small
        if let image = UIImage(named: "coupon_icon")?.resizedImage(newSize: CGSize(width: 45, height: 33)) {
            configuration.image = image
        } else {
            print("Image could not be loaded or resized")
        }
        configuration.imagePlacement = .top
        var attributes = AttributeContainer()
        attributes.foregroundColor = UIColor.darkGray
        configuration.attributedSubtitle = AttributedString("票券", attributes: attributes)
        configuration.titleAlignment = .center
        configuration.imagePadding = 10
        let button = UIButton(configuration: configuration, primaryAction: nil)
//        button.addTarget(self, action: #selector(shareBtnTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        
        return button
    }()
    
    private let homeTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .systemBackground
        table.separatorStyle = .none
        table.register(TopSelectedTableViewCell.self, forCellReuseIdentifier: TopSelectedTableViewCell.identifier)
        table.register(TravelAtTimeTableViewCell.self, forCellReuseIdentifier: TravelAtTimeTableViewCell.identifier)
        table.register(TravelArrivedTableViewCell.self, forCellReuseIdentifier: TravelArrivedTableViewCell.identifier)        
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = "想去哪裡?"
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.searchTextField.backgroundColor = .white
        controller.hidesNavigationBarDuringPresentation = false
                
        return controller
    }()
    
    private func style() {
        view.backgroundColor = UIColor.CustomPink
        homeTableView.showsVerticalScrollIndicator = false
        setupSearchTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func setupSearchTextField() {
        if let searchTextField = searchController.searchBar.searchTextField as UITextField? {
            let rightImageView = UIImageView()
            
            if let image = UIImage(systemName: "magnifyingglass.circle.fill") {
                rightImageView.image = image.withTintColor(.CustomPink, renderingMode: .alwaysTemplate).resizedImage(newSize: CGSize(width: 32, height: 32))
            } else {
                print("Image could not be loaded or resized")
            }
            
            rightImageView.contentMode = .scaleAspectFit
            
            searchTextField.rightView = rightImageView
            searchTextField.rightViewMode = .always // Or .never, .whileEditing, .unlessEditing
            
            searchTextField.leftView = UIView()
            searchTextField.leftViewMode = .always
        }
    }
    
    private func layout() {
        navigationItem.titleView = searchController.searchBar

        view.addSubview(safeAreaView)
        view.addSubview(homeTableView)
        hStack.addArrangedSubview(groupBtn)
        hStack.addArrangedSubview(airplaneTicketBtn)
        hStack.addArrangedSubview(bookingBtn)
        hStack.addArrangedSubview(independentTravelBtn)
        hStack.addArrangedSubview(couponBtn)
                
        homeTableView.tableHeaderView = hStack
        
        NSLayoutConstraint.activate([
            
            safeAreaView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            safeAreaView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            safeAreaView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            safeAreaView.bottomAnchor.constraint(equalTo: homeTableView.bottomAnchor),
            
            homeTableView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 0),
            homeTableView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 3),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: homeTableView.trailingAnchor, multiplier: 3),
            homeTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            hStack.leadingAnchor.constraint(equalTo: homeTableView.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: homeTableView.trailingAnchor),
            hStack.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        layout()
        let btn = UIButton()
    
        viewModel.delegate = self
        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        viewModel.isLoading = { [unowned self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self.spinner.show(in: view)
                } else {
                    self.spinner.dismiss()
                }
            }
        }
        
        viewModel.fetchAllData()
    }
    
    @objc private func groupBtnTapped() {
        print("click groupBtnTapped")
        
        let groupVC = LTGroupTravelViewController()
        navigationController?.pushViewController(groupVC, animated: true)
    }
}

//MARK: - HomeViewModel Delegate
extension HomeViewController: HomeViewModelDelegate {
    func homeViewModel(didReceiveData data: [any TabelViewCellViewModel]) {
        viewModel.items = data
        self.homeTableView.reloadData()
    }
    
    func homeViewModel(didReceiveError error: any Error) {
        print("\(error.localizedDescription)")
    }
}

//MARK: - HomeViewModel UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    //每個section內只有一列，用來放collectionView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = viewModel.items[indexPath.section]
        
        switch item.viewType {
            
        case .TopSelected:
            if let item = item as? SelectedTableViewCellViewModel, let cell = tableView.dequeueReusableCell(withIdentifier: TopSelectedTableViewCell.identifier, for: indexPath) as? TopSelectedTableViewCell {
                
                guard let adContents = item.adContents else { return TopSelectedTableViewCell() }
                
                cell.configure(with: adContents)
                cell.delegate = self
                
                return cell
            }
            
        case .TravelAtTime:
            if let item = item as? TravelAtTimeTabelViewCellViewModel, let cell = tableView.dequeueReusableCell(withIdentifier: TravelAtTimeTableViewCell.identifier, for: indexPath) as? TravelAtTimeTableViewCell {
                
                guard let adContents = item.adContents else { return TravelAtTimeTableViewCell() }
                cell.configure(with: adContents)
                
                return cell
            }
        case .TravelArrived:
            if let item = item as? TravelArrivedTabelViewCellViewModel, let cell = tableView.dequeueReusableCell(withIdentifier: TravelArrivedTableViewCell.identifier, for: indexPath) as? TravelArrivedTableViewCell {
                
                guard let adContents = item.adContents else { return TravelArrivedTableViewCell() }
                cell.configure(with: adContents)
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        return UITableView.automaticDimension

        let item = viewModel.items[indexPath.section]
        
        switch item.viewType {
        case .TopSelected:
            return 200
        case .TravelAtTime:
            return 400
        case .TravelArrived:
            return 500
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
                        
        let headerView = UIView()
        
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = UIImage(named: "\(viewModel.items[section].sectionImageName)")
        headerView.addSubview(icon)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.text = "\(viewModel.items[section].sectionTitle)"
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: -10),
            icon.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 28),
            icon.heightAnchor.constraint(equalToConstant: 28),
            
            label.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 5),
            label.centerYAnchor.constraint(equalTo: icon.centerYAnchor),            
        ])
        
        print("section: \(section)")
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        print("tableView section:\(indexPath.section) didSelectRowAt:\(indexPath.row)")
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("x:\(scrollView.contentOffset.y)")
        
        // 定義一個閥值，決定滑動多少距離後變色
        let threshold: CGFloat = 200.0
        
        let offsetY = scrollView.contentOffset.y
        
        // 依據滑動距離設定alpha值
        let alpha = min(0.7, max(0, offsetY / threshold))
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationBarAppearance.backgroundColor = UIColor.darkGray.withAlphaComponent(alpha)
        
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        setNeedsStatusBarAppearanceUpdate()
    }
}

extension HomeViewController: TopSelectedCellDelegate {
    func didRequestToShowDetail(forURL url: URL) {
        guard let nav = self.navigationController else {
            return
        }
        
        let adDetailVC = TravelDetailPreviewViewController(adUrl: url)
        nav.pushViewController(adDetailVC, animated: true)
    }
}
