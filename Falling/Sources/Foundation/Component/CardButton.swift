//
//  CardButton.swift
//  Falling
//
//  Created by SeungMin on 2023/10/20.
//

import UIKit

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
    case info, refuse, like
    
    var normalImage: UIImage? {
      switch self {
      case .info:
        return FallingAsset.Image.cardInfo.image
          .resize(targetSize: .card)?
          .withTintColor(FallingAsset.Color.neutral50.color)
      case .refuse:
        return FallingAsset.Image.cardRefuse.image
          .resize(targetSize: .card)?
          .withTintColor(FallingAsset.Color.neutral50.color)
      case .like:
        return FallingAsset.Image.cardLike.image
          .resize(targetSize: .card)?
          .withTintColor(FallingAsset.Color.error.color)
      }
    }
    
    var highlightedImage: UIImage? {
      switch self {
      case .info:
        return FallingAsset.Image.cardInfo.image
          .resize(targetSize: .card)?
          .withTintColor(FallingAsset.Color.neutral50.color)
      case .refuse:
        return FallingAsset.Image.cardRefuse.image
          .resize(targetSize: .card)?
          .withTintColor(FallingAsset.Color.neutral50.color)
      case .like:
        return FallingAsset.Image.cardLike.image
          .resize(targetSize: .card)?
          .withTintColor(FallingAsset.Color.neutral50.color)
      }
    }
    
    var normalBackgoundColor: UIColor {
      return FallingAsset.Color.neutral700.color
    }
    
    var highlightedBackgoundColor: UIColor {
      switch self {
      case .like:
        return FallingAsset.Color.error.color
      default:
        return FallingAsset.Color.neutral600.color
      }
    }
    
    var normalStrokeColor: UIColor {
      return FallingAsset.Color.neutral50.color
    }
    
    var highlightedStrokeColor: UIColor {
      switch self {
      case .like:
        return FallingAsset.Color.error.color
      default:
        return FallingAsset.Color.neutral600.color
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
