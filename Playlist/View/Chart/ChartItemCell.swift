//
//  ChartItemCell.swift
//  Playlist
//
//  Created by ec-jbg on 5/14/24.
//

import UIKit
import Kingfisher

final class ChartItemCell: UICollectionViewCell, ReusableView, NibLoadable {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var artistName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnail.layer.cornerRadius = 4
    }
    
    func configureCell(at index: Int, _ list: TrackList?) {
        guard let list else { return }
        thumbnail.kf.setImage(with: list.imgURL)
        rankLabel.text = "\(index + 1)"
        songTitle.text = list.songTitle
        artistName.text = list.artistName
    }
}
