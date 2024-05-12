//
//  APIClient.swift
//  LionTravel
//
//  Created by LoganMacMini on 2024/4/1.
//

import Foundation
import UIKit

class APIClient {
    
    static let shared = APIClient()
    
    private init() {}
    
    func fetchAllData(completion: @escaping (Result<[TabelViewCellViewModel], Error>) -> Void) {
        var items: [TabelViewCellViewModel] = []
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {  //模擬API延遲
            DataLoader.shared.loadLocalJSONData(from: Constant.localJSONURL, completion: { result in
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let data):
                    //用篩選過的filteredDraftData
                    let collectionViewModel = SelectedTableViewCellViewModel(travelData: data)
                    items.append(collectionViewModel)
                case .failure(let error):
                    completion(.failure(error))
                    print("Failed to fetch upcoming movies: \(error.localizedDescription)")
                }
            })
        }
        
        dispatchGroup.enter()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.fetchTravelAtTimeImages { result in
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let images):
                    let collectionViewModel = TravelAtTimeTabelViewCellViewModel(images: images)
                    items.append(collectionViewModel)
                case .failure(let error):
                    completion(.failure(error))
                    print("Failed to fetch upcoming movies: \(error.localizedDescription)")
                }
            }
        }
        
        dispatchGroup.enter()        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.fetchTravelArrivedImages { result in
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let images):
                    let collectionViewModel = TravelArrivedTabelViewCellViewModel(images: images)
                    items.append(collectionViewModel)
                case .failure(let error):
                    completion(.failure(error))
                    print("Failed to fetch upcoming movies: \(error.localizedDescription)")
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(.success(items))
        }
    }
    
    func fetchSelectImages(completion: @escaping (Result<[UIImage], Error>) -> Void) {
        let imageNames = (0...3).map { "select_\($0)" }
        
        let images = imageNames.compactMap { UIImage(named: $0) }
        
        if images.count == imageNames.count {
            completion(.success(images))
        } else {
            let error = NSError(domain: "com.Logan.Lab.LionTravel", code: 1001, userInfo: [NSLocalizedDescriptionKey: "One or more images could not be loaded."])
            completion(.failure(error))
        }
    }
    
    func fetchTravelAtTimeImages(completion: @escaping (Result<[UIImage], Error>) -> Void) {
        let imageNames = (0...23).map { "travelAtTime_\($0)" }
        
        let images = imageNames.compactMap { UIImage(named: $0) }
        
        if images.count == imageNames.count {
            completion(.success(images))
        } else {
            let error = NSError(domain: "com.Logan.Lab.LionTravel", code: 1001, userInfo: [NSLocalizedDescriptionKey: "One or more images could not be loaded."])
            completion(.failure(error))
        }
    }
    
    func fetchTravelArrivedImages(completion: @escaping (Result<[UIImage], Error>) -> Void) {
        let imageNames = (0...3).map { "travelArrived_\($0)" }
        
        let images = imageNames.compactMap { UIImage(named: $0) }
        
        if images.count == imageNames.count {
            completion(.success(images))
        } else {
            let error = NSError(domain: "com.Logan.Lab.LionTravel", code: 1001, userInfo: [NSLocalizedDescriptionKey: "One or more images could not be loaded."])
            completion(.failure(error))
        }
    }
}
