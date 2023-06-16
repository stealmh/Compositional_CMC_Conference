//
//  PhotoHeaderCell.swift
//  CompoPractice
//
//  Created by KindSoft on 2023/06/13.
//

import UIKit
import RxSwift
import RxCocoa

class PhotoHeaderCell: UICollectionReusableView {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    
    override func awakeFromNib() {
        photoButton.rx.tap
            .subscribe(onNext: {_ in
                self.videoButton.tintColor = .gray
                self.photoButton.tintColor = .black
                
            }).disposed(by: disposeBag)
        
        videoButton.rx.tap
            .subscribe(onNext: {_ in
                self.videoButton.tintColor = .black
                self.photoButton.tintColor = .gray
                
            }).disposed(by: disposeBag)
    }
}
