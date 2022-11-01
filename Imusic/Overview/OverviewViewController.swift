//
//  OverviewViewController.swift
//  Imusic
//
//  Created by Роман Елфимов on 30.08.2022.
//

import UIKit
import StoreKit

// MARK: - Display Logic Protocol

protocol OverviewDisplayLogic: AnyObject {
    func displayData(event: Overview.Model.ViewModel.ViewModelData)
}

// MARK: - View Controller

final class OverviewViewController: UIViewController {
    
    // MARK: - Enum Section
    
    enum Section: Int, CaseIterable {
        case tracks
        case playlists
        case albums
        
        func description() -> String {
            switch self {
            case .tracks:
                return "Топ-песни"
            case .playlists:
                return "Топ-плейлисты"
            case .albums:
                return "Топ-альбомы"
            }
        }
    }
    
    // MARK: - Properties
    
    private(set) var router: OverviewRoutingLogic?
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    
    private var interactor: OverviewInteractor?
    
    private var songsArray: [TrackViewModel.Cell] = []
    private var playlistsArray: [TrackViewModel.Cell] = []
    private var albumsArray: [TrackViewModel.Cell] = []
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, TrackViewModel.Cell>?
    
    // MARK: - Life Cycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
        // Tab Bar остается виден
        definesPresentationContext = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        let viewController = self
        let interactor = OverviewInteractor()
        let presenter = OverviewPresenter()
        let router = OverviewRouter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        viewController.router = router
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupCollectionView()
        createDataSource()
        reloadData()
        
        fetchCharts()
    }
    
    // MARK: - Private Methods
    
    private func fetchCharts() {
        SKCloudServiceController.requestAuthorization { [weak self] status in
            if status == .authorized {
                self?.interactor?.makeRequest(event: .getCharts)
            } else {
                self?.interactor?.makeRequest(event: .showAlert)
            }
        }
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        
        collectionView.register(SongsCollectionViewCell.self, forCellWithReuseIdentifier: SongsCollectionViewCell.reuseId)
        collectionView.register(ChartsCollectionViewCell.self, forCellWithReuseIdentifier: ChartsCollectionViewCell.reuseId)
        collectionView.delegate = self
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Ошибка", message: "Для продолжения работы предоставьте доступ к Apple Music", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .cancel)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

// MARK: - Display Logic Extension

extension OverviewViewController: OverviewDisplayLogic {
    func displayData(event: Overview.Model.ViewModel.ViewModelData) {
        switch event {
            
        case .displaySongs(let songs):
            songsArray = songs
        case .displayPlaylists(let playlists):
            playlistsArray = playlists
        case .displayAlbums(let albums):
            albumsArray = albums
        case .showAlert:
            showAlert()
        }
        
        reloadData()
    }
}

// MARK: - Setup DiffableDataSource

extension OverviewViewController {
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, TrackViewModel.Cell>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let section = Section(rawValue: indexPath.section) else { fatalError() }
            
            switch section {
            case .tracks:
                return self.configureCell(collectionView: collectionView, cellType: SongsCollectionViewCell.self, with: itemIdentifier, index: indexPath.row, for: indexPath)
            case .playlists:
                return self.configureCell(collectionView: collectionView, cellType: ChartsCollectionViewCell.self, with: itemIdentifier, index: indexPath.row, for: indexPath)
            case .albums:
                return self.configureCell(collectionView: collectionView, cellType: ChartsCollectionViewCell.self, with: itemIdentifier, index: indexPath.row, for: indexPath)
            }
        })
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else { fatalError("Can not create new section header") }
            
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section kind") }
            
            sectionHeader.configurate(text: section.description())
            
            return sectionHeader
        }
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, TrackViewModel.Cell>()
        
        snapshot.appendSections([.tracks, .playlists, .albums])
        
        snapshot.appendItems(songsArray, toSection: .tracks)
        snapshot.appendItems(playlistsArray, toSection: .playlists)
        snapshot.appendItems(albumsArray, toSection: .albums)
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Setup Compositional Layout

extension OverviewViewController {
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            
            guard let section = Section(rawValue: sectionIndex) else { fatalError("Unknown section kind") }
            
            switch section {
                
            case .tracks:
                return self.createSongsLayout()
            case .playlists:
                return self.createPlaylistsLayout()
            case .albums:
                return self.createPlaylistsLayout()
            }
        }
        
        // Расстояние между секциями
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
    
    // Для секции песен
    private func createSongsLayout() -> NSCollectionLayoutSection {
        
        let inset: CGFloat = 4
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.25))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(view.frame.height / 2.6))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: inset, bottom: 20, trailing: inset)
        section.orthogonalScrollingBehavior = .continuous
        
        // Делаем header
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    // Для секций плейлистов и альбомов
    private func createPlaylistsLayout() -> NSCollectionLayoutSection {
        let inset: CGFloat = 10
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4),
                                               heightDimension: .fractionalWidth(0.65))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        // Отступы
        section.interGroupSpacing = inset // Между группами
        section.contentInsets = NSDirectionalEdgeInsets.init(top: inset, leading: inset, bottom: 20, trailing: inset)
        
        // Тип прокрутки
        section.orthogonalScrollingBehavior = .continuous
        
        // Делаем header
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    // Делаем header
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .absolute(view.frame.width), heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return sectionHeader
    }
}

// MARK: - UICollectionViewDelegate Extension

extension OverviewViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { return }
        switch section {
        case .tracks:
    
            tabBarDelegate?.maximizeTrackDetailController(viewModel: songsArray[indexPath.row])
            
            let tabBarVC = getMainTabBarController()
            tabBarVC?.trackDetailView.delegate = self
            
        case .playlists:
            let playlist = playlistsArray[indexPath.row]
            router?.navigateToDetail(event: .navigateToDetail(id: playlist.identifre, title: playlist.trackName))
        case .albums:
            let album = albumsArray[indexPath.row]
            router?.navigateToDetail(event: .navigateToDetail(id: album.identifre, title: album.trackName))
        }
    }
}

// MARK: - TrackMovingDelegate Extension

// Переключение треков
extension OverviewViewController: TrackMovingDelegate {
    private func getTrack(isForwardTrack: Bool) -> TrackViewModel.Cell? {
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return nil }
        
        collectionView.deselectItem(at: indexPath, animated: true)
        var nextIndexPath: IndexPath!
        if isForwardTrack {
            nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            if nextIndexPath.row == songsArray.count {
                nextIndexPath.row = 0
            }
        } else {
            nextIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            if nextIndexPath.row == -1 {
                nextIndexPath.row = songsArray.count - 1
            }
        }
        
        collectionView.selectItem(at: nextIndexPath, animated: true, scrollPosition: .centeredHorizontally)
        return songsArray[nextIndexPath.row]
    }
    
    func moveBackForPreviousTrack() -> TrackViewModel.Cell? {
        return getTrack(isForwardTrack: false)
    }
    
    func moveForwardForNextTrack() -> TrackViewModel.Cell? {
        return getTrack(isForwardTrack: true)
    }
    
}
