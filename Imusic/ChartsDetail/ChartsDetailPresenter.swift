//
//  ChartsDetailPresenter.swift
//  Imusic
//
//  Created by Роман Елфимов on 04.09.2022.
//

import Foundation

// MARK: - Presentation Logic Protocol

protocol ChartsDetailPresentationLogic {
    func presentData(event: ChartsDetail.Model.Response.ResponseType)
}

// MARK: - Presenter

final class ChartsDetailPresenter {
    weak var viewController: ChartsDetailDisplayLogic?
    
    private func configureViewModel(with model: CuratorDatum) -> TrackViewModel.Cell {
        let emptyModel = TrackViewModel.Cell(identifre: "", iconUrlString: "", trackName: "", collectionName: "", artistName: "", previewUrl: "")
       
        guard let song = model.attributes else { return emptyModel }

        let iconURL = song.artwork.url?.replacingOccurrences(of: "{w}", with: "\(song.artwork.width ?? 0)").replacingOccurrences(of: "{h}", with: "\(song.artwork.height ?? 0)")
        let viewModel = TrackViewModel.Cell(identifre: model.id,
                                             iconUrlString: iconURL,
                                             trackName: song.name,
                                             collectionName: song.albumName,
                                             artistName: song.artistName,
                                             previewUrl: song.previews[0].url)
        return viewModel
    }
}

// MARK: - Presentation Logic Extension

extension ChartsDetailPresenter: ChartsDetailPresentationLogic {
    func presentData(event: ChartsDetail.Model.Response.ResponseType) {
        switch event {
        case .presentTracks(let response):

            let responseArray = response.data?[0].relationships.tracks.data ?? []
            
            let viewModel = responseArray.map { model -> TrackViewModel.Cell in
                let vm = configureViewModel(with: model)
                return vm
            }
            
            viewController?.displayData(event: .displayTracks(data: viewModel))
            
        case .presentChartName(let title):
            viewController?.displayData(event: .displayChartName(with: title))
        }
    }
}
