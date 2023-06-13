//
//  MyHeader.swift
//  CompoPractice
//
//  Created by KindSoft on 2023/05/11.
//

import UIKit

class MyHeader: UICollectionReusableView {
    static let identifier = "MyHeader"
    
    private let label = UILabel()
    private let button: UIButton = {
        let v = UIButton()
        v.setTitle("더보기", for: .normal)
        v.setTitleColor(.black, for: .normal)
        v.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return v
    }()
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(button)
        label.text = "카테고리"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
