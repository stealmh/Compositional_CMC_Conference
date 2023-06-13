//
//  ViewController.swift
//  CompoPractice
//
//  Created by KindSoft on 2023/05/11.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    
    typealias Item = CollectionViewCell
    typealias Tag = TagCell
    typealias Header = MyHeader
    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: ViewController.createLayout())
    
    let disposeBag = DisposeBag()
    
    let sections: [Int] = [10,10,5]
    var tagList: [String] = ["파이썬","자바","스위프트"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(myAddButton)
        collectionView.register(Item.self, forCellWithReuseIdentifier: Item.identifier)
        collectionView.register(Tag.self, forCellWithReuseIdentifier: Tag.identifier)
        collectionView.register(Header.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Header.identifier)
//        collectionView.frame = view.bounds
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionViewLayout()
        
        
        myAddButton.rx.tap
            .subscribe(onNext: {_ in
                
                let data: [String] = ["멍멍이","냥냥이","뽀삐"]
                
                self.tagList.append(data.randomElement()!)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }).disposed(by: disposeBag)
    }
    
    private let myAddButton: UIButton = {
        let v = UIButton()
        v.setTitle("touch", for: .normal)
        v.backgroundColor = .red
        return v
    }()
    
    func collectionViewLayout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
        
        myAddButton.translatesAutoresizingMaskIntoConstraints = false
        myAddButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        myAddButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        myAddButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        myAddButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            let estimatedHeight: CGFloat = 32
            let estimatedWeight: CGFloat = 70
            
            if sectionNumber == 0 {
                
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(estimatedWeight),
                    heightDimension: .estimated(estimatedHeight))
                
                let item = NSCollectionLayoutItem(
                    layoutSize: itemSize)
//                    item.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(100))
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item])
                
//                let group = NSCollectionLayoutGroup.horizontal(
//                    layoutSize: NSCollectionLayoutSize(
//                        widthDimension: .fractionalWidth(1),
//                        heightDimension: .absolute(30)),
//                    subitem: item,
//                    count: 1)
                group.interItemSpacing = .fixed(8)
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                
//                section.interGroupSpacing = 12
                // Return
                return section
                
            } else if sectionNumber == 1 {
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
                
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1/5),
                        heightDimension: .fractionalHeight(1/5)),
                    subitem: item,
                    count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                
                let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                              heightDimension: .absolute(50.0))
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: footerHeaderSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .topLeading)
                section.boundarySupplementaryItems = [header]
                section.orthogonalScrollingBehavior = .groupPaging
                
                
                // Return
                return section
            }
            
            
            else {
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        // item의 가로길이는 화면의 3분의 2를 차지한다
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
                
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1/5)),
                    subitem: item,
                    count: 2)
                let section = NSCollectionLayoutSection(group: group)
                return section
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return tagList.count
        } else {
            return sections[section]
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let divider = indexPath.section
        switch divider {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Tag.identifier, for: indexPath) as! Tag
            cell.configure(with: tagList[indexPath.row])
           print(cell.frame.width)
           print(cell.frame.height)
            cell.sizeToFit()
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Item.identifier, for: indexPath)
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Item.identifier, for: indexPath)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Header.identifier, for: indexPath) as! Header
        return headerView
    }
}





import SwiftUI
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Container().edgesIgnoringSafeArea(.all)
    }
    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            return UINavigationController(rootViewController: ViewController())
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
        typealias  UIViewControllerType = UIViewController
    }
}

