//
//  PlaylistHeaderCell.swift
//  Playlist
//
//  Created by ec-jbg on 5/13/24.
//

import UIKit

final class PlaylistHeaderCell: UICollectionViewCell, ReusableView {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var headerTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 15
    }
    
    func configureCell(_ title: [String], _ currentIndex: Int, _ selectedIndex: Int) {
        headerTitle.text = title[currentIndex]
        selectedCell(currentIndex == selectedIndex)
    }
    
    private func selectedCell(_ isSelected: Bool) {
        bgView.backgroundColor = isSelected ? .blue : .gray
    }
}
