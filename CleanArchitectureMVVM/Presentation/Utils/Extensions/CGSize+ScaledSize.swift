//
//  CGSize+ScaledSize.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 11/19/24.
//

import UIKit

extension CGSize {
    var scaledSize: CGSize {
        .init(width: width * UIScreen.main.scale, height: height * UIScreen.main.scale)
    }
}
