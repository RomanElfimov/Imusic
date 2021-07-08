//
//  SearchViewController.swift
//  Imusic
//
//  Created by Роман Елфимов on 06.07.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchDisplayLogic: class {
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
}

class SearchViewController: UIViewController, SearchDisplayLogic {
    
    // MARK: - Properties
    
    var interactor: SearchBusinessLogic?
    var router: (NSObjectProtocol & SearchRoutingLogic)?
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var searchViewModel = SearchViewModel.init(cells: [])
    private var timer: Timer? // Немного ждем, пока пользователь не введет в поиск данные
    
    // footerView
    private lazy var footerView = FooterView()
    
    
    // MARK: - Outlet
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = SearchInteractor()
        let presenter             = SearchPresenter()
        let router                = SearchRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: Routing
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
        
        searchBar(searchController.searchBar, textDidChange: "Billie")
    }
    
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
        
        switch viewModel {
        case .displayTracks(let searchViewModel):
            
            self.searchViewModel = searchViewModel
            tableView.reloadData()
            footerView.hideLoader()
        
        case .displayFooterView:
            footerView.showLoader()
        }
    }
    
    // MARK: - Private Method
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "TrackCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: TrackCell.reuseId)
        tableView.tableFooterView = footerView
    }
    
}



// MARK: - Extension UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        // Немного ждем, пока пользователь не введет в поиск данные - через полсекунды после того, как отпустим пальцы от экрана
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
        
            self.interactor?.makeRequest(request: .getTracks(searchTerm: searchText))
        })
    }
}



// MARK: - Extension TableView
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.reuseId, for: indexPath) as! TrackCell
        
        let cellViewModel = searchViewModel.cells[indexPath.row]
        cell.setup(viewModel: cellViewModel)
        
        return cell
    }
    
    
    // Did Select Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = searchViewModel.cells[indexPath.row]
        print(cellViewModel.trackName)
        
        // По тапу на ячейку появляется модальное окно tableDetailView - по иерархии оно должно находиться поверх всех окон - воспользуемся window из SceneDelegate
        let window = UIApplication.shared.keyWindow
        // let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        let trackDetailsView = Bundle.main.loadNibNamed("TrackDetailView", owner: self, options: nil)?.first as! TrackDetailView
        
        trackDetailsView.set(viewModel: cellViewModel)
        
        window?.addSubview(trackDetailsView)
    }
    
    // Row Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 84
    }
    
    
    // Header View
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter search term above..."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }
    
    // Высота header view
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        // Если что-то ищем, то высота header view = 0
        return searchViewModel.cells.count > 0 ? 0 : 250
    }
}




