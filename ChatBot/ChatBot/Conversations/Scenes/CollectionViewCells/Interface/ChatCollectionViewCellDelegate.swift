//
//  ChatCollectionViewCellDelegate.swift
//  ChatBot
//
//  Created by Kim EenSung on 4/9/24.
//

import Foundation

protocol ChatCollectionViewCellDelegate: AnyObject {
    func tapRefreshButton(_ chatCollectionViewCell: ChatCollectionViewCell)
}
