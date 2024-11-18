//
//  UIViewController+AddBehaviors.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 11/18/24.
//

import UIKit

protocol ViewControllerLifecycleBehavior {
    func viewDidLoad(viewController: UIViewController)
    func viewWillAppear(viewController: UIViewController)
    func viewIsAppearing(viewController: UIViewController)
    func viewDidAppear(viewController: UIViewController)
    func viewWillDisappear(viewController: UIViewController)
    func viewDidDisappear(viewController: UIViewController)
    func viewWillLayoutSubviews(viewController: UIViewController)
    func viewDidLayoutSubviews(viewController: UIViewController)
}
// Default implementations
extension ViewControllerLifecycleBehavior {
    func viewDidLoad(viewController: UIViewController) { }
    func viewWillAppear(viewController: UIViewController) { }
    func viewIsAppearing(viewController: UIViewController) { }
    func viewDidAppear(viewController: UIViewController) { }
    func viewWillDisappear(viewController: UIViewController) { }
    func viewDidDisappear(viewController: UIViewController) { }
    func viewWillLayoutSubviews(viewController: UIViewController) { }
    func viewDidLayoutSubviews(viewController: UIViewController) { }
}

extension UIViewController {
    /*
     Add behaviors to be hooked into this view controller's lifecycle.
     
     This methods requires the view controller's view to be loaded, it's best to call
     in `viewDidLoad` to avoid it being loaded prematurely.
     
     - parameter behaviors: Behaviors to be added.
     */
    func addBehaviors(_ behaviors: [any ViewControllerLifecycleBehavior]) {
        let behaviorViewController = LifecycleBehaviorViewController(behaviors: behaviors)
        
        addChild(behaviorViewController)
        view.addSubview(behaviorViewController.view)
        behaviorViewController.didMove(toParent: self)
    }
    
    private final class LifecycleBehaviorViewController: UIViewController, UIGestureRecognizerDelegate {
        private let behaviors: [any ViewControllerLifecycleBehavior]
        
        // MARK: - Lifecycle
        
        init(behaviors: [any ViewControllerLifecycleBehavior]) {
            self.behaviors = behaviors
            
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.isHidden = true
            
            applyBehaviors { behavior, viewController in
                behavior.viewDidLoad(viewController: viewController)
            }
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            applyBehaviors { behavior, viewController in
                behavior.viewWillAppear(viewController: viewController)
            }
        }
        
        override func viewIsAppearing(_ animated: Bool) {
            super.viewIsAppearing(animated)
            
            applyBehaviors { behavior, viewController in
                behavior.viewIsAppearing(viewController: viewController)
            }
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            applyBehaviors { behavior, viewController in
                behavior.viewDidAppear(viewController: viewController)
            }
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            applyBehaviors { behavior, viewController in
                behavior.viewDidAppear(viewController: viewController)
            }
        }
        
        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            
            applyBehaviors { behavior, viewController in
                behavior.viewDidDisappear(viewController: viewController)
            }
        }
        
        override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
            
            applyBehaviors { behavior, viewController in
                behavior.viewWillLayoutSubviews(viewController: viewController)
            }
        }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            
            applyBehaviors { behavior, viewController in
                behavior.viewDidLayoutSubviews(viewController: viewController)
            }
        }
        
        
        // MARK: - Private
        
        private func applyBehaviors(body: (_ behavior: any ViewControllerLifecycleBehavior, _ viewController: UIViewController) -> Void) {
            guard let parent = parent else { return }
            
            for behavior in behaviors {
                body(behavior, parent)
            }
        }
    }
}
