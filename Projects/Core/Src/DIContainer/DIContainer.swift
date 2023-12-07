//
//  DIContainer.swift
//  Core
//
//  Created by Kanghos on 2023/11/26.
//

import Foundation

// SOPT 참조

public final class DIContainer {
    public static let shared = DIContainer()

    private var factories = [String: () -> Any]()

    private init() { }
}

// MARK: - Methods

public extension DIContainer {

    func register<T>(_ factory: @escaping (() -> T)) {
        let key = String(describing: T.self)
        factories[key] = factory
    }

    func resolve<T>() -> T {
        let key = String(describing: type(of: T.self))
        guard let factory = factories[key] else {
            preconditionFailure("\(key) should be registered!")
        }
        return factory() as! T
    }

    func register<T>(interface: T, implement: @escaping (() -> Any)) {
        let key = String(describing: T.self)
        factories[key] = implement
    }
}
