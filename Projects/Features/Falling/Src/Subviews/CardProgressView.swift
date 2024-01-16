//
//  CardProgressView.swift
//  FallingInterface
//
//  Created by SeungMin on 1/11/24.
//

import UIKit

import Core
import DSKit

final class CardProgressView: TFBaseView {
  var progress: CGFloat = 0 {
    didSet {
      setNeedsDisplay()
    }
  }
  
  var progressBarColor: UIColor = DSKitAsset.Color.neutral600.color {
    didSet {
      setNeedsLayout()
    }
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    let progressBarRect = CGRect(x: 0,
                                 y: 0,
                                 width: rect.width * progress,
                                 height: rect.height)
    let progressBarPath = UIBezierPath(roundedRect: progressBarRect, cornerRadius: rect.height / 2.0)
    
    progressBarColor.setFill()
    progressBarPath.fill()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.layer.cornerRadius = self.frame.height / 2.0
  }
  
  override func makeUI() {
    self.layer.masksToBounds = true
    self.backgroundColor = DSKitAsset.Color.neutral600.color
  }
}
