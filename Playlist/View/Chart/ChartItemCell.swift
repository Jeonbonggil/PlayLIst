//
//  ChartItemCell.swift
//  Playlist
//
//  Created by ec-jbg on 5/14/24.
//

import UIKit
import Kingfisher

class ChartItemCell: UICollectionViewCell, ReusableView, NibLoadable {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var songDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnail.layer.cornerRadius = 4
    }
    
    func configureCell(at index: Int, _ reactor: ChartReactor?) {
        let state = reactor?.currentState
        thumbnail.kf.setImage(with: URL(string: ""), placeholder: UIImage(named: "kingfisher-1.jpg"))
        rankLabel.text = "\(index + 1)"
        songTitle.text = "노래 제목"
        songDesc.text = "설명"
    }
}
