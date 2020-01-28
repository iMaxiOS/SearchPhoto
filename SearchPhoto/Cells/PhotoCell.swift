//
//  PhotoCell.swift
//  SearchPhoto
//
//  Created by Maxim Granchenko on 28.01.2020.
//  Copyright © 2020 Maxim Granchenko. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {
    
    static let reuseID = "PhotoCellID"
    
    public let photoImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
    }()
    
    private let category: UILabel = {
        let label = UILabel()
        label.text = "category:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let searchTitle: UILabel = {
        let label = UILabel()
        label.text = "cat"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photoImageView.image = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

//MARK: - extension PhotoCell
extension PhotoCell {
    
    private func setupUI() {
        addSubview(photoImageView)
        addSubview(category)
        addSubview(searchTitle)
        
        photoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        photoImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        category.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor).isActive = true
        category.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 10).isActive = true
        category.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        searchTitle.centerYAnchor.constraint(equalTo: category.centerYAnchor).isActive = true
        searchTitle.leadingAnchor.constraint(equalTo: category.trailingAnchor, constant: 5).isActive = true
        searchTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        
    }
}
