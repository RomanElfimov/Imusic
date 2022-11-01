//
//  ChartsDetailRouter.swift
//  Imusic
//
//  Created by Роман Елфимов on 04.09.2022.
//

import UIKit

// MARK: - Routing Logic Protocol
protocol ChartsDetailRoutingLogic {
}

// MARK: - Data Passing Protocol

protocol ChartsDetailDataPassingProtocol {
    var dataStore: ChartsDetailStoreProtocol? { get }
}

// MARK: - Router

final class ChartsDetailRouter: ChartsDetailDataPassingProtocol {
    weak var dataStore: ChartsDetailStoreProtocol?
}

// MARK: - Routing Logic Extension

extension ChartsDetailRouter: ChartsDetailRoutingLogic {
    
}
