//
//  LTAnchorMenuProtocol.swift
//  LionTravel
//
//  Created by Logan on 2024/5/13.
//

import UIKit

protocol AnchorMenuDataSource: AnyObject {
    
    ///Defines the number of buttons to be shown
    func numberOfButtonsToShow() -> Int
    
    ///Return the button for a specified index
    func button(at index: Int) -> UIButton?
}

protocol AnchorMenuDelegate: AnyObject {
    func button(didSelect view: UIButton, at index: Int)
}

