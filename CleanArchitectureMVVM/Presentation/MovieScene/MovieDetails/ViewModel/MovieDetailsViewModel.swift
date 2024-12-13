//
//  MovieDetailsViewModel.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 12/3/24.
//

import Foundation

protocol MovieDetailsViewModelInput {
    func updatePosterImage(width: Int)
}

protocol MovieDetailsViewModelOutput {
    var title: String { get }
    var posterImage: Observable<Data?> { get }
    var isPosterImageHidden: Bool { get }
    var overview: String { get }
}

protocol MovieDetailsViewModel: MovieDetailsViewModelInput, MovieDetailsViewModelOutput { }

final class DefaultMovieDetailsViewModel: MovieDetailsViewModel {
    
    private let posterImagePath: String?
    private let posterImagesRepository: any PosterImagesRepository
    private var imageLoadTask: (any Cancellable)? { willSet { imageLoadTask?.cancel() } }
    private let mainQueue: any DispatchQueueType
    
    // MARK: - OUTPUT
    let title: String
    let posterImage: Observable<Data?> = Observable(.none)
    let isPosterImageHidden: Bool
    let overview: String
    
    init(
        movie: Movie,
        posterImagesRepository: any PosterImagesRepository,
        mainQueue: any DispatchQueueType = DispatchQueue.main
    ) {
        self.title = movie.title ?? ""
        self.overview = movie.overview ?? ""
        self.posterImagePath = movie.posterPath
        self.isPosterImageHidden = movie.posterPath == nil
        self.posterImagesRepository = posterImagesRepository
        self.mainQueue = mainQueue
    }
}

// MARK: - INPUT. View event methods
extension DefaultMovieDetailsViewModel {
    
    func updatePosterImage(width: Int) {
        guard let posterImagePath = posterImagePath else { return }
        
        imageLoadTask = posterImagesRepository.fetchImage(
            with: posterImagePath,
            width: width
        ) { [weak self] result in
            self?.mainQueue.async {
                guard self?.posterImagePath == posterImagePath else { return }
                switch result {
                case .success(let data):
                    self?.posterImage.value = data
                case .failure: break
                }
                self?.imageLoadTask = nil
            }
        }
    }
}
