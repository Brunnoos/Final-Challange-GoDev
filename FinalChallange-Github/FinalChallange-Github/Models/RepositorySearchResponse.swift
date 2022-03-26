//
//  RepositorySearchResponse.swift
//  FinalChallange-Github
//
//  Created by Aloc FL00030 on 26/03/22.
//

import Foundation

struct RepositorySearchResponse: Decodable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [Item]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

// MARK: - Item
struct Item: Decodable {
    let id: Int
    let nodeID, name, fullName: String
    let itemPrivate: Bool
    let owner: Owner
    let htmlURL: String
    let itemDescription: String?
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case nodeID = "node_id"
        case name
        case fullName = "full_name"
        case itemPrivate = "private"
        case owner
        case htmlURL = "html_url"
        case itemDescription = "description"
        case createdAt = "created_at"
    }
}

// MARK: - License
struct License: Decodable {
    let key, name, spdxID: String
    let url: String?
    let nodeID: String

    enum CodingKeys: String, CodingKey {
        case key, name
        case spdxID = "spdx_id"
        case url
        case nodeID = "node_id"
    }
}

// MARK: - Owner
struct Owner: Decodable {
    let login: String
    let id: Int
    let nodeID: String
    let avatarURL: String
    let htmlURL: String

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Decodable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    func hash(into hasher: inout Hasher) {
        
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

