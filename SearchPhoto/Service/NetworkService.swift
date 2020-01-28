//
//  NetworkService.swift
//  SearchPhoto
//
//  Created by Maxim Granchenko on 28.01.2020.
//  Copyright © 2020 Maxim Granchenko. All rights reserved.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    
    //Create request data to URL
    public func request(searchTerm: String, completion: @escaping (Data?, Error?) -> Void) {
        let param = self.prepareParaments(searchTerm: searchTerm)
        let url = self.url(params: param)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepateHeader()
        request.httpMethod = "get"
        let task = createDataTask(request: request, completion: completion)
        task.resume()
    }
    
    //Create ID
    fileprivate func prepateHeader() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID ae51ed158b4506068c85a4e62bf5f75f4e31e9ce863cbf46515418e41370ddc4"
        return headers
    }
    
    //Create paraments
    fileprivate func prepareParaments(searchTerm: String?) -> [String: String] {
        var parameters = [String: String]()
        parameters["query"] = searchTerm
        parameters["page"] = String(1)
        parameters["per_page"] = String(10)
        return parameters
    }
    
    //Create path to url
    fileprivate func url(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = params.map({ URLQueryItem(name: $0, value: $1) })
        return components.url!
    }
    
    //Create DataTask
    fileprivate func createDataTask(request: URLRequest,
                                    completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}
