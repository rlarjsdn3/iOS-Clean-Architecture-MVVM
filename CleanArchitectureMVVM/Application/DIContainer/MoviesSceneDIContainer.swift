//
//  MoviesSceneDIContainer.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 12/17/24.
//

import UIKit
import SwiftUI

final class MoviesSceneDIContainer: MoviesSearchFlowCoordinatorDependencies {
    
    struct Dependencies {
        let apiDataTransferService: any DataTransferService
        let imageDataTransferService: any DataTransferService
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Persistent Storage
    lazy var moviesQueriesStorage: any MoviesQueriesStorage = CoreDataMoviesQueriesStorage(maxStorageLimit: 10)
    lazy var moviesResponseCache: any MoviesResponseStorage = CoreDataMoviesResponseStorage()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    func makeSearchMoviesUseCase() -> any SearchMoviesUseCase {
        DefaultSearchMoviesUseCase(
            moviesRepository: makeMoviesRepository(),
            moviesQueriesRepository: makeMoviesQueriesRepository()
        )
    }
    
    func makeFetchRecentMovieQueriesUseCase(
        requestValue: FetchRecentMoviesQueriesUseCase.RequestValue,
        completion: @escaping (FetchRecentMoviesQueriesUseCase.ResultValue) -> Void
    ) -> UseCase {
        FetchRecentMoviesQueriesUseCase(
            requestValue: requestValue,
            completion: completion,
            moviesQuriesRespository: makeMoviesQueriesRepository()
        )
    }
    
    
    // MARK: - Repositories
    func makeMoviesRepository() -> any MoviesRepository {
        DefaultMoviesRepository(
            dataTransferService: dependencies.apiDataTransferService,
            cache: moviesResponseCache
        )
    }
    
    func makeMoviesQueriesRepository() -> any MoviesQueriesRepository {
        DefaultMoviesQueriesRepository(
            moviesQueriesPersistentStorage: moviesQueriesStorage
        )
    }
    
    func makePosterImagesRepository() -> any  PosterImagesRepository {
        DefaultPosterImagesRepository(
            dataTransferService: dependencies.imageDataTransferService
        )
    }
    
    // MARK: - Movies List
    func makeMoviesListViewController(actions: MoviesListViewModelActions) -> MoviesListViewController {
        MoviesListViewController.create(
            with: makeMoviesListViewModel(actions: actions),
            posterImagesRepository: makePosterImagesRepository()
        )
    }
    
    func makeMoviesListViewModel(actions: MoviesListViewModelActions) -> MoviesListViewModel {
        DefaultMoviesListViewModel(
            searchMoviesUseCase: makeSearchMoviesUseCase(),
            actions: actions
        )
    }
    
    // MARK: - Movies Details
    func makeMoviesDetailsViewController(movie: Movie) -> UIViewController {
        MovieDetailsViewController.create(
            with: makeMoviesDetailsViewModel(movie: movie)
        )
    }
    
    func makeMoviesDetailsViewModel(movie: Movie) -> any MovieDetailsViewModel {
        DefaultMovieDetailsViewModel(
            movie: movie,
            posterImagesRepository: makePosterImagesRepository()
        )
    }
    
    
    // MARK: - Movies Queries Suggestions List
    func makeMoviesQueriesSuggestionsListViewController(didSelect: @escaping MoviesQueryListViewModelDidSelectAction) -> UIViewController {
        if #available(iOS 13.0, *) { // SwiftUI
            let view = MoviesQueryListView(viewModelWrapper: makeMoviesQueryListViewModelWrapper(didSelect: didSelect))
            return UIHostingController(rootView: view)
        } else { // UIKit
            return MoviesQueriesTableViewController.create(
                with: makeMoviesQueryListViewModel(didSelect: didSelect)
            )
        }
    }
    
    func makeMoviesQueryListViewModel(didSelect: @escaping MoviesQueryListViewModelDidSelectAction) -> any MoviesQueryListViewModel {
        DefaultMoviesQueryListViewModel(
            numberOfQueriesToShow: 10,
            fetchRecentMovieQueriesUseCaseFactory: makeFetchRecentMovieQueriesUseCase,
            didSelect: didSelect
        )
    }
    
    @available(iOS 13.0, *)
    func makeMoviesQueryListViewModelWrapper(
        didSelect: @escaping MoviesQueryListViewModelDidSelectAction
    ) -> MoviesQueryListViewModelWrapper {
        MoviesQueryListViewModelWrapper(
            viewModel: makeMoviesQueryListViewModel(didSelect: didSelect)
        )
    }
    
    // MARK: - Flow Coordinators
    func makeMoviesSearchFlowCoordinator(navigationController: UINavigationController) -> MoviesSearchFlowCoordinator {
        MoviesSearchFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}

