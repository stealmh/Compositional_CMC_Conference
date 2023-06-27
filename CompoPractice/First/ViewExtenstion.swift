//
//  ViewExtenstion.swift
//  CompoPractice
//
//  Created by KindSoft on 2023/05/11.
//

import UIKit

extension UICollectionViewCell {
    static var resuseIdentifier: String { String(describing: Self.self) }
}

extension UICollectionReusableView {
    static var resueIdentifier: String { String(describing: Self.self) }
}

extension UIView {
    static var nibName: String  { String(describing: Self.self) }
    static var nib: UINib { UINib(nibName: nibName, bundle: nil) }
}
