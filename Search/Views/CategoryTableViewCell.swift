//
//  CategoryTableViewCell.swift
//  Search
//
//  Created by Егор Бадмаев on 10.11.2022.
//

import UIKit
import Models
import Resources

final class CategoryTableViewCell: UITableViewCell {
    
    // MARK: - Private Properties
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.cellTitle()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        contentView.addSubview(mainLabel)
        
        NSLayoutConstraint.activate([
            mainLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.layoutMargins.left * 2),
            mainLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -contentView.layoutMargins.right * 2),
            mainLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentView.layoutMargins.top * 1.5),
            mainLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -contentView.layoutMargins.bottom * 1.5),
        ])
    }
    
    // MARK: - Public Methods
    
    public func configure(category: Dish) {
        mainLabel.text = "\(category.emoji) \(category.rawValue.localized)"
    }
}
