//
//  MainTabBarController.swift
//  Imusic
//
//  Created by Роман Елфимов on 06.07.2021.
//

import UIKit

// Экран анимировано уходит вниз
protocol MainTabBarControllerDelegate: class {
    func minimizeTrackDetailController() // скрываем контроллер
    func maximizeTrackDetailController(viewModel: SearchViewModel.Cell?) // раскрываем контроллер
    
}


class MainTabBarController: UITabBarController {
    
    let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
    
    // Constraint properties
    private var minimizedTopAnchorConstraint: NSLayoutConstraint!
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    
    private var bottomAnchorConstraint: NSLayoutConstraint!
    let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        tabBar.tintColor = #colorLiteral(red: 1, green: 0, blue: 0.3776089847, alpha: 1)
        
        setupTrackDetailView()
        searchVC.tabBarDelegate = self
        
        viewControllers = [
            generateViewController(rootViewController: searchVC,
                                   image: #imageLiteral(resourceName: "search"),
                                   title: "Search"),
            
            generateViewController(rootViewController: ViewController(),
                                   image: #imageLiteral(resourceName: "library"),
                                   title: "Library")
        ]
    }
    
    
    private func generateViewController(rootViewController: UIViewController, image: UIImage, title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        
        return navigationVC
    }
    
    
   
    
    // Настраиваем TrackDetailView
    private func setupTrackDetailView() {

        trackDetailView.tabBarDelegate = self // subscribe delegate
        trackDetailView.delegate = searchVC
        view.insertSubview(trackDetailView, belowSubview: tabBar)
        
        // Constraints - Use auto layout
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
      
        maximizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minimizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        
        bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        
        maximizedTopAnchorConstraint.isActive = true
            
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
}



extension MainTabBarController: MainTabBarControllerDelegate {
    
    func minimizeTrackDetailController() {
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
                        self.tabBar.alpha = 1
                       },
                       completion: nil)
    }
    
    func maximizeTrackDetailController(viewModel: SearchViewModel.Cell?) {
        maximizedTopAnchorConstraint.isActive = true
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
                        self.tabBar.alpha = 0
                       },
                       completion: nil)
        guard let viewModel = viewModel else { return }
        self.trackDetailView.set(viewModel: viewModel)
    }
}
