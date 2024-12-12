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
    private var posterImagesRepository: (any PosterImagesRepository)?
    private var imageLoadTask: (any Cancellable)? { willSet { imageLoadTask?.cancel() } }
    private var mainQueue: DispatchQueueType = DispatchQueue.main
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fill(
        with viewModel: MoviesListItemViewModel,
        posterImagesRepository: (any PosterImagesRepository)?
    ) {
        self.viewModel = viewModel
        self.posterImagesRepository = posterImagesRepository
        
        titleLabel.text = viewModel.title
        dateLabel.text = viewModel.releaseDate
        overviewLabel.text = viewModel.overview
        updatePosterImage(width: Int(posterImageView.imageSizeAfterAspectFit.scaledSize.width))
    }
    
    private func updatePosterImage(width: Int) {
        posterImageView.image = nil
        guard let posterImagePath = viewModel.posterImagePath else { return }
        
        imageLoadTask = posterImagesRepository?.fetchImage(
            with: posterImagePath,
            width: width) { [weak self] result in
                self?.mainQueue.async {
                    guard self?.viewModel.posterImagePath == posterImagePath else { return }
                    if case let .success(data) = result {
                        self?.posterImageView.image = UIImage(data: data)
                    }
                    self?.imageLoadTask = nil
                }
            }
    }
    
    
}
