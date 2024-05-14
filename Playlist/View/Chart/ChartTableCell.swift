//
//  ChartTableCell.swift
//  Playlist
//
//  Created by ec-jbg on 5/13/24.
//

import UIKit
import RxSwift
import RxCocoa
//import RxGesture

class ChartTableCell: UITableViewCell, NibLoadable, ReusableView {
    private struct DrawingConstants {
        static let size = CGSize(width: width, height: height)
        static let width = ChartTableCell().screen?.bounds.width ?? 0
        static let height = 300.0
    }
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.registerCellNibForClass(ChartItemCell.self)
            let cellWidth = DrawingConstants.width
            let cellHeight = DrawingConstants.height
            let insetX = (collectionView.bounds.width - cellWidth) / 2.0
            let insetY = (collectionView.bounds.height - cellHeight) / 2.0
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            layout.scrollDirection = .horizontal
            collectionView.contentInset = UIEdgeInsets(
                top: insetY,
                left: insetX,
                bottom: insetY,
                right: insetX
            )
            collectionView.decelerationRate = .fast
        }
    }
    @IBOutlet weak var pageControl: UIPageControl! {
        didSet {
            pageControl.numberOfPages = 4
            pageControl.currentPage = 0
        }
    }
    private var currentIndex: CGFloat = 0
    private let lineSpacing: CGFloat = 20
    private let cellRatio: CGFloat = 0.7
    private var isOneStepPaging = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension ChartTableCell: UICollectionViewDataSource, UICollectionViewDelegate {
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
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ChartItemCell
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        print("didSelect: \(indexPath.row)")
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ChartTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return DrawingConstants.size
    }
}

// MARK: - UIScrollViewDelegate

extension ChartTableCell: UIScrollViewDelegate {
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        var roundedIndex = round(index)
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
            roundedIndex = ceil(index)
        } else {
            roundedIndex = round(index)
        }
        if isOneStepPaging {
            if currentIndex > roundedIndex {
                currentIndex -= 1
                roundedIndex = currentIndex
            } else if currentIndex < roundedIndex {
                currentIndex += 1
                roundedIndex = currentIndex
            }
        }
        let x = roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left
        offset = CGPoint(x: x, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
        pageControl.currentPage = Int(roundedIndex)
    }
}
