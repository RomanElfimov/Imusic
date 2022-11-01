//
//  ChartsDetailInteractor.swift
//  Imusic
//
//  Created by Роман Елфимов on 04.09.2022.
//

import Foundation

// MARK: - Business Logic Protocol

protocol ChartsDetailBusinessLogic {
    func makeRequest(event: ChartsDetail.Model.Request.RequestType)
}

// MARK: - Store Protocol

protocol ChartsDetailStoreProtocol: AnyObject {
    var id: String { get set }
    var chartName: String { get set }
}

// MARK: - Interactor

final class ChartsDetailInteractor: ChartsDetailStoreProtocol {
    
    var id: String = ""
    var chartName: String = ""
    var presenter: ChartsDetailPresentationLogic?
    
    private var networkService = NetworkService()
}

// MARK: - Business Logic Extension

extension ChartsDetailInteractor: ChartsDetailBusinessLogic {
    func makeRequest(event: ChartsDetail.Model.Request.RequestType) {
        switch event {
            
        case .fetchTracks:
            // Плейлист
            if id.contains("pl.") {
                networkService.fetchPlaylist(id: id) { [weak self] result in
                    guard let result = result else { return }
                    self?.presenter?.presentData(event: .presentTracks(data: result))
                }
            
            } else {
                // Альбом
                networkService.fetchAlbums(id: id) { [weak self] result in
                    guard let result = result else { return }
                    self?.presenter?.presentData(event: .presentTracks(data: result))
                }
            }
            
        case .fetchChartName:
            presenter?.presentData(event: .presentChartName(with: chartName))
        }
    }
}
