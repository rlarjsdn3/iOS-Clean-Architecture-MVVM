//
//  BlackStyleNavigationBarBehavior.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 11/29/24.
//

import UIKit

struct BlackStyleNavigationBarBehavior: ViewControllerLifecycleBehavior {
    
    func viewDidLoad(viewController: UIViewController) {
        
        viewController.navigationController?.navigationBar.barStyle = .black
    }
}
