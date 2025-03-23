//
//  ChatRoomCell.swift
//  ChatInterface
//
//  Created by Kanghos on 2024/01/11.
//

import UIKit

import DSKit

import Kingfisher
import ChatInterface
import Domain
final class ChatRoomCell: TFBaseCollectionViewCell {
  private lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 12
    imageView.clipsToBounds = true
    return imageView
  }()

  private lazy var nickNameLabel: UILabel = {
    let label = UILabel()
    label.textColor = DSKitAsset.Color.neutral50.color
    label.font = UIFont.thtSubTitle2M
    label.numberOfLines = 1
    return label
  }()

  private lazy var contentLabel: UILabel = {
    let label = UILabel()
    label.textColor = DSKitAsset.Color.neutral300.color
    label.font = UIFont.thtP1R
    label.numberOfLines = 2
    return label
  }()

  private lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.textColor = DSKitAsset.Color.neutral300.color
    label.font = UIFont.thtCaption1R
    label.textAlignment = .right
    return label
  }()

  private lazy var notiLabel: UILabel = {
    let label = UILabel()
    label.textColor = DSKitAsset.Color.neutral700.color
    label.font = UIFont.thtCaption1Sb
    label.backgroundColor = DSKitAsset.Color.primary500.color
    label.layer.masksToBounds = true
    label.textAlignment = .center
    label.layer.cornerRadius = 12.5
    return label
  }()

  override func makeUI() {
    self.contentView.addSubviews(profileImageView, nickNameLabel, contentLabel, dateLabel, notiLabel)
    self.contentView.backgroundColor = DSKitAsset.Color.neutral700.color

    profileImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(13)
      $0.leading.equalToSuperview().offset(16)
      $0.height.equalTo(profileImageView.snp.width)
      $0.bottom.equalToSuperview().offset(-13)
    }

    nickNameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    nickNameLabel.snp.makeConstraints {
      $0.top.equalTo(profileImageView).offset(5)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
    }
    contentLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    contentLabel.snp.makeConstraints {
      $0.leading.equalTo(nickNameLabel)
      $0.top.equalTo(nickNameLabel.snp.bottom)
      $0.height.equalTo(40).priority(.low)
    }

    dateLabel.snp.makeConstraints {
      $0.leading.equalTo(nickNameLabel.snp.trailing)
      $0.trailing.equalToSuperview().offset(-16)
      $0.height.equalTo(20)
      $0.top.equalToSuperview().offset(13)
    }
    
    notiLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    notiLabel.snp.makeConstraints {
      $0.trailing.equalTo(dateLabel)
      $0.bottom.equalToSuperview().offset(-13)
      $0.height.equalTo(25)
      $0.width.equalTo(25).priority(.low)
      $0.leading.equalTo(contentLabel.snp.trailing)
    }
  }

  func bind(_ item: ChatRoom) {
    self.nickNameLabel.text = item.partnerName
    self.contentLabel.text = item.currentMessage
    self.dateLabel.text = item.messageTime.toTimeString()
    self.notiLabel.text = "100"
    self.profileImageView.setImage(urlString: item.partnerProfileURL, downsample: 50)
    self.notiLabel.setNeedsLayout()
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct ChatRoomCellViewPreview: PreviewProvider {

  static var previews: some SwiftUI.View {
    UIViewPreview {
      let model = ChatRoom(
        chatRoomIndex: 1,
        partnerName: "nickname",
        partnerProfileURL: "",
        currentMessage: "테스트 메세지",
        messageTime: Date(),
        isAvailableChat: true
      )
      let cell = ChatRoomCell()
      cell.bind(model)
      return cell
    }
    .frame(width: UIScreen.main.bounds.width, height: 110)
    .previewLayout(.sizeThatFits)
  }
}
#endif

