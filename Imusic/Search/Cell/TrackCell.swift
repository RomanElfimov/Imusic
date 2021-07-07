//
//  TrackCell.swift
//  Imusic
//
//  Created by Роман Елфимов on 06.07.2021.
//

import UIKit
import SDWebImage

protocol TrackCellViewModel {
    var iconUrlString: String? { get }
    var trackName: String { get }
    var artistName: String { get }
    var collectionName: String { get }
}

class TrackCell: UITableViewCell {
    
    static let reuseId = "TrackCell"
    
    @IBOutlet weak var trackImageView: UIImageView!
  
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func prepareForReuse() {
        trackImageView.image = nil
    }
    
    
    func setup(viewModel: TrackCellViewModel) {
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionNameLabel.text = viewModel.collectionName
        
        // Work with SDWebImage
        guard let url = URL(string: viewModel.iconUrlString ?? "") else { return }
        trackImageView.sd_setImage(with: url, completed: nil)
    }
}
