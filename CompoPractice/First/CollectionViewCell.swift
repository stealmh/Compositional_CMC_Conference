//
//  CollectionViewCell.swift
//  CompoPractice
//
//  Created by KindSoft on 2023/05/11.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    static let identifier = "CollectionViewCell"
    
    private let imageView: UIImageView = {
        let v = UIImageView()
        v.clipsToBounds = true
        v.contentMode = .scaleAspectFill
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        let images: [UIImage] = [UIImage(named: "popcat")!]
        imageView.image = images.first!
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
}
