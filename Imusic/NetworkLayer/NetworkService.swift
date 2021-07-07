//
//  NetworkService.swift
//  Imusic
//
//  Created by Роман Елфимов on 06.07.2021.
//

import UIKit
import Alamofire

class NetworkService {
    
    func fetchTracks(searchText: String, completion: @escaping(SearchResponse?) -> Void) {
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
                print("objects", objects)
                completion(objects)
                
//                self.tracks = objects.results
//                self.tableView.reloadData()
                
            } catch let jsonError {
                print("Failed to decode json", jsonError)
                completion(nil)
            }
            
            
        }
    }
    
}
