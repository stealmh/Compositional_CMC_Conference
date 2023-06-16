//
//  Model.swift
//  CompoPractice
//
//  Created by KindSoft on 2023/06/14.
//

import UIKit

struct Animal: Codable, Hashable {
    let id = UUID()
    let name: String
    let quote: String
    let species: String
    let image_url: String
}

extension Animal {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct ProfileHeaderData: Hashable {
    let id = UUID()
    let image_url: String
    let postCount: Int
}

//MARK: -

struct ProfileHighlight: Hashable {
    let id = UUID()
    let image: UIImage
}

extension ProfileHighlight {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

extension ProfileHighlight {
    static var demoHighlights: [ProfileHighlight] {
        let imageNames = (1...7).map({ "flower\($0)" })
        
        return imageNames.map({ _ in ProfileHighlight(image: UIImage(named: "popcat")!) })
    }
}

//MARK: -

struct Photo {
    let id = UUID()
    let image: UIImage
}

extension Photo: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Photo {
    static var demoPhotos: [Photo] {
        let names = (1...8).map({ "photo\($0)" })
        
        return names.map({ _ in Photo(image: UIImage(named: "popcat")!) })
    }
}
