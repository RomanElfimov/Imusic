//
//  SearchModels.swift
//  Imusic
//
//  Created by Роман Елфимов on 06.07.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Search {
    
    enum Model {
        struct Request {
            enum RequestType {
                case getTracks(searchTerm: String)
            }
        }
        struct Response {
            enum ResponseType {
                case presentTracks(searchResponse: SearchResponse?)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayTracks(searchViewModel: SearchViewModel)
            }
        }
    }
    
}




struct SearchViewModel {
    struct Cell: TrackCellViewModel {
        var iconUrlString: String?
        var trackName: String
        var collectionName: String
        var artistName: String
        
        var previewUrl: String?
    }
    
    let cells: [Cell]
}
