//
//  PhotoInputView.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/18.
//

import UIKit

import DSKit

//https://stackoverflow.com/questions/28140781/how-to-edit-the-uiblureffect-intensity
class BlurEffectView: UIVisualEffectView {

    var animator = UIViewPropertyAnimator(duration: 1, curve: .linear)

    override func didMoveToSuperview() {
        guard let superview = superview else { return }
        backgroundColor = .clear
        frame = superview.bounds //Or setup constraints instead
        setupBlur()
    }

    private func setupBlur() {
        animator.stopAnimation(true)
        effect = nil

        animator.addAnimations { [weak self] in
            self?.effect = UIBlurEffect(style: .dark)
        }
        animator.fractionComplete = 0.1   //This is your blur intensity in range 0 - 1
    }

    deinit {
        animator.stopAnimation(true)
    }
}

final class PhotoInputView: TFBaseView {

  private(set) lazy var blurView: UIVisualEffectView = {
    let effect = UIBlurEffect(style: .dark)
    let visualEffectView = UIVisualEffectView(effect: effect)
    visualEffectView.alpha = 0
    return visualEffectView
  }()

  lazy var titleLabel = UILabel.setTargetBold(text: "사진을 추가해주세요.", target: "사진", font: .thtH1B, targetFont: .thtH1B)

  lazy var photoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .photoPickLayout(edge: 5))

  lazy var descriptionView = TFOneLineDescriptionView(description: "얼굴이 잘 나온 사진 2장을 필수로 넣어주세요.")

  lazy var nextBtn = TFButton(btnTitle: "->", initialStatus: false)

  override func makeUI() {
    self.backgroundColor = DSKitAsset.Color.neutral700.color

    photoCollectionView.backgroundColor = .clear

    addSubviews(
      titleLabel,
      photoCollectionView,
      descriptionView,
      nextBtn
    )

    addSubviews(blurView)

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(180.adjustedH)
      $0.leading.trailing.equalToSuperview().inset(38.adjusted)
    }

    photoCollectionView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(30.adjustedH)
      $0.leading.trailing.equalTo(titleLabel)
      $0.height.equalTo(294.adjustedH)
    }

    descriptionView.snp.makeConstraints {
      $0.top.equalTo(photoCollectionView.snp.bottom).offset(10)
      $0.leading.trailing.equalTo(titleLabel)
    }

    nextBtn.snp.makeConstraints {
      $0.trailing.equalTo(descriptionView)
      $0.height.equalTo(54.adjustedH)
      $0.width.equalTo(88.adjusted)
      $0.bottom.equalToSuperview().offset(-133.adjustedH)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    blurView.frame = bounds
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct PhotoInputViewPreview: PreviewProvider {

  static var previews: some View {
    UIViewPreview {
      return PhotoInputView()
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
