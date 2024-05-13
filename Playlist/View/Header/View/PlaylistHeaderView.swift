//
//  PlaylistHeaderView.swift
//  Playlist
//
//  Created by ec-jbg on 5/13/24.
//

import UIKit

class PlaylistHeaderView: UIView, NibLoadable, ReusableView {
    private struct DrawingConstants {
        static let size = CGSize(width: 80.0, height: 80.0)
        static let inset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
        static let spacing: CGFloat = 15.0
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension PlaylistHeaderView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 4
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: PlaylistHeaderCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
        var labelWidth: CGFloat = 0.0
        return CGSize(width: 40, height: 40)
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
        return 0
    }
}
