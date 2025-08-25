//
//  PokeAPIViewModel.swift
//  PokeAPI_SantiagoTamez
//
//  Created by Alumno on 25/08/25.
//

import Foundation

@Observable
@MainActor
class PokeAPIViewModel {
    
    var arrPokemon = [PokeAPI]()
    
    init() {
        Task {
            await loadAPI()
        }
    }
    
    func loadAPI() async {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=20") else {
            print("Invalid URL")
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                print("Invalid response")
                return
            }

            let list = try JSONDecoder().decode(PokemonListResponse.self, from: data)

            for entry in list.results {
                await fetchPokemonDetail(from: entry.url)
            }

        } catch {
            print("Failed to fetch list: \(error)")
        }
    }
    
    func fetchPokemonDetail(from urlString: String) async {
        guard let url = URL(string: urlString) else {
            print("Invalid Pokémon URL: \(urlString)")
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                print("Failed to load Pokémon detail")
                return
            }

            let pokemon = try JSONDecoder().decode(PokeAPI.self, from: data)

            arrPokemon.append(pokemon)

        } catch {
            print("Failed to decode Pokémon: \(error)")
        }
    }
}
