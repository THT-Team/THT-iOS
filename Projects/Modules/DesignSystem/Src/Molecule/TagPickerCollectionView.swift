//
//  TagPickerCollectionView.swift
//  DSKit
//
//  Created by Kanghos on 8/2/24.
//

import UIKit

public final class TagPickerCollectionView: TFBaseCollectionView {

  public convenience init() {
    let layout = LeftAlignCollectionViewFlowLayout(sidePadding: 0)
    layout.scrollDirection = .vertical
    layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    self.init(layout: layout)
  }
  
  public init(layout: UICollectionViewFlowLayout) {
    super.init(frame: .zero, collectionViewLayout: layout)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func makeUI() {
    backgroundColor = .clear
  }

  public override func configure() {
    register(cellType: InputTagCollectionViewCell.self)
    isScrollEnabled = true
    showsVerticalScrollIndicator = false

    delaysContentTouches = false
    canCancelContentTouches = true
  }

  public override func layoutSubviews() {
    super.layoutSubviews()

    guard let superview else { return }
    // Ensure the gradient layers are added only once
    let width = superview.frame.width
    let length = 150.f
    let topSize = CGSize(width: width, height: 200)
    let bottomSize = CGSize(width: width, height: 300)
    let topRect = CGRect(origin: CGPoint(x: .zero, y: superview.frame.origin.y), size: topSize)
    let bottomRect = CGRect(origin: CGPoint(x: .zero, y: superview.frame.maxY - length - 100), size: bottomSize)

    let colors = [UIColor.clear, DSKitAsset.Color.neutral600.color]

    if let top = superview.layer.sublayers?.first(where: { $0.name == "TopGradientLayer" }) {
      top.setNeedsLayout()
      top.layoutIfNeeded()
    } else {
      let topGradientLayer = createTopGradientLayer(bounds: topRect, colors: colors.reversed())
      topGradientLayer.name = "TopGradientLayer"
      superview.layer.addSublayer(topGradientLayer)
    }
    if let bottom = superview.layer.sublayers?.first(where: { $0.name == "BottomGradientLayer" }) {
      bottom.setNeedsLayout()
    } else {
      let bottomGradientLayer = createGradientLayer(bounds: bottomRect, colors: colors)
      bottomGradientLayer.name = "BottomGradientLayer"
      superview.layer.addSublayer(bottomGradientLayer)
    }
  }

  func createGradientLayer(bounds: CGRect, colors: [UIColor]) -> CAGradientLayer {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = bounds
    gradientLayer.colors = colors.map { $0.cgColor }
    gradientLayer.locations = [0, 0.78]
    return gradientLayer
  }

  func createTopGradientLayer(bounds: CGRect, colors: [UIColor]) -> CAGradientLayer {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = bounds
    gradientLayer.colors = colors.map { $0.cgColor }
    gradientLayer.locations = [0, 0.6]
    return gradientLayer
  }
}
