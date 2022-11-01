//
//  OverviewInteractor.swift
//  Imusic
//
//  Created by Роман Елфимов on 31.08.2022.
//

import Foundation

// MARK: - Business Logic Protocol

protocol OverviewBusinessLogic {
    func makeRequest(event: Overview.Model.Request.RequestType)
}

// MARK: - Interactor

final class OverviewInteractor {
    var presenter: OverviewPresentationLogic?
    
    private var networkService = NetworkService()
}

// MARK: - Business Logic Extension

extension OverviewInteractor: OverviewBusinessLogic {
    func makeRequest(event: Overview.Model.Request.RequestType) {
        switch event {
        case .getCharts:
            
            networkService.fetchCharts { [weak self] charts in
                guard let charts = charts else { return }
                self?.presenter?.presentData(event: .presentCharts(data: charts))
            }
            
        case .showAlert:
            presenter?.presentData(event: .showAlert)
        }
    }
}
