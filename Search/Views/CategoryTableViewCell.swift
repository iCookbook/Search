//
//  CategoryTableViewCell.swift
//  Search
//
//  Created by Егор Бадмаев on 10.11.2022.
//

import UIKit
import Models

final class CategoryTableViewCell: UITableViewCell {
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        
    }
    
    // MARK: - Public Methods
    
    public func configure(category: Dish) {
        
    }
}
