//
//  SearchPresenter.swift
//  Imusic
//
//  Created by Роман Елфимов on 06.07.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - Presentation Logic Protocol

protocol SearchPresentationLogic {
    func presentData(response: Search.Model.Response.ResponseType)
}

// MARK: - Presenter

final class SearchPresenter {
    
    // MARK: - External vars
    weak var viewController: SearchDisplayLogic?
}

// MARK: - Presentation Logic Extension

extension SearchPresenter: SearchPresentationLogic {
    
    func presentData(response: Search.Model.Response.ResponseType) {
        
        switch response {
        case .presentTracks(let searchResults):
            
            let cells = searchResults?.results.map({ track in
                cellViewModel(from: track)
            }) ?? []
            
            let searchViewModel = TrackViewModel.init(cells: cells)
            viewController?.displayData(viewModel: .displayTracks(searchViewModel: searchViewModel))
            
        case .presentFooterView:
            viewController?.displayData(viewModel: .displayFooterView)
        }
    }
    
    // MARK: - Private Method
    
    private func cellViewModel(from track: Track) -> TrackViewModel.Cell {
        
        return TrackViewModel.Cell.init(identifre: "",
                                         iconUrlString: track.artworkUrl100,
                                         trackName: track.trackName,
                                         collectionName: track.collectionName ?? "",
                                         artistName: track.artistName,
                                         previewUrl: track.previewUrl)
    }
}
