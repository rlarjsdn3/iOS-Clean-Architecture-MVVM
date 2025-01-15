## iOS 클린 아키텍처-MVVM 예제 클론 프로젝트

클린 아키텍처와 MVVM으로 구현한 iOS 예제 클론 프로젝트입니다. **더 자세한 정보는 [여기](https://tech.olx.com/clean-architecture-and-mvvm-on-ios-c9d167d9f5b3)를 참조해주세요.** 원본 리포지토리는 [여기](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM?tab=readme-ov-file)를 참조해주세요. 

![CleanArchitecture+MVVM](https://github.com/user-attachments/assets/e6706a2b-23b8-402c-bcbe-885aebcf8bc6)

## 레이어

* **도메인 레이어** = 엔터티 + 유스케이스 + 리포지토리 인터페이스
* **데이터 레이어** = 리포지토리 구현 + API(네트워크) + 데이터베이스
* **프레젠테이션 레이어(MVVM)** = 뷰-모델 + 뷰

### 의존성 주입

![CleanArchitectureDependencies](https://github.com/user-attachments/assets/30a55844-eead-4f49-86bd-d2483a378603)

**Note:** **도메인 레이어**는 다른 레이어에도 의존하면 안됩니다(예: UIKit이나 SwiftUI, 리포지토리 구현). **프레젠테이션 레이어**와 **데이터 레이어**만 **도메인 레이어**에 의존해야 합니다.

## 아키텍처 개념

* [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
* [Advanced iOS App Architecture](https://www.raywenderlich.com/8477-introducing-advanced-ios-app-architecture)
* [MVVM](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM/blob/master/ExampleMVVM/Presentation/MoviesScene/MoviesQueriesList)
* Data Binding using [Observable](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM/blob/master/ExampleMVVM/Presentation/Utils/Observable.swift) without 3rd party libraries
* [Dependency Injection](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM/blob/master/ExampleMVVM/Application/DIContainer/AppDIContainer.swift)
* [Flow Coordinator](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM/blob/master/ExampleMVVM/Presentation/MoviesScene/Flows/MoviesSearchFlowCoordinator.swift)
* [Data Transfer Object (DTO)](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM/blob/master/ExampleMVVM/Data/Network/DataMapping/MoviesResponseDTO%2BMapping.swift)
* [Response Data Caching](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM/blob/master/ExampleMVVM/Data/Repositories/DefaultMoviesRepository.swift)
* [ViewController Lifecycle Behavior](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM/blob/3c47e8a4b9ae5dfce36f746242d1f40b6829079d/ExampleMVVM/Presentation/Utils/Extensions/UIViewController%2BAddBehaviors.swift#L7)
* [SwiftUI and UIKit view](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM/blob/master/ExampleMVVM/Presentation/MoviesScene/MoviesQueriesList/View/SwiftUI/MoviesQueryListView.swift) implementations by reusing same [ViewModel](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM/blob/master/ExampleMVVM/Presentation/MoviesScene/MoviesQueriesList/ViewModel/MoviesQueryListViewModel.swift) (at least Xcode 11 required)
* Error handling examples: in [ViewModel](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM/blob/201de7759e2d5634e3bb4b5ad524c4242c62b306/ExampleMVVM/Presentation/MoviesScene/MoviesList/ViewModel/MoviesListViewModel.swift#L116), in [Networking](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM/blob/201de7759e2d5634e3bb4b5ad524c4242c62b306/ExampleMVVM/Infrastructure/Network/NetworkService.swift#L84)

## 요구 사항

* Xcode Version 11.2.1+ Swift 5.0+
