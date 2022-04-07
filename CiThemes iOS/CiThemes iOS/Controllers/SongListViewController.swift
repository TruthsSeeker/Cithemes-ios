//
//  ViewController.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 20/07/2021.
//

import UIKit
import Combine
import SwiftUI


class SongListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    @StateObject var songListVM = SongListViewModel()
    lazy var orderedSongs: [PlaylistEntry] = songListVM.songsDict.values.sorted(by: {$0.votes > $1.votes})
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.separatorStyle = .none
        bindViewModel()
        
        tableView.register(UINib(nibName: "FirstRankTableViewCell", bundle: nil), forCellReuseIdentifier: "firstCell")
        tableView.register(UINib(nibName: "PodiumRankTableViewCell", bundle: nil), forCellReuseIdentifier: "podiumCell")
        tableView.register(UINib(nibName: "RankingTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        let safeAreaTopHeight = self.view.window?.safeAreaInsets.top ?? 0
        self.headerView.addConstraint(NSLayoutConstraint(
                item: self.headerView!,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .height,
                multiplier: 1,
                constant: 160 + safeAreaTopHeight))

        let buttonTapAction = { [unowned self] in
            let searchController = UIHostingController(rootView: SongSearchController())
            searchController.view.backgroundColor = UIColor(Color.background)
            self.present(searchController, animated: true, completion: nil)
        }
        let searchButton = UIHostingController(rootView: SearchButton(
                width: 45,
                height: 45,
                action: buttonTapAction)
            .environmentObject(songListVM))
        searchButton.view.backgroundColor = .clear
        view.addSubview(searchButton.view)
        activateConstraints(forButton: searchButton.view)
    }
    
    private func bindViewModel() {
        songListVM.$songsDict.sink { [weak self] dict in
            self?.orderedSongs = dict.values.sorted(by: {$0.votes > $1.votes})
            self?.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }.store(in: &cancellables)
    }
    
    
    fileprivate func activateConstraints(forButton button: UIView) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
    }
    
    
}

extension SongListViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songListVM.songsDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "firstCell", for: indexPath) as? FirstRankTableViewCell {
                let entry = self.orderedSongs[indexPath.row]
                let songInfo = entry.songInfo
                cell.artistLabel.text = songInfo?.artist
                cell.songTitleLabel.text = songInfo?.title
                cell.rankLabel.text = String(indexPath.row + 1)
                cell.voteLabel.text = String(entry.votes)
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "podiumCell", for: indexPath) as? PodiumRankTableViewCell {
                let entry = self.orderedSongs[indexPath.row]
                let songInfo = entry.songInfo
                cell.artistLabel.text = songInfo?.artist
                cell.songTitleLabel.text = songInfo?.title
                cell.rankLabel.text = String(indexPath.row + 1)
                cell.rankLabel.textColor = UIColor(named: "Silver")
                cell.voteLabel.text = String(entry.votes)
                return cell
            }
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "podiumCell", for: indexPath) as? PodiumRankTableViewCell {
                let entry = self.orderedSongs[indexPath.row]
                let songInfo = entry.songInfo
                cell.artistLabel.text = songInfo?.artist
                cell.songTitleLabel.text = songInfo?.title
                cell.rankLabel.text = String(indexPath.row + 1)
                cell.rankLabel.textColor = UIColor(named: "Bronze")
                cell.voteLabel.text = String(entry.votes)
                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RankingTableViewCell {
                let entry = self.orderedSongs[indexPath.row]
                let songInfo = entry.songInfo
                cell.artistLabel.text = songInfo?.artist
                cell.songTitleLabel.text = songInfo?.title
                cell.rankLabel.text = String(indexPath.row + 1)
                cell.voteLabel.text = String(entry.votes)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let dislikeAction = UIContextualAction(style: .normal, title: "Dislike") { [unowned self] action, view, handler in
            self.dislikeHandler(indexPath)
            handler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [dislikeAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let likeAction = UIContextualAction(style: .normal, title: "Like") { [unowned self] action, view, handler in
            self.likeHandler(indexPath)
            handler(true)
        }
        //TODO: Favorite action
        
        return UISwipeActionsConfiguration(actions: [likeAction])
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        print("Test")
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "SongInfo") as? SongDetailViewController {
            let detailViewModel = SongDetailViewModel()
            
            detailViewModel.details = orderedSongs[indexPath.row].songInfo
            controller.detailVM = detailViewModel
            
            present(controller, animated: true, completion: nil)
        }
        return nil
    }
    
    private func dislikeHandler(_ indexPath: IndexPath) {
        guard let songId = orderedSongs[indexPath.row].id else { return }
        songListVM.update(id: songId, vote: .Down)
    }
    
    private func likeHandler(_ indexPath: IndexPath) {
        guard let songId = orderedSongs[indexPath.row].id else { return  }
        songListVM.update(id: songId, vote: .Up)
    }
}
