//
//  TFShimmerGradientView.swift
//  SignUp
//
//  Created by kangho lee on 7/7/24.
//

import UIKit

import DSKit

final class TFShimmerGradientView: TFBaseView {
  private var shapeLayer: CAShapeLayer?
  private var conicGradient: CAGradientLayer?
  private var timer: Timer?
  enum Key {
    static let conic = "conic"
  }
  private enum Color {
      static var gradientColors = [
        DSKitAsset.Color.primary500.color,
        DSKitAsset.Color.primary500.color.withAlphaComponent(0.7),
        DSKitAsset.Color.primary500.color.withAlphaComponent(0.4),
        DSKitAsset.Color.thtOrange400.color.withAlphaComponent(0.5),
        DSKitAsset.Color.thtOrange400.color.withAlphaComponent(0.7),
        DSKitAsset.Color.thtOrange400.color,
        DSKitAsset.Color.thtOrange400.color.withAlphaComponent(0.7),
        DSKitAsset.Color.thtOrange400.color.withAlphaComponent(0.5),
        DSKitAsset.Color.primary500.color.withAlphaComponent(0.4),
        DSKitAsset.Color.primary500.color.withAlphaComponent(0.7),
      ]
    }
  private enum Constants {
    static let gradientLocation = [Int](0..<Color.gradientColors.count)
        .map(Double.init)
        .map { $0 / Double(Color.gradientColors.count) }
        .map(NSNumber.init)
    static let cornerRadius = 32.0
      static let cornerWidth = 2.0
    }
  
  deinit {
    self.timer?.invalidate()
    self.timer = nil
  }

  func animate(frame rect: CGRect) {
    if self.shapeLayer == nil {
      let shapeInstance = makeShapeLayer(rect: rect)
      layer.mask = shapeInstance
      self.shapeLayer = shapeInstance
      
      if self.conicGradient == nil {
        let gradientInstance = makeConicGradient(rect: rect, layer: shapeInstance)
        self.layer.addSublayer(gradientInstance)
        self.conicGradient = gradientInstance
      }
    }
    
    self.timer?.invalidate()
    self.timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: {[weak self] _ in
      guard let self else { return }
      self.conicGradient?.removeAnimation(forKey: Key.conic)
      let previous = Color.gradientColors.map(\.cgColor)
      let last = Color.gradientColors.removeLast()
      Color.gradientColors.insert(last, at: 0)
      let lastColors = Color.gradientColors.map(\.cgColor)
      
      let colorsAnimation = CABasicAnimation(keyPath: "colors")
      colorsAnimation.fromValue = previous
      colorsAnimation.toValue = lastColors
      colorsAnimation.repeatCount = 1
      colorsAnimation.duration = 0.2
      colorsAnimation.isRemovedOnCompletion = false
      colorsAnimation.fillMode = .both
      self.conicGradient?.add(colorsAnimation, forKey: Key.conic)
    })
  }
  
  private func makeConicGradient(rect: CGRect, layer mask: CALayer) -> CAGradientLayer {
    let gradient = CAGradientLayer()
    gradient.type = .conic
    gradient.frame = rect
    gradient.colors = Color.gradientColors.map(\.cgColor) as [Any]
    gradient.backgroundColor = DSKitAsset.Color.thtOrange400.color.cgColor
    gradient.locations = Constants.gradientLocation

    // startPoint: 원의 중심, endPoint: 첫 번째 색상과 마지막 색상이 결합되는 지점
    // (0,0)우측하단, (1,1)은 (0,0)에서 한바퀴 돌은 지점
    gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
    gradient.endPoint = CGPoint(x: 0.5, y: 1)
    gradient.mask = mask
    gradient.cornerRadius = Constants.cornerRadius
    return gradient
  }
  
  private func makeShapeLayer(rect: CGRect) -> CAShapeLayer {
    let shape = CAShapeLayer()
    shape.lineWidth = 5
    shape.path = UIBezierPath(
      roundedRect: rect.insetBy(dx: Constants.cornerWidth, dy: Constants.cornerWidth),
      cornerRadius: Constants.cornerRadius).cgPath
    
    shape.cornerRadius = Constants.cornerRadius
    shape.strokeColor = UIColor.white.cgColor
    shape.fillColor = UIColor.clear.cgColor
    return shape
  }
}

