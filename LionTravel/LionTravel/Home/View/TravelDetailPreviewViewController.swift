import UIKit
import WebKit

class TravelDetailPreviewViewController: UIViewController, UIScrollViewDelegate {
    
    private let adUrl: URL
        
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        return webView
    }()
    
    init(adUrl: URL) {
        self.adUrl = adUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
                        
        layout()
        setupNavigationBarAppearance()
        
        DispatchQueue.main.async {
            self.show()
        }
    }
    
    func layout() {
        
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBarAppearance() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = UIColor.CustomPink
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.isTranslucent = false
    }
    
    public func show() {
        webView.load(URLRequest(url: adUrl))
        
//        let url = URL(string: "https://www.google.com")
//        webView.load(URLRequest(url: url!))
    }
}
