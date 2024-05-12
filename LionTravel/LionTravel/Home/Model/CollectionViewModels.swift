//
//  TabelViewCellViewModel.swift
//  LionTravel
//
//  Created by LoganMacMini on 2024/4/4.
//

import UIKit

protocol TabelViewCellViewModel {
    var viewType: CollectionViewType { get }
    var sectionTitle: String { get }
    var sectionImageName: String { get }
    var dataCount: Int { get }
    var adContents: [AdContent]? { get }
    var travelData: LionTravel? { get }
}

struct SelectedTableViewCellViewModel: TabelViewCellViewModel {
        
    var viewType: CollectionViewType {
        return .TopSelected
    }
    
    var sectionTitle: String {
        guard let headTitle = travelData?.headTitle else { return "人氣嚴選旅"}
        return headTitle
    }
    
    var sectionImageName: String {
        return "section_icon_0"
    }
    
    var dataCount: Int {
        guard let count = travelData?.draftData.count else { return 0}
        return count
    }
    
    var adContents: [AdContent]?
    
    var travelData: LionTravel?
    
    init(travelData: LionTravel?) {
        self.travelData = travelData
    }
        
    init(adContents: [AdContent]) {
        self.adContents = adContents.map { adContent in
            AdContent(image: adContent.image, link: adContent.link)
        }
    }
}

struct TravelAtTimeTabelViewCellViewModel: TabelViewCellViewModel {
        
    var viewType: CollectionViewType {
        return .TravelAtTime
    }
    
    var sectionTitle: String {
        guard let headTitle = travelData?.headTitle else { return "旅遊正當時"}
        return headTitle
    }
    
    var sectionImageName: String {
        return "section_icon_1"
    }
    
    var dataCount: Int {
        guard let count = travelData?.draftData.count else { return 0}
        return count
    }
    
    var adContents: [AdContent]?
    
    var travelData: LionTravel?
    
    init(travelData: LionTravel?) {
        self.travelData = travelData
    }
        
    init(images: [UIImage]) {
        self.adContents = images.map { image in
            AdContent(image: image, link: nil)
        }
    }
}

struct TravelArrivedTabelViewCellViewModel: TabelViewCellViewModel {
        
    var viewType: CollectionViewType {
        return .TravelArrived
    }
        
    var sectionTitle: String {
        guard let headTitle = travelData?.headTitle else { return "旅遊直達"}
        return headTitle
    }
    
    var sectionImageName: String {
        return "section_icon_1"
    }
    
    var dataCount: Int {
        guard let count = travelData?.draftData.count else { return 0}
        return count
    }
    
    var adContents: [AdContent]?
    
    var travelData: LionTravel?
    
    init(travelData: LionTravel?) {
        self.travelData = travelData
    }
        
    init(images: [UIImage]) {
        self.adContents = images.map { image in
            AdContent(image: image, link: nil)
        }
    }
}
