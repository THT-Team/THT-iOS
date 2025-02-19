//
//  MainBuildable.swift
//  Feature
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation
import Core
import Domain

protocol MainBuildable {
  func build() -> MainCoordinating
}
