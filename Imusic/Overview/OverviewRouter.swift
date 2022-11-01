//
//  OverviewRouter.swift
//  Imusic
//
//  Created by Роман Елфимов on 04.09.2022.
//

import UIKit

// MARK: - Routing Logic Protocol

protocol OverviewRoutingLogic {
    func navigateToDetail(event: Overview.Model.Routing.RoutingType)
}

// MARK: - Router

final class OverviewRouter {
    weak var viewController: UIViewController?
}

// MARK: - Routing Logic Extension

extension OverviewRouter: OverviewRoutingLogic {
    func navigateToDetail(event: Overview.Model.Routing.RoutingType) {
        switch event {
        case .navigateToDetail(let id, let title):
          
            let detailVC = ChartsDetailViewController()
            detailVC.router?.dataStore?.id = id
            detailVC.router?.dataStore?.chartName = title
            
            let navVC = UINavigationController(rootViewController: detailVC)
            navVC.modalPresentationStyle = .overCurrentContext
            viewController?.present(navVC, animated: true)
        }
    }
}
    
