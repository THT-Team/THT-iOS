//
//  FallingTest.swift
//  FallingTests
//
//  Created by Kanghos on 2023/08/01.
//

import XCTest
@testable import Falling
final class FallingTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
      let request = makeMockSignUpRequest()
      AuthAPI.signUpRequest(
        request: request) { result in
          switch result {
          case .success(let model):
            guard let model = model else {
              print("response is nil")
              XCTAssertFalse(true, "reponse is nil")
              return
            }
            print(model)
            XCTAssertTrue(true)
          case .failure(let error):
            XCTAssertFalse(true, error.localizedDescription)
          }
        }
      XCTWaiter().wait(for: [XCTestExpectation()], timeout: 3)

        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
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
