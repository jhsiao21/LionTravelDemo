//
//  LTAnchorMenuCollectionProtocol.swift
//  LionTravel
//
//  Created by Logan on 2024/5/15.
//

import UIKit

protocol LTAnchorMenuCollectionDataSource: AnyObject {
    
    ///Defines the number of buttons to be shown
    func numberOfButtonsToShow() -> Int
    
    ///Return the button for a specified index    
    func anchorMenuCollectionView(_ view: LTAnchorMenuCollectionView, cellForButtonAt index: Int) -> UIButton
    
    ///Defines the number of item to be shown
    func numberOfItemsInSection() -> Int
        
    func anchorMenuCollectionView(_ view: LTAnchorMenuCollectionView, cellForItemAt index: Int) -> UICollectionViewCell
    
}

protocol LTAnchorMenuCollectionDelegate: AnyObject {
    
    func button(didSelect view: UIButton, at index: Int)
    
    func collectionView(didSelectItemAt index: Int)
}
