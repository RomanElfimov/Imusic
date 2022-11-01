//
//  Charts.swift
//  Imusic
//
//  Created by Роман Елфимов on 03.09.2022.
//

import Foundation

// MARK: - Charts
struct Charts: Decodable {
    let results: ChartsResults
}

// MARK: - ChartsResults
struct ChartsResults: Decodable {
    let songs, playlists, albums: [Album]
}

// MARK: - Album
struct Album: Decodable {

    let name: String?
    let data: [Datum]?
}

// MARK: - Datum
struct Datum: Hashable, Decodable {
    let id: String
    let attributes: Attributes?
    
    static func == (lhs: Datum, rhs: Datum) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Attributes
struct Attributes: Decodable, Hashable {
      
    let artwork: Artwork
    let artistName: String?
    let curatorName: String?
    let url: String
    let name: String?
    let playParams: PlayParams
    let previews: [Preview]?
    let albumName: String?

    static func == (lhs: Attributes, rhs: Attributes) -> Bool {
        return lhs.url == rhs.url
    }
}

struct PlayParams: Decodable, Hashable {
    let id: String
    
    static func == (lhs: PlayParams, rhs: PlayParams) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Artwork
struct Artwork: Decodable, Hashable {
    let width, height: Int?
    let url: String?
   
    static func == (lhs: Artwork, rhs: Artwork) -> Bool {
        return lhs.url == rhs.url
    }
}

// MARK: - Preview
struct Preview: Decodable, Hashable {
    let url: String
}
