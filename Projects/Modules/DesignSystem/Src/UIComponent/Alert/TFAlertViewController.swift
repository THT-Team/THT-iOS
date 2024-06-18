//
//  TFAlertViewController.swift
//  DSKit
//
//  Created by SeungMin on 4/3/24.
//

import UIKit

public enum ReportAction {
  case complaints, block, withdraw
  
  var title: String {
    switch self {
    case .complaints:
      return "어떤 문제가 있나요?"
    case .block:
      return "차단할까요?"
    case .withdraw:
      return "계정 탈퇴하기"
    }
  }
  
  var message: String? {
    switch self {
    case .block:
      return "해당 사용자와 서로 차단됩니다."
    case .withdraw:
      return "정말 탈퇴하시겠어요? 회원님의 모든 정보 및\n사용 내역은 복구 불가합니다. 블링 환불 관련 문의는\nteamtht23@gmail.com 으로 부탁드립니다."
    default:
      return nil
    }
  }
  
  var topActionTitle: String {
    switch self {
    case .complaints:
      return "차단할까요?"
    case .block:
      return "차단하기"
    case .withdraw:
      return "탈퇴하기"
    }
  }
  
  var bottomActionTitle: String {
    switch self {
    default:
      return "취소"
    }
  }
}

public final class TFAlertViewController: TFBaseViewController {
  private var titleText: String?
  private var messageText: String?
  private var contentView: UIView?
  
  private lazy var dimView: UIView = {
    let view = UIView()
    view.backgroundColor = DSKitAsset.Color.DimColor.default.color
    return view
  }()
  
  private lazy var containerStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.backgroundColor = DSKitAsset.Color.neutral600.color
    stackView.layer.cornerRadius = 8
    stackView.clipsToBounds = true
    stackView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
    stackView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    stackView.isLayoutMarginsRelativeArrangement = true
    return stackView
  }()
  
  private lazy var labelStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 6
    stackView.alignment = .center
    return stackView
  }()
  
  private lazy var buttonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .center
    return stackView
  }()
  
  private lazy var titleLabel: UILabel? = {
    guard titleText != nil else { return nil }
    
    let label = UILabel()
    label.text = titleText
    label.font = UIFont.thtH5Sb
    label.textAlignment = .center
    label.textColor = DSKitAsset.Color.neutral50.color
    label.numberOfLines = 0
    return label
  }()
  
  private lazy var messageLabel: UILabel? = {
    guard messageText != nil else { return nil }
    
    let label = UILabel()
    label.text = messageText
    label.font = UIFont.thtP1R
    label.textAlignment = .center
    label.textColor = DSKitAsset.Color.neutral300.color
    label.numberOfLines = 0
    return label
  }()
  
  let separatorView: UIView = {
    let view = UIView()
    view.backgroundColor = DSKitAsset.Color.neutral400.color
    return view
  }()
  
  init(
    titleText: String? = nil,
    messageText: String? = nil,
    dimColor: UIColor = DSKitAsset.Color.DimColor.default.color
  ) {
    super.init(nibName: nil, bundle: nil)
    self.titleText = titleText
    self.messageText = messageText
    self.dimView.backgroundColor = dimColor
    modalPresentationStyle = .overFullScreen
  }
  
  convenience init(contentView: UIView, dimColor: UIColor) {
    self.init()
    
    self.contentView = contentView
    self.dimView.backgroundColor = dimColor
    modalPresentationStyle = .overFullScreen
  }
  
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    TFLogger.cycle(name: self)
  }

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // curveEaseOut: 시작은 천천히, 끝날 땐 빠르게
    UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut) { [weak self] in
      self?.containerStackView.transform = .identity
      self?.containerStackView.isHidden = false
    }
  }
  
  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    // curveEaseIn: 시작은 빠르게, 끝날 땐 천천히
    UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
      self?.containerStackView.transform = .identity
      self?.containerStackView.isHidden = true
    }
  }
  
  public override func makeUI() {
    view.addSubviews([dimView, containerStackView])
    self.view.backgroundColor = .clear
    if let contentView = contentView {
      containerStackView.addArrangedSubview(contentView)
      contentView.snp.makeConstraints {
        $0.leading.trailing.equalToSuperview()
      }
    }
    
    if let titleLabel = titleLabel {
      labelStackView.addArrangedSubview(titleLabel)
      
      containerStackView.addArrangedSubview(labelStackView)
      labelStackView.snp.makeConstraints {
        $0.width.equalToSuperview()
      }
      
      if let messageLabel = messageLabel {
        labelStackView.addArrangedSubview(messageLabel)
      }
    }
    
    if let lastView = containerStackView.subviews.last {
      containerStackView.setCustomSpacing(10, after: lastView)
    } else {
      // 버튼만 있는 Alert의 경우
      containerStackView.layoutMargins = .zero
    }

    containerStackView.addArrangedSubview(buttonStackView)
    
    dimView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    containerStackView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(28)
    }
    
    buttonStackView.snp.makeConstraints {
      $0.width.equalToSuperview()
    }
    
    separatorView.snp.makeConstraints {
      $0.width.equalToSuperview()
      $0.height.equalTo(1.5)
    }
  }
  
  public func addActionToButton(
    title: String? = nil,
    withSeparator: Bool = false,
    completion: (() -> Void)? = nil
  ) {
    guard let title = title else { return }
  
    let button = UIButton()
    button.titleLabel?.font = UIFont.thtSubTitle2Sb
    
    // enable
    button.setTitle(title, for: .normal)
    button.setTitleColor(DSKitAsset.Color.neutral50.color, for: .normal)
    button.setBackgroundImage(DSKitAsset.Color.neutral600.color.image(), for: .normal)
    
    // disable
    button.setTitleColor(DSKitAsset.Color.neutral50.color, for: .disabled)
    button.setBackgroundImage(DSKitAsset.Color.neutral300.color.image(), for: .disabled)
    
    button.addAction(for: .touchUpInside) { _ in
      completion?()
    }
    
    if withSeparator { buttonStackView.addArrangedSubview(separatorView) }
    
    buttonStackView.addArrangedSubview(button)
    button.snp.makeConstraints {
      $0.width.equalToSuperview()
      $0.height.equalTo(52.25)
    }
  }
  
  public func addActionToDim(completion: (() -> Void)? = nil) {
    let tapGestureRecognizer = UITapGestureRecognizer()
    tapGestureRecognizer.addAction(closure: { _ in completion?() })
    
    dimView.addGestureRecognizer(tapGestureRecognizer)
  }
}
