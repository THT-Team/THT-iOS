//
//  MaxQueue.swift
//  Domain
//
//  Created by Kanghos on 7/29/24.
//

import Foundation

public struct Queue<Element: Equatable> {
  private let maxSize: Int

  public init(maxSize: Int) {
    self.maxSize = maxSize
  }

  private var elements: [Element] = []

  public mutating func enqueue(_ element: Element) {
    if elements.contains(where: { $0 == element }) {
      elements.removeAll(where: { $0 == element })
      return
    }

    if elements.count == maxSize {
      dequeue()
    }
    elements.append(element)
  }

  public func current() -> [Element] {
    return elements
  }

  @discardableResult
  public mutating func dequeue() -> Element? {
    guard !elements.isEmpty else {
      return nil
    }
    return elements.removeFirst()
  }
}
