//
//  MoviesListItemCell.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 12/2/24.
//

import UIKit

final class MoviesListItemCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: MoviesListItemCell.self)
    static let height = CGFloat(130)
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    private var viewModel: MoviesListItemViewModel!
    private var posterImagesRepository: any PosterImagesRepository
    private var imageLoadTask: (any Cancellable)? { willSet { imageLoadTask?.cancel() } }
    private var mainQueue: DispatchQueueType = DispatchQueue.main
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
