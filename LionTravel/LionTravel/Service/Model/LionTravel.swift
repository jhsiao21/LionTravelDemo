//
//  LionTravel.swift
//  LionTravel
//
//  Created by LoganMacMini on 2024/4/3.
//

import Foundation

struct LionTravel: Decodable {
    let draftNo: String
    let draftType: Int
    let headTitle: String
    let limit: Int
    let tagData: [TagData]
    let draftData: [DraftData]

    enum CodingKeys: String, CodingKey {
        case draftNo = "DraftNo"
        case draftType = "DraftType"
        case headTitle = "HeadTitle"
        case limit = "Limit"
        case tagData = "TagData"
        case draftData = "DraftData"
    }
    
    var filteredDraftData: [DraftData] {
        //篩除draftPic是空值的情況
        return draftData.filter { $0.draftPic.isEmpty == false }
    }
}

struct TagData: Decodable {
    let tagNo: String
    let tagTitle: String
    let tagSort: Int

    enum CodingKeys: String, CodingKey {
        case tagNo = "TagNo"
        case tagTitle = "TagTitle"
        case tagSort = "TagSort"
    }
}

struct DraftData: Decodable {
    let draftInfoNo: String
    let tagNo: String
    let draftTitle: String
    let draftSubTitle: String
    let content: String
    let productTag: String?
    let price: String
    let draftPic: String
    let onlineDateTime: String
    let offlineDateTime: String
    let draftURL: String
    let targetBlank: Bool
    let draftSort: Int
    let highRecommend: Bool

    enum CodingKeys: String, CodingKey {
        case draftInfoNo = "DraftInfoNo"
        case tagNo = "TagNo"
        case draftTitle = "DraftTitle"
        case draftSubTitle = "DraftSubTitle"
        case content = "Content"
        case productTag = "ProductTag"
        case price = "Price"
        case draftPic = "DraftPic"
        case onlineDateTime = "OnlineDateTime"
        case offlineDateTime = "OfflineDateTime"
        case draftURL = "DraftURL"
        case targetBlank = "TargetBlank"
        case draftSort = "DraftSort"
        case highRecommend = "HighRecommend"
    }
}

