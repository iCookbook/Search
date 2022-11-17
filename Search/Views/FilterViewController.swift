//
//  FilterViewController.swift
//  Search
//
//  Created by Егор Бадмаев on 17.11.2022.
//

import UIKit
import Resources

protocol FilterDelegateProtocol: AnyObject {
}

final class FilterViewController: UIViewController {
    
    weak var delegate: FilterDelegateProtocol?
    
    // MARK: - Init
    
    init(delegate: FilterDelegateProtocol?) {
        super.init(nibName: nil, bundle: nil)
        
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Images.Search.close, style: .plain, target: self, action: #selector(closeBarButtonTapped))
        
        view.backgroundColor = Colors.systemBackground
    }
    
    @objc private func closeBarButtonTapped() {
        dismiss(animated: true)
    }
}
