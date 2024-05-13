//
//  LTButtonMenuView.swift
//  LionTravel
//
//  Created by Logan on 2024/5/10.
//

enum LTButtonMenuEnum: Int, CaseIterable {
    case GroupTravel = 0
    case DiscountTicket = 1
    case IndependentTravel = 2
    case Booking = 3
    case TrailTravel = 4
    case Coupon = 5
    
    var caseDescription: String {
        switch self {
        case .Booking:
            return "訂房"
        case .DiscountTicket:
            return "特惠機票"
        case .IndependentTravel:
            return "自由行"
        case .Coupon:
            return "海外票券"
        case .TrailTravel:
            return "鐵道旅遊"
        case .GroupTravel:
            return "團體旅遊"
        }
    }
}
