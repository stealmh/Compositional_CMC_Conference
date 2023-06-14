//
//  SecondViewController.swift
//  CompoPractice
//
//  Created by KindSoft on 2023/06/13.
//

import UIKit

enum Section: Hashable {
    case header
    case highlights
    case photos
}

enum MyItem: Hashable {
    case header(ProfileHeaderData)
    case highlight(ProfileHighlight)
    case photo(Photo)
}

class SecondViewController: UIViewController {
    
    typealias Header = ProfileHeaderCell
    typealias PhotoHeader = PhotoHeaderCell
    typealias Story = StoryCell
    typealias Item = CollectionViewCell
    
    typealias Datasource = UICollectionViewDiffableDataSource<Section, MyItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MyItem>
    
    lazy var collectionView: UICollectionView = {
        let v = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        v.showsVerticalScrollIndicator = false
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private var dataSource: Datasource!
    var demoProfileData: ProfileHeaderData {
        return ProfileHeaderData(name: "Planet Pennies", accountType: "News/Entertainment Company", postCount: 482)
    }
    
    lazy var right1Button: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "text.justify")!, style: .plain, target: self, action: #selector(buttonPressed))
        button.tintColor = .black
        button.width = 10
        button.tag = 1
        
        return button
    }()
    
    lazy var right2Button: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus.square")!, style: .plain, target: self, action: #selector(buttonPressed))
        button.tintColor = .black
        button.tag = 2
        
        return button
    }()
    
    @objc func buttonPressed() {}

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.backgroundColor = .gray
        registerCell()
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        self.navigationItem.rightBarButtonItems = [right1Button, right2Button]
        
        configureDataSource()
    }
}

/// Diffable + Compositional Method
extension SecondViewController {
    
    ///CollectionView.register를 위해 셀들을 모아놓은 함수 입니다.
    private func registerCell() {
        collectionView.register(Item.self, forCellWithReuseIdentifier: Item.identifier)
        collectionView.register(Header.nib, forCellWithReuseIdentifier: Header.resuseIdentifier)
        collectionView.register(PhotoHeader.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PhotoHeaderCell")
        collectionView.register(Story.nib, forCellWithReuseIdentifier: Story.resuseIdentifier)
    }
    
    /// UICollectionView(frame: .zero, collectionViewLayout: _ 에 들어가는 함수)
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [unowned self] index, env in
            return self.sectionFor(index: index, environment: env)
        }
    }
    
    /// 섹션별로 들어갈 수 있게 구분해놓은 함수입니다.
    func sectionFor(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let section = dataSource.snapshot().sectionIdentifiers[index]
        switch section {
        case .header:
            return createHeaderSection()
        case .highlights:
            return createHighlightsSection()
        case .photos:
            return createPhotosSection()
        }
    }
    
    /// 인스타그램의 상단부분 프로필사진 이름 설명이 들어가는 헤더입니다.
    func createHeaderSection() -> NSCollectionLayoutSection {
        let headerItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        let headerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3)), subitems: [headerItem])
        return NSCollectionLayoutSection(group: headerGroup)
    }
    
    /// 가로로 스크롤 되는 동그란 인스타그램 스토리저장소입니다.
    func createHighlightsSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalWidth(0.22)))
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 5)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(80)), subitem: item, count: 4)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    /// 사진/동영상 헤더를 포함한 격자 사진 섹션입니다.
    func createPhotosSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = .init(top: 0, leading: 0, bottom: 3, trailing: 3)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100)), subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        section.boundarySupplementaryItems = [header]
        return section
    }
    /// Cell의 헤더에 필요함!
    private func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PhotoHeaderCell", for: indexPath) as! PhotoHeaderCell
        return headerView
    }
    
    /// For Snapshot
    private func createSnapshot() -> Snapshot{
        var snapshot = Snapshot()
        snapshot.appendSections([.header, .highlights, .photos])
        snapshot.appendItems([.header(demoProfileData)], toSection: .header)
        snapshot.appendItems(ProfileHighlight.demoHighlights.map({ MyItem.highlight($0) }), toSection: .highlights)
        snapshot.appendItems(Photo.demoPhotos.map({ MyItem.photo($0) }), toSection: .photos)

        return snapshot
    }
    
    ///어떠한 Cell을 사용할 것인지 Enum값에 따라 구분지어주는 함수입니다.
    private func cell(collectionView: UICollectionView, indexPath: IndexPath, item: MyItem) -> UICollectionViewCell{
        switch item {
        case .header:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Header.resuseIdentifier, for: indexPath) as! Header
            cell.configure()
            return cell
            
        case .highlight:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Story.resuseIdentifier, for: indexPath) as! Story
            cell.configure(with: UIImage(named: "popcat")!)
            return cell
            
        case .photo:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Item.identifier, for: indexPath)
            return cell
        }
    }

    private func configureDataSource() {
        dataSource = Datasource(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            return self.cell(collectionView: collectionView, indexPath: indexPath, item: item)}
        
        dataSource.supplementaryViewProvider = { [unowned self] collectionView, kind, indexPath in
            return self.supplementary(collectionView: collectionView, kind: kind, indexPath: indexPath)
        }
        
        dataSource.apply(createSnapshot(), animatingDifferences: true)
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
