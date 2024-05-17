//
//  TrackDetailViewController.swift
//  Playlist
//
//  Created by ec-jbg on 5/16/24.
//

import UIKit
import ReactorKit

final class TrackDetailViewController: UIViewController, StoryboardView {
    static let ID = "\(TrackDetailViewController.self)"
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var closeButtonImage: UIImageView!
    @IBOutlet weak var lyrics: UILabel!
    @IBOutlet weak var lyricsViewTopToScrollViewConst: NSLayoutConstraint!
    var trackData: SongData?
    var disposeBag = DisposeBag()
    var reactor = TrackDetailReactor()
    
    init?(trackData: SongData, coder: NSCoder) {
        super.init(coder: coder)
        self.trackData = trackData
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeButtonTapped))
        tapGesture.numberOfTapsRequired = 1
        closeButtonImage.addGestureRecognizer(tapGesture)
        songName.text = trackData?.name ?? ""
        lyrics.text = trackData?.lyrics ?? "가사 정보 없음"
        artistName.text = trackData?.artistName ?? ""
        lyricsViewTopToScrollViewConst.constant = trackData?.lyrics?.isEmpty ?? true ? 100 : 0
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func bind(reactor: TrackDetailReactor) {
//        reactor.state
//            .map { $0.trackDetail }
//            .bind(to: trackData)
//            .disposed(by: disposeBag)
    }
}

// MARK: - Life Cycle

extension TrackDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
