//
//  SearchResults.swift
//  SearchPhoto
//
//  Created by Maxim Granchenko on 28.01.2020.
//  Copyright © 2020 Maxim Granchenko. All rights reserved.
//

import Foundation

// MARK: - Result
struct SearchResults: Decodable {
    let total: Int
    let results: [UnsplashPhoto]
}

// MARK: - Photo
struct UnsplashPhoto: Decodable {
    let width, height: Int
    let urls: [URLKing.RawValue: String]
    
    
    enum URLKing: String {
        case raw, full, regular, small, thumb
    }
}
