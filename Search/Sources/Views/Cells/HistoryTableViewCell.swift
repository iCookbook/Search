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
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mainLabel, arrowImageView])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            mainStackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            
            arrowImageView.heightAnchor.constraint(equalToConstant: 11),
            arrowImageView.widthAnchor.constraint(equalToConstant: 11),
        ])
    }
}
