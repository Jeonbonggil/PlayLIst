//
//  TrackDetailViewController.swift
//  Playlist
//
//  Created by ec-jbg on 5/16/24.
//

import UIKit
import ReactorKit

final class TrackDetailViewController: UIViewController, StoryboardView {
    var disposeBag = DisposeBag()
    var reactor = TrackDetailReactor()
    
    init(trackData: SongData?, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: TrackDetailReactor) {
        reactor.action.onNext(.loadTrackDetail)
        
//        reactor.state
//            .map { $0.trackDetail }
//            .subscribe { [weak self] trackDetail in
//                guard let self = self else { return }
//                self.title = trackDetail.title
//            }
//            .disposed(by: disposeBag)
    }
}

// MARK: - Life Cycle

extension TrackDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}
