//
//  TrackViewModel.swift
//  Imusic
//
//  Created by Роман Елфимов on 31.08.2022.
//

import Foundation

// class - потому что потом нужно будет сохранять ее в userDefaults, так же подпишемся под NSObject и NSCoding

class TrackViewModel: NSObject, NSCoding {
    
    @objc(_TtCC6Imusic15SearchViewModel4Cell)class Cell: NSObject, NSCoding, Identifiable {
    
        var id = UUID() // swiftui property
        var identifre: String
        var iconUrlString: String?
        var trackName: String
        var collectionName: String
        var artistName: String
        
        var previewUrl: String?
        
        init(identifre: String, iconUrlString: String?, trackName: String, collectionName: String, artistName: String, previewUrl: String?) {
            self.identifre = identifre
            self.iconUrlString = iconUrlString
            self.trackName = trackName
            self.collectionName = collectionName
            self.artistName = artistName
            self.previewUrl = previewUrl
        }
        
        // NSObject и NSCoding для Cell
        func encode(with coder: NSCoder) {
            coder.encode(identifre, forKey: "identifre")
            coder.encode(iconUrlString, forKey: "iconUrlString")
            coder.encode(trackName, forKey: "trackName")
            coder.encode(collectionName, forKey: "collectionName")
            coder.encode(artistName, forKey: "artistName")
            coder.encode(previewUrl, forKey: "previewUrl")
        }
        
        required init?(coder: NSCoder) {
            identifre = coder.decodeObject(forKey: "identifre") as? String ?? ""
            iconUrlString = coder.decodeObject(forKey: "iconUrlString") as? String? ?? ""
            trackName = coder.decodeObject(forKey: "trackName") as? String ?? ""
            collectionName = coder.decodeObject(forKey: "collectionName") as? String ?? ""
            artistName = coder.decodeObject(forKey: "artistName") as? String ?? ""
            previewUrl = coder.decodeObject(forKey: "previewUrl") as? String? ?? ""
        }
    }
    
    init(cells: [Cell]) {
        self.cells = cells
    }
    
    let cells: [Cell]
    
    // NSObject и NSCoding для SearchViewModel
    func encode(with coder: NSCoder) {
        coder.encode(cells, forKey: "cells")
    }
    
    required init?(coder: NSCoder) {
        // Какого типа свойство cells
        cells = coder.decodeObject(forKey: "cells") as? [TrackViewModel.Cell] ?? []
    }
}
