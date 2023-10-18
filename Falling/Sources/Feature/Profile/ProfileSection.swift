//
//  ProfileSection.swift
//  Falling
//
//  Created by Kanghos on 2023/10/05.
//

import Foundation

enum ProfilePhotoSection: CaseIterable {
  case main
}

extension UserProfilePhoto {
  func toDomain() -> ProfilePhotoDomain {
    ProfilePhotoDomain(url: self.url, priority: self.priority)
  }
}

struct ProfilePhotoDomain: Hashable {
  let identifier = UUID()
  let url: String
  let priority: Int

  func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }
}
