//
//  FallingUseCase.swift
//  Falling
//
//  Created by SeungMin on 1/12/24.
//

import Foundation

import RxSwift

public final class FallingUseCase: FallingUseCaseInterface {

  private let repository: FallingRepositoryInterface

  public init(repository: FallingRepositoryInterface) {
    self.repository = repository
  }
  
  public func user(alreadySeenUserUUIDList: [String], userDailyFallingCourserIdx: Int, size: Int) -> Single<FallingUserInfo> {
    repository.user(
      alreadySeenUserUUIDList: alreadySeenUserUUIDList,
      userDailyFallingCourserIdx: userDailyFallingCourserIdx,
      size: size
    )
    .retry(when: {
      $0.enumerated()
        .flatMap { attempt, error in
          attempt < 2
          ? Observable<Int>.just(attempt)
            .delay(.seconds(3), scheduler: MainScheduler.instance)
          : Observable.error(error)
        }
    })
  }
}

// MARK: test
struct UserGenerator {
  static var userDailyFallingCourserIdx: Int = 0
  static func userInfo(userDailyFallingCourserIdx: Int, size: Int) -> FallingUserInfo {
    UserGenerator.userDailyFallingCourserIdx = userDailyFallingCourserIdx + 1

    return FallingUserInfo(
      selectDailyFallingIndex: 1,
      topicExpirationUnixTime: Date(timeIntervalSince1970: TimeInterval(1764550464)),
      isLast: Bool.random(),
      userInfos: users(size: size))
  }

  private static func makeUser() -> FallingUser {

    let user = FallingUser(
      username: "\(userDailyFallingCourserIdx)th Card",
      userUUID: UUID().uuidString,
      age: 27,
      address: "서울시 행복",
      isBirthDay: true,
      idealTypeResponseList: [
        .init(idx: 1, name: "지적인", emojiCode: "U+1F9E0"),
        .init(idx: 2, name: "지적인", emojiCode: "U+1F9E0"),
        .init(idx: 3, name: "지적인", emojiCode: "U+1F9E0"),
      ],
      interestResponses: [
        .init(idx: 1, name: "지적인", emojiCode: "U+1F9E0"),
        .init(idx: 2, name: "지적인", emojiCode: "U+1F9E0"),
        .init(idx: 3, name: "지적인", emojiCode: "U+1F9E0"),
      ],
      userProfilePhotos: [
        .init(url: "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2023/07/14/bdb0ca50-5057-41e2-a024-8243c6f06279.jpg", priority: 1),
        .init(url: "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2023/07/14/bdb0ca50-5057-41e2-a024-8243c6f06279.jpg", priority: 2),
        .init(url: "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2023/07/14/bdb0ca50-5057-41e2-a024-8243c6f06279.jpg", priority: 3)
      ],
      introduction: "ㅎㅎ",
      userDailyFallingCourserIdx: userDailyFallingCourserIdx,
      distance: 10
    )
    userDailyFallingCourserIdx += 1
    return user
  }
  static func users(size: Int) -> [FallingUser] {
    return (0..<size).map { _ in makeUser() }
  }
}

