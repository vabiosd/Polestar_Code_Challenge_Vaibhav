//
//  ErrorViewController.swift
//  OpenLibrary
//
//  Created by vaibhav singh on 20/12/22.
//

import UIKit

/// A basic ErrorViewController class than can be used as a childViewController to show/hide error states
class ErrorViewController: BaseViewController {
    
    let errorString: String = ""
    var retryButtonTapped: ( () -> ())?
    
    //MARK: Private View properties
    
    private lazy var errorView: UILabel = {
        let errorView = UILabel()
        errorView.numberOfLines = 0
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorView.textAlignment = .center
        return errorView
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        
        view.addSubview(errorView)
        view.addSubview(retryButton)
        
        retryButton.addTarget(self, action: #selector(handleRetry), for: .touchUpInside)
        retryButton.setTitle(LocalizableStrings.retryButtonTitle, for: .normal)
        
        NSLayoutConstraint.activate([
            errorView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            errorView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            retryButton.widthAnchor.constraint(equalToConstant: 100),
            retryButton.topAnchor.constraint(equalTo: errorView.bottomAnchor, constant: 12),
        ])
    }
    
    func showError(errorString: String) {
        errorView.text = errorString
    }
    
    @objc func handleRetry() {
        retryButtonTapped?()
    }
    
    func showRetryButton() {
        retryButton.isHidden = false
    }
    
    func hideRetryButton() {
        retryButton.isHidden = true
    }

}
