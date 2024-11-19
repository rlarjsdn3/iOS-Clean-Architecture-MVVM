//
//  UIImageView+ImageSizeAfterAspectFit.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 11/19/24.
//

import UIKit

extension UIImageView {
    
    var imageSizeAfterAspectFit: CGSize {
        var newWidth: CGFloat
        var newHeight: CGFloat
        
        guard let image = image else { return frame.size }
        
        if image.size.height >= image.size.width {
            newHeight = image.size.height
            newWidth = ((image.size.width / image.size.height) * newHeight)
            
            if newWidth > frame.size.width {
                let diff = frame.size.width - newWidth
                newHeight = newHeight + diff / newHeight * newHeight
                newWidth = frame.size.width
            }
        } else {
            newWidth = image.size.width
            newHeight = ((image.size.height / image.size.width) * newWidth)
            
            if newHeight > frame.size.height {
                let diff = frame.size.height - newHeight
                newWidth = newWidth + diff / newWidth * newWidth
                newHeight = frame.size.height
            }
        }
        
        return .init(width: newWidth, height: newHeight)
    }
    
}
