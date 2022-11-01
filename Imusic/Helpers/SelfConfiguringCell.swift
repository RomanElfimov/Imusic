//
//  SelfConfiguringCell.swift
//  Imusic
//
//  Created by Роман Елфимов on 01.09.2022.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseId: String { get }
    func configure<U: Hashable>(with value: U, indexPath: Int)
}
