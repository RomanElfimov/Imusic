//
//  NetworkService.swift
//  Imusic
//
//  Created by Роман Елфимов on 06.07.2021.
//

import UIKit
import Alamofire
import StoreKit

final class NetworkService {
    
    private let developerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiIsImtpZCI6IjhQOEZBMzJKMzMifQ.eyJpc3MiOiJTNTlIWVkzTDVDIiwiZXhwIjoxNjc3NjM4NDU3LCJpYXQiOjE2NjE4NzA0NTd9.9aJbldk3UzBUXqs3NQeFmjP5c8Roou2_SjzhxOqq-UvMTtDm_9ANaHHn7FtoZosXZgU-prhQNJAPWbw20cATJw"
    
    private func getUserToken() -> String {
        let controller = SKCloudServiceController()
        var userToken = ""
        
        controller.requestUserToken(forDeveloperToken: developerToken) { token, _ in
            
            guard let token = token else { return }
            userToken = token
        }
        
        return userToken
    }
    
    public func fetchTracks(searchText: String, completion: @escaping(SearchResponse?) -> Void) {
        let url = "https://itunes.apple.com/search"
        let parameters = ["term": "\(searchText)",
                          "limit": "50",
                          "media": "music"]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { dataResponse in
            if let error = dataResponse.error {
                print("Error received requesting data \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = dataResponse.data else { return }
            let decoder = JSONDecoder()
            do {
                let objects = try decoder.decode(SearchResponse.self, from: data)
                completion(objects)
            } catch let jsonError {
                print("Failed to decode json", jsonError)
                completion(nil)
            }
            
        }
    }
    
    public func fetchCharts(completion: @escaping(Charts?) -> Void) {
        let url = "https://api.music.apple.com/v1/catalog/ru/charts?types=songs,albums,playlists&limit=20"
        
        let developerHeader = HTTPHeader(name: "Authorization", value: "Bearer \(developerToken)")
        let userHeader = HTTPHeader(name: "Music-User-Token", value: getUserToken())
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: [developerHeader, userHeader]).responseData { dataResponse in
            
            if let error = dataResponse.error {
                print("Error received requesting data \(error.localizedDescription)")
                return
            }
            
            guard let data = dataResponse.data else { return }
            let decoder = JSONDecoder()
            do {
                let objects = try decoder.decode(Charts.self, from: data)
                completion(objects)
            } catch let jsonError {
                print("Failed to decode json", jsonError)
                completion(nil)
            }
        }
    }
    
    public func fetchPlaylist(id: String, completion: @escaping(Playlist?) -> Void) {
        let url = "https://api.music.apple.com/v1/catalog/ru/playlists/\(id)"
        
        let developerHeader = HTTPHeader(name: "Authorization", value: "Bearer \(developerToken)")
        let userHeader = HTTPHeader(name: "Music-User-Token", value: getUserToken())
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: [developerHeader, userHeader]).responseData { dataResponse in
            
            if let error = dataResponse.error {
                print("Error received requesting data \(error.localizedDescription)")
                return
            }
            
            guard let data = dataResponse.data else { return }
            let decoder = JSONDecoder()
            do {
                let objects = try decoder.decode(Playlist.self, from: data)
                completion(objects)
            } catch let jsonError {
                print("Failed to decode json", jsonError)
                completion(nil)
            }
        }
    }
    
    public func fetchAlbums(id: String, completion: @escaping(Playlist?) -> Void) {
        let url = "https://api.music.apple.com/v1/catalog/ru/albums/\(id)"
        
        let developerHeader = HTTPHeader(name: "Authorization", value: "Bearer \(developerToken)")
        let userHeader = HTTPHeader(name: "Music-User-Token", value: getUserToken())
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: [developerHeader, userHeader]).responseData { dataResponse in
            
            if let error = dataResponse.error {
                print("Error received requesting data \(error.localizedDescription)")
                return
            }
            
            guard let data = dataResponse.data else { return }
            let decoder = JSONDecoder()
            do {
                let objects = try decoder.decode(Playlist.self, from: data)
                completion(objects)
            } catch let jsonError {
                print("Failed to decode json", jsonError)
                completion(nil)
            }
        }
    }
    
}
