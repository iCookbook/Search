//
//  FilterCollectionViewCell.swift
//  Search
//
//  Created by Егор Бадмаев on 25.12.2022.
//

import UIKit
import Models
import Common
import Resources

final class FilterCollectionViewCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            indicatorView.backgroundColor = isSelected ? Colors.appColor : Colors.tertiaryLabel
        }
    }
    
    // MARK: - Private Properties
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.tertiaryLabel
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mainLabel = UILabel()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 40)
        return label
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emojiLabel, mainLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        mainLabel.text = nil
        emojiLabel.text = nil
        indicatorView.backgroundColor = Colors.tertiaryLabel
    }
    
    // MARK: - Public Methods
    
    public func configure(with data: FilterProtocol) {
        mainLabel.text = data.description.capitalizedFirstLetter()
        
        if let emoji = data.emoji {
            emojiLabel.text = emoji
        }
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        contentView.backgroundColor = Colors.systemGroupedBackground
        contentView.addSubview(mainStackView)
        contentView.addSubview(indicatorView)
        
        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            indicatorView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            indicatorView.heightAnchor.constraint(equalToConstant: 8),
            indicatorView.widthAnchor.constraint(equalToConstant: 8),
            
            mainStackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
        ])
    }
}
