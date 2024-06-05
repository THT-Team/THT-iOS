//
//  Agrement.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/25.
//

import Foundation

// MARK: - AgreementElement
public struct AgreementElement: Codable {
    public let name, subject: String
    public let isRequired: Bool
    public let description: String?
    public let detailLink: String?
}

public typealias Agreement = [AgreementElement]
