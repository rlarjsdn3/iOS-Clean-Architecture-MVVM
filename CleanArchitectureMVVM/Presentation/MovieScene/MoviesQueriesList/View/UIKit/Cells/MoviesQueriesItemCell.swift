//
//  MoviesQueriesItemCell.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 12/13/24.
//

import UIKit

final class MoviesQueriesItemCell: UITableViewCell {
    static let height = CGFloat(50)
    static let reuseIdentifier = String(describing: MoviesQueriesItemCell.self)
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func fill(with suggestion: MoviesQueryListItemViewModel) {
        self.titleLabel.text = suggestion.query
    }
}
