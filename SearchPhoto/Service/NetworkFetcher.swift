//
//  NetworkFetcher.swift
//  SearchPhoto
//
//  Created by Maxim Granchenko on 28.01.2020.
//  Copyright © 2020 Maxim Granchenko. All rights reserved.
//

import UIKit

class NetworkFetcher {
    
    static let shared = NetworkFetcher()
    
    public func fetchImages(searchTerm: String, completion: @escaping (SearchResults?) -> ()) {
        NetworkService.shared.request(searchTerm: searchTerm) { (data, error) in
            if let err = error {
                print("Error requesting data: \(err.localizedDescription)")
                completion(nil)
            }
            
            let decode = self.decodeJSON(type: SearchResults.self, from: data)
            completion(decode)
        }
    }
    
    fileprivate func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let error {
            print("Failed to decode JSON: \(error.localizedDescription)")
            return nil
        }
    }
}
