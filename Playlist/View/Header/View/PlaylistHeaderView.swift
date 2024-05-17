//
//  PlaylistHeaderView.swift
//  Playlist
//
//  Created by ec-jbg on 5/13/24.
//

import UIKit
import ReactorKit

final class PlaylistHeaderView: UIView, StoryboardView, NibLoadable, ReusableView {
    private struct DrawingConstants {
        static let size = CGSize(width: 80.0, height: height)
        static let height = 30.0
        static let inset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
        static let spacing: CGFloat = 10.0
    }
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.registerCellNibForClass(PlaylistHeaderCell.self)
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.estimatedItemSize = .zero
            collectionView.collectionViewLayout = flowLayout
        }
    }
    @IBOutlet weak var collectionVIewHeightConst: NSLayoutConstraint!
    var delegate: PlayListActionDelegate?
    var isScrolling = true
    var headerTitles: [String] = []
    var selectedIndex = 0
    var disposeBag = DisposeBag()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(reactor: PlaylistReactor) {
        
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension PlaylistHeaderView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return headerTitles.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let index = indexPath.row
        let cell: PlaylistHeaderCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureCell(headerTitles, index, selectedIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        collectionView.reloadData()
        delegate?.didTapHeaderView(at: selectedIndex)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension PlaylistHeaderView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return DrawingConstants.inset
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let insets = DrawingConstants.inset.left + DrawingConstants.inset.right + 5.0
        let title = headerTitles[indexPath.row]
        let width = title.widthOfString(usingFont: .systemFont(ofSize: 13)) + insets
        let height = DrawingConstants.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return DrawingConstants.spacing
    }
}
