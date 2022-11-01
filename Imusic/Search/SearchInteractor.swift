//
//  SearchInteractor.swift
//  Imusic
//
//  Created by Роман Елфимов on 06.07.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - Business Logic Protocol

protocol SearchBusinessLogic {
    func makeRequest(request: Search.Model.Request.RequestType)
}

// MARK: - Interactor

final class SearchInteractor {
    
    // MARK: - External vars
    var presenter: SearchPresentationLogic?
    
    // MARK: - Internal vars
    private var networkService = NetworkService()
}

// MARK: - Business Logic Extension

extension SearchInteractor: SearchBusinessLogic {
    func makeRequest(request: Search.Model.Request.RequestType) {
        
        switch request {
        case .getTracks(let searchTerm):
            presenter?.presentData(response: .presentFooterView)
            networkService.fetchTracks(searchText: searchTerm) { [weak self] searchResponse in
                self?.presenter?.presentData(response: .presentTracks(searchResponse: searchResponse))
            }
        }
    }
}
