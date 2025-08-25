//
//  PokeAPI.swift
//  PokeAPI_SantiagoTamez
//
//  Created by Alumno on 25/08/25.
//

import Foundation

struct PokemonListResponse: Decodable {
    let results: [PokemonListEntry]
}

struct PokemonListEntry: Decodable {
    let name: String
    let url: String
}

struct PokeAPI: Identifiable, Decodable {
    var id = UUID()
    let name: String
    let base_experience: Int
    let height: Int
    let weight: Int
    let abilities: [AbilityEntry]
    let sprites: Sprites

    struct AbilityEntry: Decodable {
        let ability: Ability

        struct Ability: Decodable {
            let name: String
        }
    }

    struct Sprites: Decodable {
        let front_default: URL?
    }

    enum CodingKeys: String, CodingKey {
        case name
        case base_experience
        case height
        case weight
        case abilities
        case sprites
    }
}
