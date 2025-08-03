//
//  UIImage+Util.swift
//  DSKit
//
//  Created by SeungMin on 8/3/25.
//

import UIKit

extension UIImage {
    func resized(to size: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        return UIGraphicsImageRenderer(size: size, format: format).image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }.withRenderingMode(renderingMode)
    }
}
