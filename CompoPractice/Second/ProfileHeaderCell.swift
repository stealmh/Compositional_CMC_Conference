//
//  ProfileHeaderCell.swift
//  CompoPractice
//
//  Created by KindSoft on 2023/06/13.
//

import UIKit


class ProfileHeaderCell: UICollectionViewCell {
    

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var accountTypeLabel: UILabel!
    @IBOutlet weak var detailInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        imageView.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        imageView.layer.borderWidth = 1
    }
    
    func configure() {
//        imageView.image = UIImage(named: "popcat")!
//        nameLabel.text = "김민호"
//        accountTypeLabel.text = "일중"
//        detailInfoLabel.text = "세상살이"
    }

}


#if DEBUG
import SwiftUI

struct InstagramDMTVCRepresentable: UIViewRepresentable {
    typealias UIViewType = ProfileHeaderCell

    func makeUIView(context: Context) -> ProfileHeaderCell {
        return UINib(nibName: ProfileHeaderCell.nibName, bundle: nil)
                            .instantiate(withOwner: nil, options: nil).first as! ProfileHeaderCell
    }

    func updateUIView(_ uiView: ProfileHeaderCell, context: Context) {
    }
}

@available(iOS 13.0, *)
struct InstagramDMTVCPreview: PreviewProvider {
    static var previews: some View {
        Group {
            InstagramDMTVCRepresentable()
                .frame(width: 393, height: 170)
        }
        .previewLayout(.fixed(width: 393, height: 170))
        .padding(10)
    }
}
#endif
