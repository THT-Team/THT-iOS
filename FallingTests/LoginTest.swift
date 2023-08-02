//
//  LoginTest.swift
//  FallingTests
//
//  Created by Kanghos on 2023/08/01.
//

import XCTest
import Moya
import RxSwift
@testable import Falling

final class LoginTest: XCTestCase {
  private var disposeBag = DisposeBag()
  
  func testCertificate() throws {
    AuthAPI.certificate(phoneNumber: "01089192466")
      .subscribe { response in
        print(response)
      }.disposed(by: disposeBag)
    XCTWaiter().wait(for: [XCTestExpectation()], timeout: 3)
  }
  
  func testLogin() throws {
    let request = makeMockLoginRequest()
    AuthAPI.login(request: request)
      .subscribe { response in
        print(response)
      }.disposed(by: disposeBag)
    
    XCTWaiter().wait(for: [XCTestExpectation()], timeout: 3)
    
  }
  func testRx() throws {
    
    let request = makeMockSignUpRequest()
    
    AuthAPI.signUpRequest(request: request)
      .subscribe { response in
        print(response)
      }.disposed(by: disposeBag)
    
    XCTWaiter().wait(for: [XCTestExpectation()], timeout: 3)
  }
  
  func makeMockLoginRequest() -> LoginRequest {
    LoginRequest(phoneNumber: "01089192466",
                 deviceKey: 123)
  }
  
  func makeMockSignUpRequest() -> SignUpRequest {
    SignUpRequest(
      phoneNumber: "01089192466",
      username: "LKH",
      email: "ibcylon@naver.com",
      birthDay: "1994.05.16",
      gender: .male,
      preferGender: .female,
      introduction: "안녕하세요",
      deviceKey: "123",
      agreement: .init(
        serviceUseAgree: true,
        personalPrivacyInfoAgree: true,
        locationServiceAgree: true,
        marketingAgree: true
      ),
      locationRequest: .init(
        address: "서울특별시 힘찬구 열심동",
        regionCode: 110444103,
        lat: 13,
        lon: 13
      ),
      photoList: ["url1", "url2"],
      interestList: [1,2,3],
      idealTypeList: [1,2,3],
      snsType: "NORMAL",
      snsUniqueID: "snsUniqueId"
    )
  }
}
