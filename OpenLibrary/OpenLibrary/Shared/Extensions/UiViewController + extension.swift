//
//  UiViewController + extension.swift
//  OpenLibrary
//
//  Created by vaibhav singh on 20/12/22.
//

import UIKit

/// An extension to easily add or remove child view controllers
extension UIViewController {
    
    /// This function takes in an optional frame and contains the childViewController within that frame
    func add(_ child: UIViewController?, frame: CGRect? = nil) {
        guard let child = child else {
            return
        }
        
        addChild(child)
        
        if let frame = frame {
            child.view.frame = frame
        }
        
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        /// Just to be safe, we check that this view controller is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
