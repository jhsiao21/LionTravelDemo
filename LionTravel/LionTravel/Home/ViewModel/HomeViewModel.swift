//
//  HomeViewModel.swift
//  LionTravel
//
//  Created by LoganMacMini on 2024/4/1.
//

import UIKit
import SDWebImage

protocol HomeViewModelDelegate: AnyObject {
    func homeViewModel(didReceiveData data: [TabelViewCellViewModel])
    func homeViewModel(didReceiveError error: Error)
}

final class HomeViewModel {
    
    var isLoading: ((Bool) -> Void)?
    
    var items: [TabelViewCellViewModel] = []
    
    weak var delegate: HomeViewModelDelegate?
    
       
    func fetchAllData() {
        isLoading?(true)
        
        APIClient.shared.fetchAllData { [weak self] result in
            var collectionViewModels: [TabelViewCellViewModel] = []
            
            switch result {
                
            case .success(let viewModels):
                
                let group = DispatchGroup()
                
                viewModels.forEach { viewModel in
                    guard let travelData = viewModel.travelData else {
                        collectionViewModels.append(viewModel) //旅遊正當時、旅遊直達沒有travelData，會直接加進來
                        return
                    }
                    
                    //篩選json資料內的DraftPic是不是有效圖片
                    group.enter()
                    self?.filterDraftData(with: travelData.draftData) { adContents in
                        let selectViewModel = SelectedTableViewCellViewModel(adContents: adContents)
                        collectionViewModels.append(selectViewModel)
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    collectionViewModels = collectionViewModels.sorted { (item1, item2) -> Bool in
                        //排序要顯示的collectin view model
                        return item1.viewType.rawValue < item2.viewType.rawValue
                    }
                    
                    self?.delegate?.homeViewModel(didReceiveData: collectionViewModels)
                }
                
            case .failure(let failure):
                print("\(failure.localizedDescription)")
                self?.delegate?.homeViewModel(didReceiveError: failure)
            }
            self?.isLoading?(false)
        }
    }
    
    func filterDraftData(with draftData: [DraftData], completion: @escaping ([AdContent]) -> Void) {
        var adContents: [AdContent] = []
        let dispatchGroup = DispatchGroup()
        
        draftData.forEach { data in
            if let imgUrl = URL(string: data.draftPic){
                dispatchGroup.enter()
                
                print(imgUrl)
                loadImageFromURL(imgUrl) { image, error  in
                    if let error = error {
                        print("Error loading \(imgUrl), errMsg: \(error.localizedDescription)")
                    } else if let image = image {
                        let adObject = AdContent(image: image, link: URL(string: data.draftURL))
                        adContents.append(adObject)
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(adContents)
        }
    }


    func loadImageFromURL(_ url: URL, completion: @escaping (UIImage?, Error?) -> Void) {
        
        // 使用SDWebImage的sd_setImage方法
        //        UIImageView().sd_setImage(with: url, completed: { (image, error, cacheType, imageURL) in
        //            completion(image, error)
        //        })
        
        SDWebImageManager.shared.loadImage(with: url, options: [], progress: nil) { image, data, error, _, _, _ in
            if let error = error {
                completion(nil, error)
            } else if let image = image {
                completion(image, nil)
            }
        }
    }
}
