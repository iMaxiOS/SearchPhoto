//
//  MainViewController.swift
//  SearchPhoto
//
//  Created by Maxim Granchenko on 27.01.2020.
//  Copyright © 2020 Maxim Granchenko. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var searchText = ""
    fileprivate var isValidSearch = false
    var photoList = [Photo]()
    var searchPhoto: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        handleConstraints()
        setupSearchBar()
    }
    
    fileprivate func setup() {
        
        navigationController?.navigationBar.topItem?.title = "Images"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(PhotoCell.self, forCellReuseIdentifier: PhotoCell.reuseID)
        tableView.rowHeight = 90
        tableView.dataSource = self
        
        let realm = try! Realm()
        photoList = Array(realm.objects(Photo.self)).sorted(by: { $0.date > $1.date })
    }
}

//MARK: - extension MainViewController
extension MainViewController {
    
    fileprivate func handleConstraints() {
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    fileprivate func setupSearchBar() {
        
        let seacrhController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = seacrhController
        seacrhController.hidesNavigationBarDuringPresentation = false
        seacrhController.obscuresBackgroundDuringPresentation = false
        seacrhController.searchBar.delegate = self
    }
}

//MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isValidSearch = false
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        NetworkFetcher.shared.fetchImages(searchTerm: searchText) { [weak self] searchResults in
            guard let result = searchResults?.results else { return }
            if result.isEmpty {
                self?.isValidSearch = false
                let alertController = UIAlertController(title: "Not found",
                                                        message: "No results were found for your request",
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    searchBar.becomeFirstResponder()
//                    self?.tableView.reloadData()
                }))
                self?.present(alertController, animated: true, completion: nil)
            } else {
                self?.isValidSearch = true
                DispatchQueue.main.async {
                    let randomIndex = Int(arc4random_uniform(UInt32(result.count)))
                    let resultPhoto = result[randomIndex]
                    let realm = try! Realm()
                    let id = UUID().uuidString
                    let url = resultPhoto.urls["small"] ?? ""
                    try? realm.write {
                        self?.searchPhoto = realm.create(Photo.self,
                                                         value: ["id" : id, "url": url, "category": self?.searchText],
                                                         update: .modified)
                    }
                    
                    self?.tableView.reloadData()
                    self?.photoList = Array(realm.objects(Photo.self)).sorted(by: { $0.date > $1.date })
                }
            }
        }
    }
}

//MARK: - UITabelViewDataSource
extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isValidSearch ? 1 : photoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoCell.reuseID, for: indexPath) as! PhotoCell
        if isValidSearch, let photo = searchPhoto {
            let url = URL(string: photo.url)
            DispatchQueue.global().async {
                if let url = url, let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        cell.photoImageView.image = UIImage(data: data)
                    }
                }
            }
            cell.searchTitle.text = photo.category
        } else {
            let photo = photoList[indexPath.row]
            let url = URL(string: photo.url)
            DispatchQueue.global().async {
                if let url = url, let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        cell.photoImageView.image = UIImage(data: data)
                    }
                }
            }
            cell.searchTitle.text = photo.category
        }
        
        return cell
    }
}
