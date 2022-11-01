//
//  OverviewPresenter.swift
//  Imusic
//
//  Created by Роман Елфимов on 31.08.2022.
//

import Foundation

// MARK: - Presentation Logic Protocol

protocol OverviewPresentationLogic {
    func presentData(event: Overview.Model.Response.ResponseType)
}

// MARK: - Presenter

final class OverviewPresenter {
    weak var viewController: OverviewDisplayLogic?
    
    private func configureViewModel(with model: Datum) -> TrackViewModel.Cell {
    
        let emptyModel = TrackViewModel.Cell(identifre: "", iconUrlString: "", trackName: "", collectionName: "", artistName: "", previewUrl: "")
       
        guard let song = model.attributes else { return emptyModel }

        let iconURL = song.artwork.url?.replacingOccurrences(of: "{w}", with: "\(song.artwork.width ?? 0)").replacingOccurrences(of: "{h}", with: "\(song.artwork.height ?? 0)")
        let viewModel = TrackViewModel.Cell(identifre: model.id,
                                             iconUrlString: iconURL,
                                             trackName: song.name ?? "",
                                             collectionName: song.albumName ?? "",
                                             artistName: song.artistName ?? song.curatorName ?? "",
                                             previewUrl: song.previews?[0].url)
        return viewModel
    }
}

// MARK: - Presentation Logic Extension

extension OverviewPresenter: OverviewPresentationLogic {
    func presentData(event: Overview.Model.Response.ResponseType) {
        switch event {
        case .presentCharts(let response):
            
            let songsArray = response.results.songs[0].data ?? []
            let playlistsArray = response.results.playlists[0].data ?? []
            let albumsArray = response.results.albums[0].data ?? []
            
            let songsViewModel = songsArray.map { model -> TrackViewModel.Cell in
                let viewModel = configureViewModel(with: model)
                return viewModel
            }
            
            let playlistsViewModel = playlistsArray.map { model -> TrackViewModel.Cell in
                let viewModel = configureViewModel(with: model)
                return viewModel
            }
            
            let albumsViewModel = albumsArray.map { model -> TrackViewModel.Cell in
                let viewModel = configureViewModel(with: model)
                return viewModel
            }
            
            viewController?.displayData(event: .displaySongs(data: songsViewModel))
            viewController?.displayData(event: .displayPlaylists(data: playlistsViewModel))
            viewController?.displayData(event: .displayAlbums(data: albumsViewModel))
            
        case .showAlert:
            viewController?.displayData(event: .showAlert)
        }
    }
}
