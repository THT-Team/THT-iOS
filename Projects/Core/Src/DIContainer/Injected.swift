//
//  Injected.swift
//  Core
//
//  Created by Kanghos on 2023/11/26.
//

import Foundation

@propertyWrapper
public class Injected<T> {
    public let wrappedValue: T

    public init() {
        self.wrappedValue = DIContainer.shared.resolve()
    }
}
