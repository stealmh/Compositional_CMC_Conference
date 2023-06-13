//
//  StoryCell.swift
//  CompoPractice
//
//  Created by KindSoft on 2023/06/13.
//

import UIKit

class StoryCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        
        imageView.contentMode = .scaleAspectFill
        contentView.backgroundColor = .clear
        contentView.layer.borderColor = UIColor.secondaryLabel.cgColor
        contentView.layer.borderWidth = 1
    }
    
    func configure(with highlight: UIImage) {
        imageView.image = highlight
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = contentView.bounds.height/2
        imageView.layoutIfNeeded()
        imageView.layer.cornerRadius = imageView.bounds.height/2
    }
}
