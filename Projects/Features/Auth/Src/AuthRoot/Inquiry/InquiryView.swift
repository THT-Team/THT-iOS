//
//  InquiryView.swift
//  MyPageInterface
//
//  Created by Kanghos on 7/20/24.
//

import UIKit
import DSKit
import RxCocoa
import RxSwift

final class HeaderView: TFBaseView {
  private let titleLabel = UILabel().then {
    $0.textColor = DSKitAsset.Color.neutral50.color
    $0.font = .thtH5M
  }

  let backButton = UIButton.makeBackButton()

  override func makeUI() {
    addSubviews(titleLabel, backButton)

    backButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16.adjusted)
      $0.size.equalTo(24.adjusted)
      $0.centerY.equalToSuperview()
    }

    titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.centerX.equalToSuperview()
    }
  }

  var title: String? {
    get { titleLabel.text }
    set { titleLabel.text = newValue }
  }
}

struct HeaderStyle {
  var title: String
}

public final class InquiryView: TFBaseView {
  let headerView = HeaderView().then {
    $0.title = "문의하기"
  }

  private let titleView = UILabel().then {
    $0.text = "무엇이든 물어보세요!"
    $0.textColor = DSKitAsset.Color.neutral50.color
    $0.font = .thtH1B
  }

  private lazy var emailLabel = UILabel().then {
    $0.text = "답변 받을 이메일 주소"
    $0.textColor = DSKitAsset.Color.neutral300.color
    $0.font = .thtEx1M
  }

  private(set) lazy var emailField = TFBaseField(placeholder: "이메일을 입력").then {
    $0.textField.keyboardType = .emailAddress
    $0.textField.font = .thtSubTitle1R
    $0.textField.textColor = DSKitAsset.Color.neutral50.color
    $0.textField.attributedPlaceholder = NSAttributedString(
      string: "이메일을 입력",
      attributes: [NSAttributedString.Key.foregroundColor: DSKitAsset.Color.disabled.color])
  }

  private lazy var contentLabel = UILabel().then {
    $0.text = "내용 입력"
    $0.textColor = DSKitAsset.Color.neutral300.color
    $0.font = .thtEx1M
  }

  private(set) lazy var textView = TFBaseTextView(placeholder: "내용을 입력해주세요").then {
    $0.textView.textColor = DSKitAsset.Color.neutral50.color
    $0.textView.font = .thtSubTitle1R
    $0.textView.keyboardType = .default
  }

  private(set) lazy var nextBtn = CTAButton(btnTitle: "보내기", initialStatus: false)

  private(set) lazy var policyBtn = PolicyCheckButton(
    title: "이메일 정보 제공 동의",
    description: "보내주신 질문에 답변드리기 위해 이메일 정보 제공에 동의해 주시기 바랍니다.")

  private(set) lazy var cardView = TFPopUpTextBtnCard(
    title: "문의하기 완료",
    description: "답변에는 하루 정도의 시간이 걸릴 수 있어요.\n답변이 안온다면, 스팸 메일함을 확인해주세요.",
    btnTitle: "돌아가기"
  ).then {
    $0.isHidden = true
  }

  public override func makeUI() {
    addSubviews(
      headerView,
      titleView,
      emailLabel,
      emailField,
      contentLabel,
      textView,
      policyBtn,
      nextBtn,
      cardView
    )
    self.backgroundColor = DSKitAsset.Color.neutral700.color

    headerView.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(56.adjustedH)
    }

    titleView.snp.makeConstraints {
      $0.top.equalTo(headerView.snp.bottom).offset(36.adjustedH)
      $0.leading.trailing.equalToSuperview().inset(25)
    }

    emailLabel.snp.makeConstraints {
      $0.top.equalTo(titleView.snp.bottom).offset(40)
      $0.leading.trailing.equalToSuperview().inset(24)
    }

    emailField.snp.makeConstraints {
      $0.top.equalTo(emailLabel.snp.bottom)
      $0.leading.trailing.equalTo(emailLabel)
    }

    contentLabel.snp.makeConstraints {
      $0.top.equalTo(emailField.snp.bottom).offset(20)
      $0.leading.trailing.equalTo(emailLabel)
    }

    textView.snp.makeConstraints {
      $0.top.equalTo(contentLabel.snp.bottom)
      $0.leading.trailing.equalTo(emailLabel)
    }

    nextBtn.snp.makeConstraints {
      $0.bottom.equalTo(safeAreaLayoutGuide).offset(-50)
      $0.leading.trailing.equalToSuperview().inset(30)
      $0.height.equalTo(54)
    }

    policyBtn.snp.makeConstraints {
      $0.leading.trailing.equalTo(nextBtn)
      $0.bottom.equalTo(nextBtn.snp.top).offset(-20)
    }

    cardView.snp.makeConstraints {
      $0.width.equalTo(310.adjusted)
      $0.height.equalTo(450.adjustedH)
      $0.center.equalToSuperview()
    }
  }
}

public class PolicyCheckButton: UIControl {
  enum Image {
    static let checked = DSKitAsset.Image.Component.checkCirSelect.image
    static let unchecked = DSKitAsset.Image.Component.checkCir.image
  }

  private lazy var checkImageView = UIImageView().then {
    $0.image = Image.unchecked
  }

  private lazy var titleLabel = UILabel().then {
    $0.text = "이메일 정보 제공에 동의"
    $0.textColor = DSKitAsset.Color.neutral50.color
    $0.font = .thtP1Sb
  }

  private lazy var descriptionLabel = UILabel().then {
    $0.textColor = DSKitAsset.Color.neutral300.color
    $0.font = .thtCaption1R
    $0.numberOfLines = 2
  }

  public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    isSelected.toggle()
    self.sendActions(for: .valueChanged)
  }

  public override var isSelected: Bool {
    didSet {
      checkImageView.image = isSelected ? Image.checked : Image.unchecked
    }
  }

  public init(title: String, description: String) {
    super.init(frame: .zero)
    self.titleLabel.text = title
    self.descriptionLabel.text = description
    makeUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func makeUI() {
    addSubviews(checkImageView, titleLabel, descriptionLabel)
    
    checkImageView.snp.makeConstraints {
      $0.top.leading.equalToSuperview().offset(3)
      $0.size.equalTo(20)
    }
    
    titleLabel.snp.makeConstraints {
      $0.centerY.equalTo(checkImageView)
      $0.leading.equalTo(checkImageView.snp.trailing).offset(8)
    }
    
    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(4)
      $0.leading.equalTo(titleLabel)
      $0.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
}

extension Reactive where Base: PolicyCheckButton {
  var isSelected: ControlEvent<Bool> {
    let source = base.rx.controlEvent(.valueChanged).map { base.isSelected }
    return ControlEvent(events: source)
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct InquiryViewPreview: PreviewProvider {

  static var previews: some View {
    UIViewPreview {
      let cmp = InquiryView()
      return cmp
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
