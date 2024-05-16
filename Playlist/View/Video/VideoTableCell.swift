//
//  VideoTableCell.swift
//  Playlist
//
//  Created by Bonggil Jeon on 5/14/24.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
/**
 ## 설명
 * 영상 리스트 Table Cell
 
 ## 기본정보
 * Note: APP
 * See: <# 제플린 없음 #>
 */
class VideoTableCell: UITableViewCell, StoryboardView, ReusableView, NibLoadable {
    private struct DrawingConstants {
        static let size = CGSize(width: width, height: height)
        static let width = (VideoTableCell().screen?.bounds.width ?? 0) - 70.0
        static let height = 260.0
        static let inset = UIEdgeInsets(top: 0, left: 15, bottom: 10, right: 15)
        static let spacing = 10.0
    }
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var playTime: UILabel!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.registerCellNibForClass(VideoItemCell.self)
        }
    }
    var reactor: VideoReactor? {
        didSet {
            guard let reactor else { return }
            bind(reactor: reactor)
        }
    }
    var disposeBag = DisposeBag()
    private var videoPlayList: VideoPlayList?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnail.layer.cornerRadius = 4
        bgView.layer.cornerRadius = 4
    }
    
    func bind(reactor: VideoReactor) {
        reactor.state
            .map { $0.videoPlayList }
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] list in
                guard let self, let list = list.element?.flatMap ({ $0 }) else { return }
                videoPlayList = list
                configureCell(list)
                collectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    private func configureCell(_ list: VideoPlayList) {
        guard let list = list.videoList.first else { return }
        thumbnail.kf.setImage(with: list.thumbnailURL)
        playTime.text = list.playTm
        songTitle.text = list.videoNm
        artistName.text = list.artistName
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension VideoTableCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return videoPlayList?.listCount ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as VideoItemCell
        guard let list = videoPlayList?.listFromSecond[indexPath.row] else { return cell }
        cell.configureCell(list)
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension VideoTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return DrawingConstants.size
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return DrawingConstants.spacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return DrawingConstants.spacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return DrawingConstants.inset
    }
}
