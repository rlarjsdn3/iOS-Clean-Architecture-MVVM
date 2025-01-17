//
//  MoviesSearchFlowCoordinator.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 12/17/24.
//

import UIKit

protocol MoviesSearchFlowCoordinatorDependencies {
    func makeMoviesListViewController(
        actions: MoviesListViewModelActions
    ) -> MoviesListViewController
    func makeMoviesDetailsViewController(movie: Movie) -> UIViewController
    func makeMoviesQueriesSuggestionsListViewController(
        didSelect: @escaping MoviesQueryListViewModelDidSelectAction
    ) -> UIViewController
}

final class MoviesSearchFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: any MoviesSearchFlowCoordinatorDependencies
    
    private weak var moviesListVC: MoviesListViewController?
    private weak var moviesQueriesSuggestionsVC: UIViewController?
    
    init(
        navigationController: UINavigationController?,
        dependencies: any MoviesSearchFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        // Note: here we keep strong reference with actions, this way this flow do not need to be strong referenced
        let actions = MoviesListViewModelActions(
            showMovieDetails: showMovieDetails,
            showMovieQueriesSuggestions: showMovieQueriesSuggestions,
            closeMovieQueriesSuggestions: closeMovieQueriesSuggestions
        )
        
        let vc = dependencies.makeMoviesListViewController(actions: actions)
        
        navigationController?.pushViewController(vc, animated: false)
        moviesListVC = vc
    }
    
    private func showMovieDetails(movie: Movie) {
        let vc = dependencies.makeMoviesDetailsViewController(movie: movie)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showMovieQueriesSuggestions(didSelect: @escaping MoviesQueryListViewModelDidSelectAction) {
        guard let moviesListViewController = moviesListVC,
                moviesQueriesSuggestionsVC == nil,
              let container = moviesListViewController.suggestionsListContainer else { return }
        
        let vc = dependencies.makeMoviesQueriesSuggestionsListViewController(didSelect: didSelect)
        
        moviesListViewController.add(child: vc, container: container)
        moviesQueriesSuggestionsVC = vc
        container.isHidden = false
    }
    
    private func closeMovieQueriesSuggestions() {
        moviesQueriesSuggestionsVC?.remove()
        moviesQueriesSuggestionsVC = nil
        moviesListVC?.suggestionsListContainer.isHidden = true
    }
    
}
