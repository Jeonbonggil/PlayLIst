//
//  PlaylistHeaderCell.swift
//  Playlist
//
//  Created by ec-jbg on 5/13/24.
//

import UIKit

class PlaylistHeaderCell: UICollectionViewCell, ReusableView {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var headerTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 10
    }
    
    func configureCell() {
        headerTitle.text = "차트"
    }
}
