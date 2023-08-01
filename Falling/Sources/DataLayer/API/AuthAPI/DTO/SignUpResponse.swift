//
//  SignUpResponse.swift
//  Falling
//
//  Created by Kanghos on 2023/08/01.
//

import Foundation

struct SignUpResponse: Codable {
    let accessToken: String
    let accessTokenExpiresIn: Int
}
