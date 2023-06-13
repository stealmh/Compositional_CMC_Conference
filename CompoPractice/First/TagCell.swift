//
//  TagCell.swift
//  CompoPractice
//
//  Created by KindSoft on 2023/05/24.
//

import UIKit

class TagCell: UICollectionViewCell {
    static let identifier = "TagCell"
    
    let tagBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .cyan
        return v
    }()
    
    let tagLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .left
        v.font = .systemFont(ofSize: 14)
        v.textColor = .black
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(tagBackground)
        contentView.addSubview(tagLabel)
//        contentView.layer.masksToBounds = true
//        contentView.layer.cornerRadius = 30
        tagBackground.layer.masksToBounds = true
        tagBackground.layer.cornerRadius = 15
        setConstant()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstant() {
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        tagLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        tagLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        tagBackground.translatesAutoresizingMaskIntoConstraints = false
        tagBackground.frame = contentView.frame
    }
    
    func configure(with title: String) {
        tagLabel.text = title
    }
}

