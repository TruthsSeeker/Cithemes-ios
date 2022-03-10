//
//  SongDetailViewController.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 04/01/2022.
//

import UIKit
import Combine

class SongDetailViewController: UIViewController {
    @IBOutlet var containerView: UIView!
    @IBOutlet var mainStack: UIStackView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    @IBOutlet var albumLabel: UILabel!
    @IBOutlet var releasedLabel: UILabel!
    @IBOutlet var lengthLabel: UILabel!
    
    var detailVM = SongDetailViewModel()
    
    private var cancellables: Set<AnyCancellable> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(white: 1, alpha: 0.5)
        containerView.layer.cornerRadius = 10
        bindViewModel()
        detailVM.fetch()
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
        

    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        let touch = sender.location(in: containerView)
        if !containerView.bounds.contains(touch) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func bindViewModel() {
        detailVM.$loading.sink { [unowned self] value in
            self.mainStack.isHidden = value
            self.loadingIndicator.isHidden = !value
            value ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
        }.store(in: &cancellables)
        
        detailVM.$details.sink { [unowned self] info in
            self.titleLabel.text = info?.title
            self.artistLabel.text = info?.artist
            self.albumLabel.text = info?.album
            self.releasedLabel.text = info?.release
            self.lengthLabel.text = TimeInterval(Double(info?.duration ?? 0)/1000).minuteSecond
        }.store(in: &cancellables)
    }

    //TODO: Spotify preview player
}
