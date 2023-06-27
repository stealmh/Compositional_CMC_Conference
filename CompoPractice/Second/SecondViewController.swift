//
//  SecondViewController.swift
//  CompoPractice
//
//  Created by KindSoft on 2023/06/13.
//

import UIKit
import RxSwift
import RxCocoa
/*
  ============
 | header     |
 |------------|
 | highlights |
 |------------|
 | photos     |
 |            |
  ============
 */

enum Section: Hashable {
    case header
    case story
    case photos
}

enum MyItem: Hashable {
    case header(ProfileHeaderData)
    case story(ProfileHighlight)
    case photo(Animal)
}

// For Typealias
typealias Header = ProfileHeaderCell
typealias Story = StoryCell
typealias PhotoHeader = PhotoHeaderCell
typealias PhotoItem = PhotoCell

typealias Datasource = UICollectionViewDiffableDataSource<Section, MyItem>
typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MyItem>

class SecondViewController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let v = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        v.showsVerticalScrollIndicator = false
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private var dataSource: Datasource!
    var demoProfileData: ProfileHeaderData {
        return ProfileHeaderData(image_url: demoPhoto.value.first?.image_url ?? "", postCount: demoPhoto.value.count)
    }
    let disposeBag = DisposeBag()
    var myProfile = PublishRelay<ProfileHeaderData>()
    var demoPhoto = BehaviorRelay<[Animal]>(value: [])
    
    var mockData: [Photo] = [Photo(image: UIImage(systemName: "house")!)]
    var mockData2: [ProfileHighlight] = [ProfileHighlight(image: UIImage(systemName: "plus")!)]
    
    lazy var right1Button: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "text.justify")!, style: .plain, target: self, action: #selector(buttonTappedDelete))
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.backgroundColor = .gray
        Task { try await getData1() }
        
        secondViewLayout()
        registerCell()
        configureDataSource()
        
        collectionView.delegate = self
        
        myProfile.subscribe(onNext: {_ in
            self.dataSource.apply(self.createSnapshot(), animatingDifferences: true)
        }).disposed(by: disposeBag)
        
        demoPhoto.subscribe(onNext: { value in
            print(value.count)
            self.dataSource.apply(self.createSnapshot(), animatingDifferences: true)
        }).disposed(by: disposeBag)
    }
}
/// Layout + button Action
private extension SecondViewController {
    
    /// 뷰 구성을 위한 컬렉션뷰의 AutoLayout 설정 및 네비게이션 아이템 설정에 관한 함수입니다.
    func secondViewLayout() {
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        self.navigationItem.rightBarButtonItems = [right1Button, right2Button]
    }
    
    // Button Actions
    @objc func buttonPressed() {
        mockData.append(Photo(image: UIImage(named: "popcat")!))
        mockData2.insert(ProfileHighlight(image: UIImage(named: "popcat")!), at: 0)
        dataSource.apply(createSnapshot(), animatingDifferences: true)
    }
    
    @objc func buttonTappedDelete() {
        if mockData2.count != 1 {
            mockData2.remove(at: 0)
            dataSource.apply(createSnapshot(), animatingDifferences: true)
        }
    }
}

/// Diffable + Compositional Method
extension SecondViewController {
    
    ///CollectionView.register를 위해 셀들을 모아놓은 함수 입니다.
    /// .self -> Programmatically
    /// .nib -> Xib
    private func registerCell() {
        collectionView.register(PhotoItem.self, forCellWithReuseIdentifier: PhotoItem.resuseIdentifier)
        collectionView.register(Header.nib, forCellWithReuseIdentifier: Header.resuseIdentifier)
        collectionView.register(PhotoHeader.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PhotoHeader.resueIdentifier)
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
        case .story:
            return createHighlightsSection()
        case .photos:
            return createPhotosSection()
        }
    }
    
    /// 인스타그램의 상단부분 프로필사진 이름 설명이 들어가는 헤더입니다.
    func createHeaderSection() -> NSCollectionLayoutSection {
        let headerItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        let headerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2)), subitems: [headerItem])
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

    private func configureDataSource() {
        dataSource = Datasource(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            return self.cell(collectionView: collectionView, indexPath: indexPath, item: item)}
        
        dataSource.supplementaryViewProvider = { [unowned self] collectionView, kind, indexPath in
            return self.supplementary(collectionView: collectionView, kind: kind, indexPath: indexPath)
        }
        
        dataSource.apply(createSnapshot(), animatingDifferences: true)
    }
    
    ///어떠한 Cell을 사용할 것인지 Enum값에 따라 구분지어주는 함수입니다.
    private func cell(collectionView: UICollectionView, indexPath: IndexPath, item: MyItem) -> UICollectionViewCell{
        switch item {
        case .header(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Header.resuseIdentifier, for: indexPath) as! Header
            cell.configure(data: demoProfileData)
            return cell
            
        case .story(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Story.resuseIdentifier, for: indexPath) as! Story
            cell.configure(with: data)
            return cell
            
        case .photo(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoItem.resuseIdentifier, for: indexPath) as! PhotoItem
            cell.configure(data: data.image_url)
            return cell
        }
    }

    
    /// Cell의 헤더에 필요함!
    private func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PhotoHeader.resueIdentifier, for: indexPath) as! PhotoHeaderCell
        
        return headerView
    }
    
    /// For Snapshot
    private func createSnapshot() -> Snapshot{
        var snapshot = Snapshot()
        snapshot.appendSections([.header, .story, .photos])
        snapshot.appendItems([.header(demoProfileData)], toSection: .header)
        snapshot.appendItems(mockData2.map({ MyItem.story($0) }), toSection: .story)
        snapshot.appendItems(demoPhoto.value.map { MyItem.photo($0) }, toSection: .photos)

        return snapshot
    }
        
    func getData1() async throws{
        let url = URL(string: "https://api.nookipedia.com/villagers")
        let myKey = "4a59aa18-04df-4cae-9a40-6b97b7a29216"
        let version = "1.5.0"
        
        var request = URLRequest(url:url!)
        request.httpMethod = "GET"
        request.setValue(myKey, forHTTPHeaderField: "X-API-KEY")
        request.setValue(version, forHTTPHeaderField: "Accept-version")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode([Animal].self, from: data)
        
        demoPhoto.accept(Array(result[0...7]))
//        demoPhoto.accept(result)
    }
}

extension SecondViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            print("wrong")
            return
            
        }
        switch item {
        case .header:
            print("")
        case .story(let data):
            self.present(UIViewController(), animated: true)
        case .photo(let data):
            print(data.hashValue)
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
