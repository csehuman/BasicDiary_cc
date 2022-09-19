//
//  StarTableViewCell.swift
//  BasicDiaryApp
//
//  Created by Paul Lee on 2022/09/19.
//

import UIKit

class StarCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 4.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.black.cgColor
    }
}
