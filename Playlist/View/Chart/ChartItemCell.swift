//
//  ChartItemListCell.swift
//  Playlist
//
//  Created by ec-jbg on 5/14/24.
//

import UIKit
import Kingfisher

class ChartItemListCell: UITableViewCell, ReusableView, NibLoadable {
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var songDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(at index: Int, _ reactor: ChartReactor?) {
        let state = reactor?.currentState
        coverImage.kf.setImage(with: URL(string: ""), placeholder: UIImage(named: "kingfisher-1.jpg"))
        rankLabel.text = "\(index + 1)"
        songTitle.text = "노래 제목"
        songDesc.text = "설명"
    }
}
