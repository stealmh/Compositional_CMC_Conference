//
//  ProfileHeaderCell.swift
//  CompoPractice
//
//  Created by KindSoft on 2023/06/13.
//

import UIKit
import Kingfisher

class ProfileHeaderCell: UICollectionViewCell {
    

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var accountTypeLabel: UILabel!
    @IBOutlet weak var detailInfoLabel: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        imageView.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        imageView.layer.borderWidth = 1
    }
    
    func configure(data: ProfileHeaderData) {
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: URL(string: data.image_url))
        postCountLabel.text = "\(data.postCount)"
    }

}


#if DEBUG
import SwiftUI

struct ForProfileHeaderCell: UIViewRepresentable {
    typealias UIViewType = ProfileHeaderCell

    func makeUIView(context: Context) -> ProfileHeaderCell {
        return UINib(nibName: ProfileHeaderCell.nibName, bundle: nil)
                            .instantiate(withOwner: nil, options: nil).first as! ProfileHeaderCell
    }

    func updateUIView(_ uiView: ProfileHeaderCell, context: Context) {
    }
}

@available(iOS 13.0, *)
struct ProfileHeaderPreview: PreviewProvider {
    static var previews: some View {
        Group {
            ForProfileHeaderCell()
                .frame(width: 393, height: 170)
        }
        .previewLayout(.fixed(width: 393, height: 170))
        .padding(10)
    }
}
#endif
