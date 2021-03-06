//
//  Photo.swift
//  SearchPhoto
//
//  Created by Maxim Granchenko on 28.01.2020.
//  Copyright © 2020 Maxim Granchenko. All rights reserved.
//

import RealmSwift

final class Photo: Object {
    @objc dynamic public var id = ""
    @objc dynamic public var url = ""
    @objc dynamic public var category = ""
    @objc dynamic public var date = Date()
    @objc dynamic public var imageCache = Data()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

