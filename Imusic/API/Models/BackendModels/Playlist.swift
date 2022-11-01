//
//  Playlist.swift
//  Imusic
//
//  Created by Роман Елфимов on 03.09.2022.
//

import Foundation

// MARK: - Playlist
struct Playlist: Decodable {
    let data: [PlaylistDatum]?
}

// MARK: - PlaylistDatum
struct PlaylistDatum: Decodable {
    let relationships: Relationships
}

// MARK: - Relationships
struct Relationships: Decodable {
    let tracks: Curator
}

// MARK: - Curator
struct Curator: Decodable {
    let data: [CuratorDatum]?
}

// MARK: - CuratorDatum
struct CuratorDatum: Decodable {
    let id: String
    let attributes: FluffyAttributes?
}

// MARK: - FluffyAttributes
struct FluffyAttributes: Decodable {
    let albumName: String
    let artwork: Artwork
    let name: String
    let previews: [Preview]
    let artistName: String
}
