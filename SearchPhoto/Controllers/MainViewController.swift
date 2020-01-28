//
//  MainViewController.swift
//  SearchPhoto
//
//  Created by Maxim Granchenko on 27.01.2020.
//  Copyright © 2020 Maxim Granchenko. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        handleConstraints()
        setupSearchBar()
    }
    
    fileprivate func setup() {
        
        navigationController?.navigationBar.topItem?.title = "Search Images"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
    }
}

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
//        navigationItem.hidesSearchBarWhenScrolling = false
//        seacrhController.hidesNavigationBarDuringPresentation = false
//        seacrhController.obscuresBackgroundDuringPresentation = false
        seacrhController.searchBar.delegate = self
    }
}

//MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    
}

//MARK: - UITabelViewDataSource
extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
}

//MARK: - UITabelViewDelegate
extension MainViewController: UITableViewDelegate {
    
}
