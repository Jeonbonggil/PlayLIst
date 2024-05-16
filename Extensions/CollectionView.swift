//
//  UICollectionView.swift
//  Playlist
//
//  Created by Bonggil Jeon on 5/4/24.
//

import UIKit

public extension UICollectionView {
    // MARK: - Registration Cell
    func registerCellClass<CellClass: UICollectionViewCell>(_ cellClass: CellClass.Type) {
        self.register(cellClass, forCellWithReuseIdentifier: classNameWithoutModule(cellClass))
    }
    
    func register<T: ReusableView>(_ cellClass: T.Type) {
        self.register(cellClass, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func registerCellNibForClass(_ cellClass: AnyClass) {
        let className = classNameWithoutModule(cellClass)
        self.register(UINib(nibName: className, bundle: nil), forCellWithReuseIdentifier: className)
    }
    
    // MARK: - Registration Header
    func registerHeaderNibForClass(_ cellClass: AnyClass) {
        let className = classNameWithoutModule(cellClass)
        self.register(UINib(nibName: className, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: className)
    }
    
    func registerFooterNibForClass(_ cellClass: AnyClass) {
        let className = classNameWithoutModule(cellClass)
        self.register(UINib(nibName: className, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: className)
    }
    
    func registerFooterForClass(_ cellClass: AnyClass) {
        self.register(cellClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: classNameWithoutModule(cellClass))
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(
        forIndexPath indexPath: IndexPath
    ) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: T.reuseIdentifirer,
            for: indexPath
        ) as? T else {
            return UICollectionViewCell() as! T
        }
        return cell
    }
}
