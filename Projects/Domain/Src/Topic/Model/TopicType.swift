//
//  TopicType.swift
//  Domain
//
//  Created by Kanghos on 1/6/25.
//

import Foundation

public enum TopicType: String, Decodable, Equatable, Hashable {
  case oneChoice, twoChoice, fourChoice
}
