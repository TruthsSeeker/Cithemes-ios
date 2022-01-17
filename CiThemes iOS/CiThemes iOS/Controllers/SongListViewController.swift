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
    
    var songListVM = SongListViewModel()
    lazy var orderedSongs: [SongInfoLight] = songListVM.songsDict.values.sorted(by: {$0.score > $1.score})
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
        let safeAreaTopHeight = UIApplication.shared.windows[0].safeAreaInsets.top
        self.headerView.addConstraint(NSLayoutConstraint(item: self.headerView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 160 + safeAreaTopHeight))

        let buttonTapAction = { [unowned self] in
            print("test")
        }
        let searchButton = UIHostingController(rootView: SearchButton(width: 30, height: 30, action: buttonTapAction))
        searchButton.view.backgroundColor = .clear
        view.addSubview(searchButton.view)
        activateConstraints(forButton: searchButton.view)
    }
    
    private func bindViewModel() {
        songListVM.$songsDict.sink { [weak self] dict in
            self?.orderedSongs = dict.values.sorted(by: {$0.score > $1.score})
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
                let songInfo = self.orderedSongs[indexPath.row]
                cell.artistLabel.text = songInfo.artist
                cell.songTitleLabel.text = songInfo.title
                cell.rankLabel.text = String(indexPath.row + 1)
                cell.voteLabel.text = String(songInfo.score)
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "podiumCell", for: indexPath) as? PodiumRankTableViewCell {
                let songInfo = self.orderedSongs[indexPath.row]
                cell.artistLabel.text = songInfo.artist
                cell.songTitleLabel.text = songInfo.title
                cell.rankLabel.text = String(indexPath.row + 1)
                cell.rankLabel.textColor = UIColor(named: "Silver")
                cell.voteLabel.text = String(songInfo.score)
                return cell
            }
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "podiumCell", for: indexPath) as? PodiumRankTableViewCell {
                let songInfo = self.orderedSongs[indexPath.row]
                cell.artistLabel.text = songInfo.artist
                cell.songTitleLabel.text = songInfo.title
                cell.rankLabel.text = String(indexPath.row + 1)
                cell.rankLabel.textColor = UIColor(named: "Bronze")
                cell.voteLabel.text = String(songInfo.score)
                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RankingTableViewCell {
                let songInfo = self.orderedSongs[indexPath.row]
                cell.artistLabel.text = songInfo.artist
                cell.songTitleLabel.text = songInfo.title
                cell.rankLabel.text = String(indexPath.row + 1)
                cell.voteLabel.text = String(songInfo.score)
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
        likeAction.image
        
        //TODO: Favorite action
        
        return UISwipeActionsConfiguration(actions: [likeAction])
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        print("Test")
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "SongInfo") as? SongDetailViewController {
            let detailViewModel = SongDetailViewModel()
            let songDetail = SongInfoFull(light: orderedSongs[indexPath.row])
            detailViewModel.details = songDetail
            controller.detailVM = detailViewModel
            
            present(controller, animated: true, completion: nil)
        }
        return nil
    }
    
    private func dislikeHandler(_ indexPath: IndexPath) {
        let songId = orderedSongs[indexPath.row].id
        songListVM.update(id: songId, vote: .Down)
    }
    
    private func likeHandler(_ indexPath: IndexPath) {
        let songId = orderedSongs[indexPath.row].id
        songListVM.update(id: songId, vote: .Up)
    }
}
