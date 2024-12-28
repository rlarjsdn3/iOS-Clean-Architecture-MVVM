## iOS 클린 아키텍처-MVVM 예제 프로젝트

클린 아키텍처와 MVVM으로 구현한 iOS 예제 프로젝트입니다. **더 자세한 정보는 [여기](https://tech.olx.com/clean-architecture-and-mvvm-on-ios-c9d167d9f5b3)를 참조해주세요.**

![CleanArchitecture+MVVM](https://github.com/user-attachments/assets/e6706a2b-23b8-402c-bcbe-885aebcf8bc6)

## 레이어

* **도메인 레이어** = 엔터티 + 유스케이스 + 리포지토리 인터페이스
* **데이터 레이어** = 리포지토리 구현 + API(네트워크) + 데이터베이스
* **프레젠테이션 레이어(MVVM)** = 뷰-모델 + 뷰

### 의존성 주입

![CleanArchitectureDependencies](https://github.com/user-attachments/assets/30a55844-eead-4f49-86bd-d2483a378603)

**Note:** **도메인 레이어**는 다른 레이어에도 의존하면 안됩니다(예: UIKit이나 SwiftUI, 리포지토리 구현). **프레젠테이션 레이어**와 **데이터 레이어**만 **도메인 레이어**에 의존해야 합니다.

## 기능 사항

* (내용)

## 기술 사항

* (내용)

## 요구 사항

(내용)
