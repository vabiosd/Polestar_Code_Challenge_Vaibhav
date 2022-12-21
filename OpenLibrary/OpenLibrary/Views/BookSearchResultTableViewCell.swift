//
//  BookSearchResultTableViewCell.swift
//  OpenLibrary
//
//  Created by vaibhav singh on 20/12/22.
//

import UIKit

struct BookSearchResultCellData {
    let bookTitleAndYear: String
    let authorNameString: String
}

class BookSearchResultTableViewCell: UITableViewCell {
    
    static let cellId = "BookSearchCell"
    
    //MARK: Private View Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    //MARK: Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setting up views
    
    private func setupComponents() {
        
        [titleLabel, authorLabel].forEach {
            contentView.addSubview($0)
        }
        
    }
    
    private func setupConstraints() {
        
        /// Constraining the titleLabel to the top of the cell
        /// The title label can stretch to display varying lengths of the title string
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12)
        ])
        
        /// constraining authorLabel right below the title label
        NSLayoutConstraint.activate([
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            authorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    /// Updating cell with its item data
    func updateCellContent(bookSearchResultCellData: BookSearchResultCellData) {
        titleLabel.text = bookSearchResultCellData.bookTitleAndYear
        authorLabel.text = bookSearchResultCellData.authorNameString
    }
    
    /// Cleanup cell to prepare it for reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = ""
        authorLabel.text = ""
    }

}
