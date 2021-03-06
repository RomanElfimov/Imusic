//
//  SearchInteractor.swift
//  Imusic
//
//  Created by Роман Елфимов on 06.07.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchBusinessLogic {
    func makeRequest(request: Search.Model.Request.RequestType)
}

class SearchInteractor: SearchBusinessLogic {
    
    // MARK: - External vars
    var presenter: SearchPresentationLogic?
    var service: SearchService?
    
    // MARK: - Internal vars
    private var networkService = NetworkService()
    
    func makeRequest(request: Search.Model.Request.RequestType) {
        
        if service == nil {
            service = SearchService()
        }
        
        switch request {
        
        case .getTracks(let searchTerm):
            
            presenter?.presentData(response: .presentFooterView)
            
            networkService.fetchTracks(searchText: searchTerm) { [weak self] searchResponse in
                
                self?.presenter?.presentData(response: .presentTracks(searchResponse: searchResponse))
       
            }
        }
    }
    
}
