//
//  HistoryTableViewCell.swift
//  Search
//
//  Created by Егор Бадмаев on 13.11.2022.
//

import UIKit
import Resources

final class HistoryTableViewCell: UITableViewCell {
    
    // MARK: - Private Properties
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.systemBody()
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView(image: Images.Search.searchArrow)
        return imageView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mainLabel, arrowImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Public Methods
    
    public func configure(title: String) {
        mainLabel.text = title
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        contentView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
