//
//  ViewController.swift
//  OpenLibrary
//
//  Created by vaibhav singh on 16/12/22.
//

import UIKit
import Foundation

/// An enum depicting various states of the content list
enum BookSearchState: Equatable {
    case searching
    case displayingResults
    case errorSearching(String)
    case noResults(String)
}

class BookSearchViewController: BaseViewController {
    
    //MARK: Private properties
    
    /// ViewModel to fetch and provide search results to the ViewController
    private let bookSearchViewModel: BookSearchViewModel
    /// Using a generic data source class to extract the dataSource logic from the viewController
    private var bookSearchResultDataSource: GenericTableViewDataSource<BookSearchResultCellData>?
    
    /// Loading and Error childViewController to help extract the loading and error UI handling out of the ContentListViewController
    private lazy var loadingViewController = LoadingViewController()
    private lazy var errorViewController = ErrorViewController()
    
    //MARK: View Properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        /// Allowing the tableView cells to stretch to display varying sizes of content
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120.0
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for your favourite books.."
        return searchController
    }()
    
    //MARK: Init
    
    init(bookSearchViewModel: BookSearchViewModel) {
        self.bookSearchViewModel = bookSearchViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(" No storyboard found!")
    }

    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupComponents()
        setupConstraints()
        bindState()
    }
    
    //MARK: Setting up views
    
    private func setupComponents() {
        
        navigationItem.title = "Book Search Engine"
        
        navigationItem.searchController = searchController

        /// Setting up tableview
        tableView.register(BookSearchResultTableViewCell.self, forCellReuseIdentifier: BookSearchResultTableViewCell.cellId)
        
        errorViewController.retryButtonTapped = { [weak self] in
            guard let text = self?.searchController.searchBar.text else { return }
            self?.bookSearchViewModel.fetchBooks(searchString: text)
        }
    
        /// Adding subviews
        [tableView].forEach{
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
   //MARK: Setting up viewModel bindings
    
    private func bindState() {
        bookSearchViewModel.updateBookSearchState = {[weak self] state in
            self?.handleUI(forState: state)
        }
    }
    
    private func handleUI(forState state: BookSearchState) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            /// Updating the UI based on the state
            switch state {
            case .noResults(let errorString):
                /// Remove loading ViewController
                self.loadingViewController.remove()
                
                /// Display no content message using the errorViewController
                self.add(self.errorViewController)
                self.errorViewController.hideRetryButton()
                self.errorViewController.showError(errorString: errorString)
                self.searchController.searchBar.isUserInteractionEnabled = true
            case .searching:
                /// In case user retries remove the error state
                self.errorViewController.remove()
                /// Add the loadingViewController to show loading state
                self.add(self.loadingViewController)
                self.searchController.searchBar.isUserInteractionEnabled = false
            case .errorSearching(let errorString):
                /// Remove loading ViewController
                self.loadingViewController.remove()
                
                /// Display error using the errorViewController
                self.add(self.errorViewController)
                self.errorViewController.showRetryButton()
                self.errorViewController.showError(errorString: errorString)
                self.searchController.searchBar.isUserInteractionEnabled = true
            case .displayingResults :
                /// Remove the loading state
                self.loadingViewController.remove()
                self.tableView.isHidden = false
                self.setupTableViewDataSource()
                self.searchController.searchBar.isUserInteractionEnabled = true
            }
        }
    }
    
    /// Setting up the generic data source
    private func setupTableViewDataSource() {
        /// Since tableview keeps a weak reference to the data source
        ///  we keep a strong reference inside the viewController
        bookSearchResultDataSource = GenericTableViewDataSource(models: bookSearchViewModel.bookSearchResults,
                                                                    reuseIdentifier: BookSearchResultTableViewCell.cellId,
                                                                    cellConfigurator: { bookSearchResultCellData, cell in
            (cell as? BookSearchResultTableViewCell)?.updateCellContent(bookSearchResultCellData: bookSearchResultCellData)
        })
        tableView.dataSource = bookSearchResultDataSource
        tableView.reloadData()
    }
}

// MARK: TableViewDelegate

extension BookSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchController.searchBar.text else { return }
        bookSearchViewModel.fetchBooks(searchString: text)
    }
}


