//
//  CardButton.swift
//  FallingInterface
//
//  Created by SeungMin on 1/11/24.
//

import UIKit

import DSKit

final class CardButton: UIButton {
  
  let type: CardButtonType
  
  init(type: CardButtonType) {
    self.type = type
    super.init(frame: .zero)
    let config = defaultButtonConfig()
    configuration = config
    configurationUpdateHandler = { button in
      switch self.state {
      case .highlighted:
        button.configuration?.background.backgroundColor = type.highlightedBackgoundColor
        button.configuration?.image = type.highlightedImage
        button.configuration?.background.strokeColor = type.highlightedStrokeColor
      default:
        button.configuration?.background.backgroundColor = type.normalBackgoundColor
        button.configuration?.image = type.normalImage
        button.configuration?.background.strokeColor = type.normalStrokeColor
      }
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  enum CardButtonType {
    case info, reject, like
    
    var normalImage: UIImage? {
      switch self {
      case .info:
        return DSKitAsset.Image.Icons.cardInfo.image
          .withTintColor(DSKitAsset.Color.neutral50.color)
      case .reject:
        return DSKitAsset.Image.Icons.cardReject.image
          .withTintColor(DSKitAsset.Color.neutral50.color)
      case .like:
        return DSKitAsset.Image.Icons.cardLike.image
          .withTintColor(DSKitAsset.Color.error.color)
      }
    }
    
    var highlightedImage: UIImage? {
      switch self {
      case .info:
        return DSKitAsset.Image.Icons.cardInfo.image
          .withTintColor(DSKitAsset.Color.neutral50.color)
      case .reject:
        return DSKitAsset.Image.Icons.cardReject.image
          .withTintColor(DSKitAsset.Color.neutral50.color)
      case .like:
        return DSKitAsset.Image.Icons.cardLike.image
          .withTintColor(DSKitAsset.Color.neutral50.color)
      }
    }
    
    var normalBackgoundColor: UIColor {
      return DSKitAsset.Color.neutral700.color
    }
    
    var highlightedBackgoundColor: UIColor {
      switch self {
      case .like:
        return DSKitAsset.Color.error.color
      default:
        return DSKitAsset.Color.neutral600.color
      }
    }
    
    var normalStrokeColor: UIColor {
      return DSKitAsset.Color.neutral50.color
    }
    
    var highlightedStrokeColor: UIColor {
      switch self {
      case .like:
        return DSKitAsset.Color.error.color
      default:
        return DSKitAsset.Color.neutral600.color
      }
    }
  }
  
  func defaultButtonConfig() -> UIButton.Configuration {
    var config = UIButton.Configuration.plain()
    config.cornerStyle = .capsule
    config.background.strokeWidth = 1.5
    return config
  }
}
