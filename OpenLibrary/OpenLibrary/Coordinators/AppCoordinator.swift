//
//  AppCoordinator.swift
//  OpenLibrary
//
//  Created by vaibhav singh on 20/12/22.
//

import Foundation
import UIKit

/// A protocol describing the signature of a coordinator used to extract navigation code out of viewControllers thus making viewControllers independent of each other
protocol CoordinatorProtocol {
    var navigationController: UINavigationController? { get }
    func start()
}


/// AppCoordinator responsible for starting the flow of the app by initialising and presenting the BookSearchResultViewController
final class AppCoordinator: CoordinatorProtocol {
    
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    /// Function used to initialise the ContentListViewController with all its dependencies
    /// and push it on the navigationController
    func start() {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let requestManager = RequestManager(apiManager: APIManager(), jsonDecoder: jsonDecoder)
        let bookSearchViewModel = BookSearchViewModel(requestManager: requestManager)
        let bookSearchResultViewController = BookSearchViewController(bookSearchViewModel: bookSearchViewModel)
        navigationController?.pushViewController(bookSearchResultViewController, animated: true)
    }
    
    
}
