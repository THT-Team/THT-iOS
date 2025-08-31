//
//  UIImage+Util.swift
//  DSKit
//
//  Created by SeungMin on 8/3/25.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Metal
import ObjectiveC

extension UIImage {
  func resized(to size: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage {
    let format = UIGraphicsImageRendererFormat()
    format.scale = scale
    return UIGraphicsImageRenderer(size: size, format: format).image { _ in
      self.draw(in: CGRect(origin: .zero, size: size))
    }.withRenderingMode(renderingMode)
  }
  
  
  func applyBlur(radius: CGFloat) -> UIImage {
    let context = CIContext()
    guard let ciImage = CIImage(image: self),
          let clampFilter = CIFilter(name: "CIAffineClamp"),
          let blurFilter = CIFilter(name: "CIGaussianBlur") else {
      return self
    }
    
    clampFilter.setValue(ciImage, forKey: kCIInputImageKey)
    
    blurFilter.setValue(clampFilter.outputImage, forKey: kCIInputImageKey)
    blurFilter.setValue(radius, forKey: kCIInputRadiusKey)
    guard let output = blurFilter.outputImage,
          let cgimg = context.createCGImage(output, from: ciImage.extent) else {
      return self
    }
    return UIImage(cgImage: cgimg)
  }
}

// MARK: - Core Image Gaussian Blur (Clamp → Blur → Crop)
public extension UIImage {
  func gaussianBlurred(radius: CGFloat,
                       scaleAware: Bool = true,
                       context: CIContext = UIImage.sharedCIContext) -> UIImage? {
    guard let inputCI = CIImage(image: self) else { return nil }
    let effectiveRadius = scaleAware ? radius * scale : radius
    
    let clamped = inputCI.clampedToExtent() // CIAffineClamp 내장
    let blurred = clamped.applyingFilter("CIGaussianBlur", parameters: [kCIInputRadiusKey: effectiveRadius])
    let output  = blurred.cropped(to: inputCI.extent)
    
    guard let cg = context.createCGImage(output, from: output.extent) else { return nil }
    return UIImage(cgImage: cg, scale: scale, orientation: imageOrientation)
  }
  
  static let sharedCIContext: CIContext = {
    if let device = MTLCreateSystemDefaultDevice() { return CIContext(mtlDevice: device) }
    return CIContext(options: nil)
  }()
}

// MARK: - UIImageView Blur 토글 (캐시 & 애니메이션)
private enum AssocKey {
  static var originalImage = "blur.originalImage"
  static var blurredImage  = "blur.blurredImage"
}

extension UIImageView {
  private var _originalImage: UIImage? {
    get { objc_getAssociatedObject(self, &AssocKey.originalImage) as? UIImage }
    set { objc_setAssociatedObject(self, &AssocKey.originalImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
  }
  private var _blurredImage: UIImage? {
    get { objc_getAssociatedObject(self, &AssocKey.blurredImage) as? UIImage }
    set { objc_setAssociatedObject(self, &AssocKey.blurredImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
  }
  
  /// 이미지 뷰에 블러 적용/해제 (페이드 전환 + 캐시)
  /// - Parameters:
  ///   - enabled: true면 블러 적용, false면 원본 복귀
  ///   - radius: 블러 반경(포인트 기반, 내부에서 @2x/@3x 고려)
  ///   - duration: 페이드 시간
  func setBlur(enabled: Bool,
               radius: CGFloat = 12,
               duration: TimeInterval = 0.2) {
    // 최초 원본 보관
    if _originalImage == nil, let current = self.image {
      _originalImage = current
    }
    
    let applyBlur: () -> Void = { [weak self] in
      guard let self = self, let original = self._originalImage else { return }
      if self._blurredImage == nil {
        self._blurredImage = original.gaussianBlurred(radius: radius)
      }
      UIView.transition(with: self,
                        duration: duration,
                        options: [.transitionCrossDissolve, .allowAnimatedContent],
                        animations: { self.image = self._blurredImage },
                        completion: nil)
    }
    
    let removeBlur: () -> Void = { [weak self] in
      guard let self = self else { return }
      UIView.transition(with: self,
                        duration: duration,
                        options: [.transitionCrossDissolve, .allowAnimatedContent],
                        animations: { self.image = self._originalImage },
                        completion: nil)
    }
    
    enabled ? applyBlur() : removeBlur()
  }
}
