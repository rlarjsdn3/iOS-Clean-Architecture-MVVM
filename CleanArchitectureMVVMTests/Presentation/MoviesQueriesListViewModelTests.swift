//
//  MoviesQueriesListViewModelTests.swift
//  CleanArchitectureMVVMTests
//
//  Created by 김건우 on 12/26/24.
//

import XCTest

class MoviesQueriesListViewModelTests: XCTestCase {
    
    private enum FetchRecentQueriedUseCase: Error {
        case someError
    }
    
    var movieQueries = [MovieQuery(query: "query1"),
                        MovieQuery(query: "query2"),
                        MovieQuery(query: "query3"),
                        MovieQuery(query: "query4"),
                        MovieQuery(query: "query5")]
    
    class FetchRecentMovieQueryUseCaseMock: UseCase {
        var startCalledCount: Int = 0
        var error: (any Error)?
        var movieQueries: [MovieQuery] = []
        var completion: (Result<[MovieQuery], any Error>) -> Void = { _ in }
        
        func start() -> (any Cancellable)? {
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(movieQueries))
            }
            startCalledCount += 1
            return nil
        }
    }
    
    func makeFetchRecentMovieQueriesUseCase(_ mock: FetchRecentMovieQueryUseCaseMock) -> FetchRecentMovieQueriesUseCaseFactory {
        return { _, completion in
            mock.completion = completion
            return mock
        }
    }
    
    func test_whenFetchRecentMovieQueriesUseCaseReturnsQueries_thenShowTheseQueries() {
        // given
        let useCase = FetchRecentMovieQueryUseCaseMock()
        useCase.movieQueries = movieQueries
        let viewModel = DefaultMoviesQueryListViewModel.make(
            numberOfQueriesToShow: 3,
            fetchRecentMovieQueriesUseCaseFactory: makeFetchRecentMovieQueriesUseCase(useCase)
        )
        
        // when
        viewModel.viewWillAppear()
        
        // then
        XCTAssertEqual(viewModel.items.value.map { $0.query }, movieQueries.map { $0.query })
        XCTAssertEqual(useCase.startCalledCount, 1)
    }
    
    func test_whenFetchRecentMovieQueriesUseCaseReturnsError_thenDontShowAnyQuery() {
        // given
        let useCase = FetchRecentMovieQueryUseCaseMock()
        useCase.error = FetchRecentQueriedUseCase.someError
        let viewModel = DefaultMoviesQueryListViewModel.make(
            numberOfQueriesToShow: 3,
            fetchRecentMovieQueriesUseCaseFactory: makeFetchRecentMovieQueriesUseCase(useCase)
        )
        
        // when
        viewModel.viewWillAppear()
        
        // then
        XCTAssertTrue(viewModel.items.value.isEmpty)
        XCTAssertEqual(useCase.startCalledCount, 1)
    }
    
    func test_whenDidSelectQueryEventIsReceived_thenCallDidSelectAction() {
        // given
        let selectedQueryItem = MovieQuery(query: "query1")
        var actionMovieQuery: MovieQuery?
        var delegateNotifedCount = 0
        let didSelect: MoviesQueryListViewModelDidSelectAction = { movieQuery in
            actionMovieQuery = movieQuery
            delegateNotifedCount += 1
        }
        
        let viewModel = DefaultMoviesQueryListViewModel.make(
            numberOfQueriesToShow: 3,
            fetchRecentMovieQueriesUseCaseFactory: makeFetchRecentMovieQueriesUseCase(FetchRecentMovieQueryUseCaseMock()),
            didSelect: didSelect
        )
        
        // when
        viewModel.didSelect(item: MoviesQueryListItemViewModel(query: selectedQueryItem.query))
        
        // then
        XCTAssertEqual(actionMovieQuery, selectedQueryItem)
        XCTAssertEqual(delegateNotifedCount, 1)
    }
    
}


extension DefaultMoviesQueryListViewModel {
    static func make(
        numberOfQueriesToShow: Int,
        fetchRecentMovieQueriesUseCaseFactory: @escaping FetchRecentMovieQueriesUseCaseFactory,
        didSelect: MoviesQueryListViewModelDidSelectAction? = nil
    ) -> DefaultMoviesQueryListViewModel {
        DefaultMoviesQueryListViewModel(
            numberOfQueriesToShow: numberOfQueriesToShow,
            fetchRecentMovieQueriesUseCaseFactory: fetchRecentMovieQueriesUseCaseFactory,
            didSelect: didSelect,
            mainQueue: DispatchQueueTypeMock()
        )
    }
}
