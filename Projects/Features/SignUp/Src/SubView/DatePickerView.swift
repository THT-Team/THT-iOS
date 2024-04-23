////
////  DatePickerView.swift
////  SignUp
////
////  Created by Kanghos on 2024/04/16.
////
//
//import UIKit
//
//import DSKit
//
//final class DatePickerView: TFBaseView {
//
//  lazy var pickerView = UIPickerView().then {
//    
//  }
//
//  lazy var infoImageView: UIImageView = UIImageView().then {
//    $0.image = DSKitAsset.Image.Icons.explain.image.withRenderingMode(.alwaysTemplate)
//    $0.tintColor = DSKitAsset.Color.neutral400.color
//  }
//
//  lazy var descLabel: UILabel = UILabel().then {
//    $0.text = "폴링에서 활동할 자유로운 호칭을 설정해주세요"
//    $0.font = .thtCaption1M
//    $0.textColor = DSKitAsset.Color.neutral400.color
//    $0.textAlignment = .left
//    $0.numberOfLines = 1
//  }
//
//  override func makeUI() {
//    addSubviews(
//      pickerView,
//      infoImageView, descLabel
//    )
//
//    pickerView.snp.makeConstraints {
//      $0.top.equalToSuperview().offset(14)
//      $0.leading.trailing.equalToSuperview()
//      $0.height.equalTo(60)
//    }
//
//    infoImageView.snp.makeConstraints {
//      $0.leading.equalTo(pickerView.snp.leading)
//      $0.width.height.equalTo(16)
//      $0.top.equalTo(pickerView.snp.bottom).offset(16)
//    }
//
//    descLabel.snp.makeConstraints {
//      $0.leading.equalTo(infoImageView.snp.trailing).offset(6)
//      $0.top.equalTo(pickerView.snp.bottom).offset(16)
//      $0.trailing.equalToSuperview().inset(38)
//    }
//  }
//}
//
//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//struct DatePickerViewPreview: PreviewProvider {
//
//  static var previews: some View {
//    UIViewPreview {
//      return DatePickerView()
//    }
//    .previewLayout(.sizeThatFits)
//  }
//}
//#endif
