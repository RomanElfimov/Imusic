//
//  SongsCollectionViewCell.swift
//  Imusic
//
//  Created by Роман Елфимов on 01.09.2022.
//

import UIKit

final class SongsCollectionViewCell: UICollectionViewCell, SelfConfiguringCell {
     
    // MARK: - Reuse Id
    
    static var reuseId: String = "SongsCell"
    
    // MARK: - Properties
    
    private var cell: TrackViewModel.Cell?
    
    private let trackImageView = UIImageView()
    
    private lazy var trackNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var collectionNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var addSongButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Add")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor.init(cgColor: #colorLiteral(red: 0.9369474649, green: 0.3679848909, blue: 0.426604867, alpha: 1))), for: .normal)
        button.addTarget(self, action: #selector(addSongButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .systemGray5 : .systemBackground
        }
    }
    
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
        guard let song: TrackViewModel.Cell = value as? TrackViewModel.Cell else { return }
        self.cell = song
        
        // Скрываем кнопку плюса
        let savedTracks = UserDefaults.standard.savedTracks()
        let hasFavourite = savedTracks.firstIndex(where: {
            $0.trackName == self.cell?.trackName && $0.artistName == self.cell?.artistName
        }) != nil
        if hasFavourite {
             addSongButton.isHidden = true
        } else {
            addSongButton.isHidden = false
        }
        
        // Track Image
        guard let artworkUrl = URL(string: song.iconUrlString ?? "") else { return }
        trackImageView.sd_setImage(with: artworkUrl)
        
        // Track Info
        trackNameLabel.text = song.trackName
        artistNameLabel.text = song.artistName
        collectionNameLabel.text = song.collectionName
    }
    
    private func setupConstraints() {
        
        contentView.addSubview(addSongButton)
        
        // Track Image
        addSubview(trackImageView)
        trackImageView.setDimensions(width: 50, height: 50)
        trackImageView.centerY(inView: contentView)
        trackImageView.anchor(left: leftAnchor, paddingLeft: 4)
        
        // Track Info
        let stackView = UIStackView(arrangedSubviews: [trackNameLabel, artistNameLabel, collectionNameLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: trackImageView.rightAnchor, bottom: bottomAnchor, right: addSongButton.leftAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 4)
        
        // Add Button
        addSongButton.setDimensions(width: 50, height: 50)
        addSongButton.centerY(inView: contentView)
        addSongButton.anchor(right: rightAnchor, paddingRight: 8)
    }
    
    @objc func addSongButtonTapped() {
        let defaults = UserDefaults.standard
        guard let cell = cell else { return }
        addSongButton.isHidden = true
        
        var listOfTracks = defaults.savedTracks()
        
        listOfTracks.append(cell)
        
        // Сохраняем в userDefaults кастомный тип
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: listOfTracks, requiringSecureCoding: false) {
            defaults.set(savedData, forKey: "favouriteTrackKey")
        }
    }
}
