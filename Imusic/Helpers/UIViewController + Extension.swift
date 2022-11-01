//
//  UIViewController + Extension.swift
//  Imusic
//
//  Created by Роман Елфимов on 06.07.2021.
//

import UIKit

extension UIViewController {
    
    class func loadFromStoryboard<T: UIViewController>() -> T {
        let name = String(describing: T.self)
        let storyboard = UIStoryboard(name: name, bundle: nil)
        if let viewController = storyboard.instantiateInitialViewController() as? T {
            return viewController
        } else {
            fatalError("Error: No initial view controller in \(name) storyboard")
        }
    }
    
    // Create Cell UICollectionViewCell
    func configureCell<T: SelfConfiguringCell, U: Hashable>(collectionView: UICollectionView, cellType: T.Type, with value: U, index: Int, for indexPath: IndexPath) -> T {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath) as? T else { fatalError("Enable to dequeue \(cellType)") }
        
        cell.configure(with: value, indexPath: index)
        return cell
    }
    
    func getMainTabBarController() -> MainTabBarController? {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter {
                $0.activationState == .foregroundActive
            }
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        return keyWindow?.rootViewController as? MainTabBarController
    }
}
