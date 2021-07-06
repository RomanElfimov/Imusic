//
//  SearchViewController.swift
//  Imusic
//
//  Created by Роман Елфимов on 06.07.2021.
//

import UIKit
import Alamofire

struct TrackModel {
    var trackName: String
    var artistName: String
}


class SearchMusicViewController: UITableViewController {

    // MARK: - Interface Properties
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Privte Properties
    private var networkService = NetworkService()
    
    private var timer: Timer? // Немного ждем, пока пользователь не введет в поиск данные
    
    private var tracks = [Track]()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    
    // MARK: - Private Methods
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
//        searchController.searchBar.delegate = self
    }
    
    
    
    // MARK: - TableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let track = tracks[indexPath.row]
        cell.textLabel?.text = "\(track.trackName)\n\(track.artistName)"
        cell.textLabel?.numberOfLines = 0
        cell.imageView?.image = UIImage(systemName: "person.fill")
        
        return cell
    }
}




