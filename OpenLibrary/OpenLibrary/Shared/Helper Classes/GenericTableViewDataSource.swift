//
//  GenericTableViewDataSource.swift
//  OpenLibrary
//
//  Created by vaibhav singh on 20/12/22.
//

import Foundation
import UIKit

/// A generic data source that can be used for any tableview!
class GenericTableViewDataSource<Model>: NSObject, UITableViewDataSource {
    /// A cell configurator used to configure a generic cell using a generic model
    typealias CellConfigurator = (Model, UITableViewCell) -> Void
    
    var models: [Model]
    
    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator
    
    init(models: [Model],
         reuseIdentifier: String,
         cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }
    
    //MARK: TableView Data Source
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: reuseIdentifier,
            for: indexPath
        )
        
        /// Using the cell configurator to configure the cell
        cellConfigurator(model, cell)
        
        return cell
    }
}
