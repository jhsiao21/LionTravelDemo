//
//  CollectionViewType.swift
//  LionTravel
//
//  Created by LoganMacMini on 2024/4/1.
//

import Foundation

enum CollectionViewType: Int, Codable {
    case TopSelected = 0
    case TravelAtTime = 1
    case TravelArrived = 2
}

enum TravelAtTimeType: Int, CaseIterable {
    case Booking = 0
    case DiscountTicket = 1
    case IndependentTravel = 2
    case Coupon = 3
    case TrailTravel = 4
    case GroupTravel = 5
    
    var caseDescription: String {
        switch self {
        case .Booking:
            return "訂房熱銷"
        case .DiscountTicket:
            return "特惠機票"
        case .IndependentTravel:
            return "精選自由行"
        case .Coupon:
            return "國外票券"
        case .TrailTravel:
            return "鐵道旅遊"
        case .GroupTravel:
            return "團體旅遊"
        }
    }
}
