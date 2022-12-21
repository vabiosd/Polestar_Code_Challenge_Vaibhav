//
//  BaseViewController.swift
//  OpenLibrary
//
//  Created by vaibhav singh on 20/12/22.
//

import UIKit

/// A base class where we can add common UI setup and functionality
/// For the purpose of this sample app we are just setting the background colour to adopt dark mode
class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
    }

}
