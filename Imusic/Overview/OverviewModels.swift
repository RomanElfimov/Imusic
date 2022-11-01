//
//  OverviewModels.swift
//  Imusic
//
//  Created by Роман Елфимов on 31.08.2022.
//

import Foundation

enum Overview {
    
    enum Model {
        struct Request {
            enum RequestType {
                case getCharts
                case showAlert
            }
        }
        
        struct Response {
            enum ResponseType {
                case presentCharts(data: Charts)
                case showAlert
            }
        }
        
        struct ViewModel {
            enum ViewModelData {
                case displaySongs(data: [TrackViewModel.Cell])
                case displayPlaylists(data: [TrackViewModel.Cell])
                case displayAlbums(data: [TrackViewModel.Cell])
                case showAlert
            }
        }
        
        struct Routing {
            enum RoutingType {
                case navigateToDetail(id: String, title: String)
            }
        }
    }
}
