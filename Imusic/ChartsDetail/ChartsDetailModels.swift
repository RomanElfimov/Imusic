//
//  ChartsDetailModels.swift
//  Imusic
//
//  Created by Роман Елфимов on 04.09.2022.
//

import Foundation

enum ChartsDetail {
    enum Model {
        
        struct Request {
            enum RequestType {
                case fetchTracks
                case fetchChartName
            }
        }
        
        struct Response {
            enum ResponseType {
                case presentTracks(data: Playlist)
                case presentChartName(with: String)
            }
        }
        
        struct ViewModel {
            enum ViewModelData {
                case displayTracks(data: [TrackViewModel.Cell])
                case displayChartName(with: String)
            }
        }
    }
}
