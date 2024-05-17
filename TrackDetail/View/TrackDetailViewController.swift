//
//  TrackDetailViewController.swift
//  Playlist
//
//  Created by ec-jbg on 5/16/24.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

final class TrackDetailViewController: UIViewController, StoryboardView {
    static let ID = "\(TrackDetailViewController.self)"
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var closeButtonImage: UIImageView!
    @IBOutlet weak var lyrics: UILabel!
    @IBOutlet weak var lyricsViewTopToScrollViewConst: NSLayoutConstraint!
    var trackData: SongData?
    var reactor: TrackDetailReactor?
    var disposeBag = DisposeBag()
    
    init?(trackData: SongData, coder: NSCoder) {
        super.init(coder: coder)
        reactor = TrackDetailReactor(trackData: trackData)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeButtonTapped))
        tapGesture.numberOfTapsRequired = 1
        closeButtonImage.addGestureRecognizer(tapGesture)
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func bind(reactor: TrackDetailReactor) {
        reactor.state
            .map { $0.songName }
            .filter { $0 != nil }
            .bind(to: songName.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.artistName }
            .filter { $0 != nil }
            .bind(to: artistName.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.lyrics ?? "가사 정보 없음" }
            .bind(to: lyrics.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.lyricsViewTopConst }
            .compactMap { $0 }
            .bind(to: lyricsViewTopToScrollViewConst.rx.constant)
            .disposed(by: disposeBag)
    }
    
    private func bindAction() {
        reactor?.action.onNext(.getSongName)
        reactor?.action.onNext(.getArtistName)
        reactor?.action.onNext(.getLyrics)
        reactor?.action.onNext(.getLyricsViewTop)
    }
}

extension Reactive where Base: NSLayoutConstraint {
    var constant: Binder<CGFloat> {
        return Binder(self.base) { constraint, value in
            constraint.constant = value
        }
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
        bindAction()
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
