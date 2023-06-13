//
//  ViewExtenstion.swift
//  CompoPractice
//
//  Created by KindSoft on 2023/05/11.
//

import UIKit

extension UICollectionViewCell {
    static var resuseIdentifier: String {
        String(describing: Self.self)
    }
}

extension UIView {
    static var nibName: String  { String(describing: Self.self) }
    static var nib: UINib { UINib(nibName: nibName, bundle: nil) }
    
    static func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: Self.self), owner: nil, options: nil)![0] as! T
    }
}
