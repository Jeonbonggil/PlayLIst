//
//  GenreTableCell.swift
//  Playlist
//
//  Created by ec-jbg on 5/14/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
/**
 ## 설명
 * <# 요약 #>
 
 ## 기본정보
 * Note: APP
 * See: <# 제플린 없음 #>
 */
class GenreTableCell: UITableViewCell, ReusableView, NibLoadable {
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.registerCellNibForClass(GenreItemCell.self)
        }
    }
    @IBOutlet weak var collectionViewHeightConst: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension GenreTableCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as GenreItemCell
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension GenreTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 10
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 10
    }
}

