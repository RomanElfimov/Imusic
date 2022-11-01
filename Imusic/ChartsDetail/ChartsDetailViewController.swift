//
//  ChartsDetailViewController.swift
//  Imusic
//
//  Created by Роман Елфимов on 03.09.2022.
//

import UIKit

// MARK: - Display Logic Protocol

protocol ChartsDetailDisplayLogic: AnyObject {
    func displayData(event: ChartsDetail.Model.ViewModel.ViewModelData)
}

// MARK: - View Controller Class

final class ChartsDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private(set) var router: (ChartsDetailRoutingLogic & ChartsDetailDataPassingProtocol)?
    weak var tabBarDelegate: MainTabBarControllerDelegate?
 
    private var interactor: (ChartsDetailBusinessLogic & ChartsDetailStoreProtocol)?
    
    private var tracksArray: [TrackViewModel.Cell] = []
    private var tableView = UITableView(frame: .zero)
    private lazy var footerView = FooterView()
    
    // MARK: - Lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        let viewController = self
        let interactor = ChartsDetailInteractor()
        let presenter = ChartsDetailPresenter()
        let router = ChartsDetailRouter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        viewController.router = router
        router.dataStore = interactor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tabBarVC = getMainTabBarController()
        tabBarDelegate = tabBarVC
        tabBarVC?.trackDetailView.delegate = self
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configureTableView()
        setupNavigationBar()
        createSwipeGesture()
        
        interactor?.makeRequest(event: .fetchTracks)
        interactor?.makeRequest(event: .fetchChartName)
        
        footerView.showLoader()
    }

    // MARK: - Private Methods
    
    private func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Регистрируем ячейку таблицы
        let nib = UINib(nibName: "TrackCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: TrackCell.reuseId)
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 70
        tableView.backgroundColor = .systemBackground
        tableView.tableFooterView = footerView
    }
    
    private func setupNavigationBar() {
        
        // Back button
        let backImage = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor.init(cgColor: #colorLiteral(red: 0.9369474649, green: 0.3679848909, blue: 0.426604867, alpha: 1)))
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func createSwipeGesture() {
        let swipeBack = UISwipeGestureRecognizer(target: self, action: #selector(backButtonTapped))
        swipeBack.direction = .right
        view.addGestureRecognizer(swipeBack)
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }

}

// MARK: - Display Logic Extension

extension ChartsDetailViewController: ChartsDetailDisplayLogic {
    func displayData(event: ChartsDetail.Model.ViewModel.ViewModelData) {
        switch event {
        case .displayTracks(let data):
            tracksArray = data
            footerView.hideLoader()
            tableView.reloadData()
            
        case .displayChartName(let title):
            self.title = title
        }
    }
}

// MARK: - TrackMovingDelegate Extension

extension ChartsDetailViewController: TrackMovingDelegate {
    private func getTrack(isForwardTrack: Bool) -> TrackViewModel.Cell? {
        
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        
        tableView.deselectRow(at: indexPath, animated: true)
        var nextIndexPath: IndexPath!
        if isForwardTrack {
            nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            if nextIndexPath.row == tracksArray.count {
                nextIndexPath.row = 0
            }
        } else {
            nextIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            if nextIndexPath.row == -1 {
                nextIndexPath.row = tracksArray.count - 1
            }
        }
        
        tableView.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
        return tracksArray[nextIndexPath.row]
    }
    
    func moveBackForPreviousTrack() -> TrackViewModel.Cell? {
        return getTrack(isForwardTrack: false)
    }
    
    func moveForwardForNextTrack() -> TrackViewModel.Cell? {
        return getTrack(isForwardTrack: true)
    }
    
}

// MARK: - Table View Extension

extension ChartsDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.reuseId, for: indexPath) as? TrackCell else { return UITableViewCell() }
        cell.setup(viewModel: tracksArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 84
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tabBarDelegate?.maximizeTrackDetailController(viewModel: tracksArray[indexPath.row])
    }
    
}

extension ChartsDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return (otherGestureRecognizer is UIScreenEdgePanGestureRecognizer)
    }
}
