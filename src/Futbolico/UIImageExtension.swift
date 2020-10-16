//
//  UIImageExtension.swift
//  Futbolico
//
//  Created by Albert Mercadé on 11/07/2020.
//  Copyright © 2020 Albert Mercadé. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func resizeImage(height: CGFloat) -> UIImage {
        let factor = self.size.height / height
        let width = self.size.width / factor
        let targetSize = CGSize(width: width, height: height)
        
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
