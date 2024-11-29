//
//  BackButtonEmptyTitleNavigationBarBehavior.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 11/29/24.
//

import UIKit

struct BackButtonEmptyTitleNavigationBarBehavior: ViewControllerLifecycleBehavior {
    
    func viewDidLoad(viewController: UIViewController) {
        
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil
        )
    }
}

