//
//  MyPageCellContainerView.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/14/24.
//

import UIKit

import DSKit

import Then
import SnapKit
import MyPageInterface

// MARK: Falling Cell Layout이 섹션 레이아웃인데 섹션이 아니고 셀이라서 셀 사이 간격을 위해 custom 개발함.

final class MyPageCellContainerView: TFBaseView {
  enum IconType {
    case rightArrow
    case pin

    var image: UIImage {
      switch self {
      case .rightArrow:
        return DSKitAsset.Image.Component.chevronRight.image
          .withTintColor(DSKitAsset.Color.neutral50.color, renderingMode: .alwaysOriginal)
      case .pin:
        return DSKitAsset.Image.Icons.locationSetting.image
      }
    }
  }

  var accessoryView: UIView? = nil {
    didSet {
      if let oldValue {
        oldValue.removeFromSuperview()
      }
      if let accessoryView {
        contentStackView.addArrangedSubview(accessoryView)
      }
    }
  }

  var accessoryType: IconType? = nil {
    didSet {
      contentImage.isHidden = accessoryType == nil
      contentImage.image = accessoryType?.image
    }
  }

  var text: String? {
    didSet {
      titleLabel.isHidden = text == nil
      titleLabel.text = text
    }
  }

  var secondaryText: String? {
    didSet {
      secondaryTitleLabel.isHidden = secondaryText == nil
      secondaryTitleLabel.text = secondaryText
    }
  }

  var contentText: String? {
    didSet {
      contentLabel.isHidden = contentText == nil
      contentLabel.text = contentText
    }
  }

  var isEditable: Bool = false {
    didSet {
      contentLabel.textColor = isEditable
      ? DSKitAsset.Color.primary500.color
      : DSKitAsset.Color.neutral400.color
    }
  }

  private lazy var titleStackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .fill
    $0.distribution = .fillProportionally
  }

  private lazy var titleLabel = UILabel().then {
    $0.font = UIFont.thtSubTitle1Sb
    $0.textColor = DSKitAsset.Color.neutral50.color
    $0.text = "타이틀 텍스트"
    $0.numberOfLines = 0
  }

  private lazy var secondaryTitleLabel = UILabel().then {
    $0.font = UIFont.thtCaption1R
    $0.textColor = DSKitAsset.Color.neutral50.color
    $0.text = "세컨더리 타이틀 텍스트"
    $0.numberOfLines = 2
    $0.isHidden = true
  }

  public lazy var contentStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.alignment = .center
    $0.distribution = .fillProportionally
  }

  private lazy var contentLabel = UILabel().then {
    $0.font = .thtSubTitle2R
    $0.text = "콘텐츠 레이블입니다."
    $0.numberOfLines = 1
    $0.textAlignment = .right
    $0.textColor = DSKitAsset.Color.neutral400.color
    $0.isHidden = true
  }

  private lazy var contentImage = UIImageView().then {
    $0.image = IconType.rightArrow.image
    $0.contentMode = .scaleAspectFit
    $0.isHidden = true
  }

  private lazy var contentButton = UIButton().then {
    $0.backgroundColor = DSKitAsset.Color.primary500.color
    $0.layer.cornerRadius = 15
    $0.layer.masksToBounds = true
    $0.setTitleColor(DSKitAsset.Color.neutral500.color, for: .normal)
    $0.setTitleColor(DSKitAsset.Color.neutral500.color, for: .normal)

    let text = "업데이트"
    let range = NSRange(location: 0, length: text.count)
    let mutableString = NSMutableAttributedString(string: text)
    mutableString.addAttributes([
      .font: UIFont.thtP2Sb
    ], range: range)
    $0.setAttributedTitle(mutableString, for: .normal)

    $0.frame = .init(origin: .zero, size: .init(width: UIView.layoutFittingExpandedSize.width, height: 30.0))
    $0.isHidden = true
  }

  override func makeUI() {
    backgroundColor = DSKitAsset.Color.neutral600.color
    layer.cornerRadius = 12
    clipsToBounds = true

    addSubviews(titleStackView, contentStackView)

    titleStackView.addArrangedSubviews([titleLabel, secondaryTitleLabel])
    contentStackView.addArrangedSubviews([contentLabel, contentImage, contentButton])

    titleStackView.setContentCompressionResistancePriority(.required, for: .horizontal)
    titleStackView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.leading.equalToSuperview().offset(14)
      $0.bottom.equalToSuperview().offset(-10)
    }

    contentStackView.snp.makeConstraints {
      $0.top.bottom.equalTo(titleStackView)
      $0.leading.equalTo(titleLabel.snp.trailing)
      $0.trailing.equalToSuperview().offset(-14)
    }

    contentImage.snp.makeConstraints {
      $0.size.equalTo(30)
    }
  }


}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct MyPageCellContainerViewPreview: PreviewProvider {

  static var previews: some View {
    UIViewPreview {
      let cmp = MyPageCellContainerView()
      return cmp
    }
    .frame(width: 375, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
    .previewLayout(.sizeThatFits)
  }
}
#endif
