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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        NetworkFetcher.shared.fetchImages(searchTerm: searchText) { [weak self] searchResults in
            guard let result = searchResults?.results else { return }
            let randomIndex = Int(arc4random_uniform(UInt32(result.count)))
            let resultPhoto = result[randomIndex]
            DispatchQueue.main.async {
                let url = resultPhoto.urls["small"] ?? ""
                let realm = try! Realm()
                try? realm.write {
                    realm.create(Photo.self, value: ["id" : "1", "url": url, "category": self?.searchText],
                                 update: .modified)
                }
                self?.tableView.reloadData()
            }
        }
    }
}

//MARK: - UITabelViewDataSource
extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        return realm.objects(Photo.self).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoCell.reuseID, for: indexPath) as! PhotoCell
        let realm = try! Realm()
        let photo = realm.objects(Photo.self).first
        let url = URL(string: photo?.url ?? "")
        DispatchQueue.global().async {
            if let url = url, let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    cell.photoImageView.image = UIImage(data: data)
                }
            }
        }
        cell.searchTitle.text = photo?.category
        return cell
    }
}
