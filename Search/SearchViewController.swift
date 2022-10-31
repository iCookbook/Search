//
//  SearchViewController.swift
//  Search
//
//  Created by Егор Бадмаев on 27.10.2022.
//  
//

import UIKit
import Resources

final class SearchViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let output: SearchViewOutput
    
    // MARK: - Init
    
    init(output: SearchViewOutput) {
        self.output = output
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Texts.Search.title
        view.backgroundColor = Colors.systemBackground
    }
}

extension SearchViewController: SearchViewInput {
}
