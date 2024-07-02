//
//  GenderPickerView.swift
//  MyPage
//
//  Created by kangho lee on 7/23/24.
//

import UIKit
import DSKit

import SignUpInterface
import Core

final class PreferGenderCell: TFBaseCollectionViewCell, SelectableCellType, textBindable {
  enum Image {
    static let both = DSKitAsset.Image.Icons.both.image
    static let single = DSKitAsset.Image.Icons.single.image
  }
  
  enum Color {
    static let selected = DSKitAsset.Color.primary500.color
    static let unselected = DSKitAsset.Color.neutral600.color
  }
  
  private lazy var imageContianerView = UIView().then {
    $0.backgroundColor = Color.unselected
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 12
    $0.layer.borderWidth = 1
    $0.layer.borderColor = Color.selected.cgColor
  }
  
  private let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  private let titlelabel = UILabel().then {
    $0.textColor = Color.unselected
    $0.textAlignment = .center
    $0.font = .thtSubTitle2Sb
  }
  
  override var isSelected: Bool {
    didSet {
      
      setNeedsDisplay()
    }
  }

  public override var isHighlighted: Bool {
    didSet {

      guard isHighlighted else { return }
      HapticFeedbackManager.shared.triggerImpactFeedback(style: .soft)
      UIView.animate(
        withDuration: 0.1,
        animations: { self.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)},
        completion: { finished in
          UIView.animate(withDuration: 0.1) { self.transform = .identity }
        })
    }
  }

  override func makeUI() {
    contentView.addSubviews(imageContianerView, imageView, titlelabel)
    imageContianerView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
    }
    imageView.snp.makeConstraints {
      $0.edges.equalTo(imageContianerView).inset(10)
    }
    titlelabel.snp.makeConstraints {
      $0.top.equalTo(imageContianerView.snp.bottom).offset(5)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }

  func bind(_ text: String) {
    titlelabel.text = text
    imageView.image = GenderAdapter.image(text)
  }

  func updateCell(_ isSelected: Bool) {
    titlelabel.textColor = isSelected
    ? Color.selected
    : DSKitAsset.Color.neutral300.color

    imageContianerView.layer.borderColor = isSelected
    ? Color.selected.cgColor
    : Color.unselected.cgColor

    imageContianerView.backgroundColor = isSelected
    ? DSKitAsset.Color.neutral900.color
    : DSKitAsset.Color.neutral700.color
    setNeedsDisplay()
  }

  func bind(_ item: PreferGenderItemVM) {
    imageView.image = GenderAdapter.image(item.value)
    titlelabel.text = item.value.title
    titlelabel.textColor = item.isSelected
    ? Color.selected
    : DSKitAsset.Color.neutral300.color
    imageContianerView.layer.borderColor = item.isSelected
    ? Color.selected.cgColor
    : Color.unselected.cgColor
    imageContianerView.backgroundColor = item.isSelected
    ? DSKitAsset.Color.neutral900.color
    : DSKitAsset.Color.neutral700.color
    setNeedsDisplay()
  }
  
  struct GenderAdapter {
    static func image(_ title: String) -> UIImage {
      switch title {
      case "모두": return Image.both
      default: return Image.single
      }
    }
    static func image(_ gender: Gender) -> UIImage {
      switch gender {
      case .male, .female:
        return Image.single
      case .bisexual:
        return Image.both
      }
    }
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct ViewPreview: PreviewProvider {
  
  static var previews: some View {
    UIViewPreview {
      let comp = PreferGenderCell(frame: .zero)
      return comp
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
