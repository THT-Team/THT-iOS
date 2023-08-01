//
//  FallingTest.swift
//  FallingTests
//
//  Created by Kanghos on 2023/08/01.
//

import XCTest
import Moya
import RxSwift

@testable import Falling
final class FallingTest: XCTestCase {
  private var bag = DisposeBag()
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testCertificate() throws {
    AuthAPI.certificate(phoneNumber: "01089192466")
      .subscribe { response in
        print(response)
      }.disposed(by: bag)
    XCTWaiter().wait(for: [XCTestExpectation()], timeout: 3)
  }

  func testLogin() throws {
    let request = makeMockLoginRequest()
    AuthAPI.login(request: request)
      .subscribe { response in
        print(response)
      }.disposed(by: bag)

    XCTWaiter().wait(for: [XCTestExpectation()], timeout: 3)

  }
  func testRx() throws {

    let request = makeMockSignUpRequest()

    AuthAPI.signUpRequest(request: request)
      .subscribe { response in
        print(response)
      }.disposed(by: bag)

    XCTWaiter().wait(for: [XCTestExpectation()], timeout: 3)
  }

  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
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
