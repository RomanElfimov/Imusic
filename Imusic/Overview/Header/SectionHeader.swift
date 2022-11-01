//
//  SectionHeader.swift
//  Imusic
//
//  Created by Роман Елфимов on 02.09.2022.
//

import UIKit

final class SectionHeader: UICollectionReusableView {
    
    // MARK: - Reuse Id
    
    static let reuseId = "SectionHeader"
    
    // MARK: - Properties
    
    private let title: UILabel = {
        let label = UILabel()
        label.text = "ПОПгророр"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(title)
        title.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, paddingLeft: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    public func configurate(text: String) {
        title.text = text
    }
    
}
