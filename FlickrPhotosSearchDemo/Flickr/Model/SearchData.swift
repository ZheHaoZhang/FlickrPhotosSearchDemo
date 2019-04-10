//
//  SearchData.swift
//  FlickrPhotosSearchDemo
//
//  Created by 張哲豪 on 2019/4/10.
//  Copyright © 2019 張哲豪. All rights reserved.
//

import Foundation

struct Photo: Codable {
    let farm: Int
    let secret: String
    let id: String
    let server: String
    let title: String
    var imageUrl: URL {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")!
    }
}

struct PhotoData: Codable {
    let photo: [Photo]
}

struct SearchData: Codable {
    let photos: PhotoData
}


// MARK: Convenience initializers

extension SearchData {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(SearchData.self, from: data) else { return nil }
        self = me
    }
}
