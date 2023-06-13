//
//  SecondViewController.swift
//  CompoPractice
//
//  Created by KindSoft on 2023/06/13.
//

import UIKit

class SecondViewController: UIViewController {
    
    typealias Header = ProfileHeaderCell
    typealias Story = StoryCell
    typealias Item = CollectionViewCell
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: SecondViewController.createLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.backgroundColor = .gray
        collectionView.register(Item.self, forCellWithReuseIdentifier: Item.identifier)
        collectionView.register(Header.nib, forCellWithReuseIdentifier: Header.resuseIdentifier)
        collectionView.register(Story.nib, forCellWithReuseIdentifier: Story.resuseIdentifier)
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        


    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout {section, env in
            switch section {
            case 0:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(170)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
                return section
            case 1:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalWidth(0.22)))
                item.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(100)), subitem: item, count: 4)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 20, trailing: 0)
                section.orthogonalScrollingBehavior = .continuous
                return section
            default:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(70), heightDimension: .absolute(70)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                return section
                
            }
        }
    }
}

extension SecondViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 5
        default:
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        switch section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Header.resuseIdentifier, for: indexPath) as! Header
            cell.configure()
            cell.backgroundColor = .gray
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Story.resuseIdentifier, for: indexPath) as! Story
            cell.configure(with: UIImage(named: "popcat")!)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    

}



import SwiftUI
struct ContentVie1w_Previews: PreviewProvider {
    static var previews: some View {
        Container().edgesIgnoringSafeArea(.all)
    }
    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            return UINavigationController(rootViewController: SecondViewController())
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
        typealias  UIViewControllerType = UIViewController
    }
}
