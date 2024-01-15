//
//  ChatBubbleCell.swift
//  Chat
//
//  Created by Kanghos on 2024/01/14.
//

import UIKit

import DSKit

import Kingfisher
import ChatInterface

final class ChatBubbleCell: TFBaseCollectionViewCell {
  enum State {
    case all
    case allExceptDate
    case onlyContent
    case contentWithDate
  }

  private lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 12
    imageView.clipsToBounds = true
    imageView.isHidden = true
    return imageView
  }()

  private lazy var hStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 8
    return stackView
  }()

  private lazy var nickNameLabel: UILabel = {
    let label = UILabel()
    label.textColor = DSKitAsset.Color.neutral300.color
    label.font = UIFont.thtP2R
    label.numberOfLines = 1
    label.isHidden = true
    return label
  }()

  private lazy var contentLabel: TFPaddingLabel = {
    let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let label = TFPaddingLabel(padding: padding)
    label.backgroundColor = DSKitAsset.Color.neutral600.color
    label.textColor = DSKitAsset.Color.neutral50.color
    label.font = UIFont.thtP2R
    label.numberOfLines = 0
    label.layer.cornerRadius = 12
    label.clipsToBounds = true
    return label
  }()

  private lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.textColor = DSKitAsset.Color.neutral50.color
    label.font = UIFont.thtCaption2R
    label.textAlignment = .right
    label.isHidden = true
    return label
  }()

  override func makeUI() {
    self.contentView.addSubviews(profileImageView, hStackView, dateLabel)
    self.contentView.backgroundColor = DSKitAsset.Color.neutral700.color

    hStackView.addArrangedSubviews([ nickNameLabel, contentLabel, ])

    profileImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(13)
      $0.leading.equalToSuperview().offset(16)
      $0.size.equalTo(50)
    }

    hStackView.snp.makeConstraints {
      $0.top.equalTo(profileImageView)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
      $0.bottom.equalToSuperview().offset(-13)
    }

//    contentLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
//    contentLabel.snp.makeConstraints {
//      $0.leading.equalTo(nickNameLabel)
//      $0.top.equalTo(nickNameLabel.snp.bottom).offset(8)
//      $0.height.equalTo(40).priority(.low)
//      $0.bottom.equalToSuperview().offset(-13)
//    }

    dateLabel.snp.makeConstraints {
      $0.leading.equalTo(contentLabel.snp.trailing).offset(8)
      $0.height.equalTo(20)
      $0.bottom.equalTo(hStackView)
    }
  }
  // 경우의 수 4가지
  /*
   1. 모든 컴포넌트
   2. 날짜만 없는 컴포넌트
   3. 메세지 + 날짜
   4. 메세지만
   */
  func bind(_ item: ChatRoom, state: State) {
    self.contentLabel.text = item.currentMessage
    self.nickNameLabel.text = item.partnerName
    self.dateLabel.text = item.messageTime.toTimeString()
    self.profileImageView.setImage(urlString: item.partnerProfileURL, downsample: 50)
    bind(state)
  }

  private func bind(_ state: State) {
    switch state {
    case .all:
      self.profileImageView.isHidden = false
      self.nickNameLabel.isHidden = false
      self.dateLabel.isHidden = false
    case .allExceptDate:
      self.profileImageView.isHidden = false
      self.nickNameLabel.isHidden = false
      self.dateLabel.isHidden = true
    case .onlyContent:
      self.profileImageView.isHidden = true
      self.nickNameLabel.isHidden = true
      self.dateLabel.isHidden = true
    case .contentWithDate:
      self.profileImageView.isHidden = true
      self.nickNameLabel.isHidden = true
      self.dateLabel.isHidden = false
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    self.profileImageView.isHidden = true
    self.nickNameLabel.isHidden = true
    self.dateLabel.isHidden = true
    nickNameLabel.text = nil
    contentLabel.text = nil
    dateLabel.text = nil
    profileImageView.image = nil
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct ChatBubbleCellViewPreview: PreviewProvider {

  static let model = ChatRoom(
    chatRoomIndex: 1,
    partnerName: "nickname",
    partnerProfileURL: "",
    currentMessage: "테스트 메세지asdfkljaslk\naasfassdlfjasdlfkjasdflaksfjsdl\nasdf",
    messageTime: Date(),
    isAvailableChat: true
  )
  static var previews: some View {
    Group {
      UIViewPreview {
        let cell = ChatBubbleCell()
        cell.bind(model, state: .all)
        return cell
      }
      .frame(width: UIScreen.main.bounds.width, height: 110)
      UIViewPreview {
        let cell = ChatBubbleCell()
        cell.bind(model, state: .contentWithDate)
        return cell
      }
      .frame(width: UIScreen.main.bounds.width, height: 110)
      UIViewPreview {
        let cell = ChatBubbleCell()
        cell.bind(model, state: .onlyContent)
        return cell
      }
      .frame(width: UIScreen.main.bounds.width, height: 110)
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif

