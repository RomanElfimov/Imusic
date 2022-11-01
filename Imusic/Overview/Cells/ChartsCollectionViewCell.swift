//
//  ChartsCollectionViewCell.swift
//  Imusic
//
//  Created by Роман Елфимов on 01.09.2022.
//

import UIKit

final class ChartsCollectionViewCell: UICollectionViewCell, SelfConfiguringCell {
    
    // MARK: - Reuse Id
    
    static var reuseId: String = "ChartsCell"
    
    // MARK: - Properties
    
    private let chartImageView = UIImageView()
    
    private lazy var chartNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        return label
    }()
    
    private lazy var chartNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var chartCuratorNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    public func configure<U>(with value: U, indexPath: Int) where U: Hashable {
        guard let chart: TrackViewModel.Cell = value as? TrackViewModel.Cell else { return }
        
        guard let artworkUrl = URL(string: chart.iconUrlString ?? "") else { return }
        chartImageView.sd_setImage(with: artworkUrl)
        chartNumberLabel.text = "\(indexPath + 1)"
        chartNameLabel.text = chart.trackName
    
        chartCuratorNameLabel.text = chart.artistName // альбомы
    }
    
    private func setupConstraints() {
        // Track Image
       addSubview(chartImageView)
        chartImageView.anchor(top: topAnchor, left: leftAnchor)
        chartImageView.setDimensions(width: contentView.frame.width, height: contentView.frame.width)
        
        let infoStack = UIStackView(arrangedSubviews: [chartNumberLabel, chartNameLabel, chartCuratorNameLabel])
        infoStack.axis = .vertical
        infoStack.distribution = .fillProportionally
        infoStack.spacing = 4
        addSubview(infoStack)
        infoStack.anchor(top: chartImageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingBottom: 8)
    }
}
