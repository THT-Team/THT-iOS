//
//  UIView+Blurable.swift
//  DSKit
//
//  Created by SeungMin on 8/31/25.
//

import UIKit

public protocol Blurable {
  var layer: CALayer { get }
  var subviews: [UIView] { get }
  var frame: CGRect { get }
  var superview: UIView? { get }
  
  func removeFromSuperview()
  
  func blur(blurRadius: CGFloat)
  func unBlur()
  
  var isBlurred: Bool { get }
}

// Frame 기반 Blur
public extension Blurable {
  
  func blur(blurRadius: CGFloat) {
    guard self.superview != nil else { return }
    
    UIGraphicsBeginImageContextWithOptions(
      CGSize(width: frame.width, height: frame.height),
      false,
      1
    )
    
    layer.render(in: UIGraphicsGetCurrentContext()!)
    
    guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
    
    UIGraphicsEndImageContext();
    
    guard let blur = CIFilter(name: "CIGaussianBlur"),
          let this = self as? UIView else {
      return
    }
    
    blur.setValue(CIImage(image: image), forKey: kCIInputImageKey)
    blur.setValue(blurRadius, forKey: kCIInputRadiusKey)
    
    let ciContext  = CIContext(options: nil)
    
    guard let result = blur.value(forKey: kCIOutputImageKey) as? CIImage else { return }
    
    let boundingRect = CGRect(
      x: 0,
      y: 0,
      width: frame.width,
      height: frame.height
    )
    
    guard let cgImage = ciContext.createCGImage(result, from: boundingRect) else { return }
    
    let filteredImage = UIImage(cgImage: cgImage)
    
    let blurOverlay = BlurOverlay(frame: boundingRect)
    
    blurOverlay.image = filteredImage
    blurOverlay.contentMode = .scaleToFill
    
    if let superview = superview as? UIStackView,
       let index = superview.arrangedSubviews.firstIndex(of: this) {
      removeFromSuperview()
      superview.insertArrangedSubview(blurOverlay, at: index)
    } else {
      blurOverlay.frame.origin = frame.origin
      
      UIView.transition(
        from: this,
        to: blurOverlay,
        duration: .zero,
        options: [.curveEaseIn],
        completion: nil
      )
    }
    
    objc_setAssociatedObject(
      this,
      &BlurableKey.blurable,
      blurOverlay,
      objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
    )
  }
  
  func unBlur() {
    guard let this = self as? UIView,
          let blurOverlay = objc_getAssociatedObject(this, &BlurableKey.blurable) as? BlurOverlay else {
      return
    }
    
    if let superview = blurOverlay.superview as? UIStackView,
       let index = (blurOverlay.superview as? UIStackView)?.arrangedSubviews.firstIndex(of: blurOverlay) {
      blurOverlay.removeFromSuperview()
      superview.insertArrangedSubview(this, at: index)
    } else {
      this.frame.origin = frame.origin
      
      UIView.transition(
        from: blurOverlay,
        to: this,
        duration: .zero,
        options: [.curveEaseIn],
        completion: nil
      )
    }
    
    objc_setAssociatedObject(
      this,
      &BlurableKey.blurable,
      nil,
      objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
    )
  }
  
  var isBlurred: Bool {
    guard let this = self as? UIView else { return false }
    return objc_getAssociatedObject(
      this,
      &BlurableKey.blurable
    ) is BlurOverlay
  }
}

extension UIView: Blurable { }

public class BlurOverlay: UIImageView { }

public struct BlurableKey {
  static var blurable = "blurable"
}
