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
    var isLoading = false
    var errorMessage: String? = nil

    init() {
        Task {
            await loadAPI()
        }
    }

    func loadAPI() async {
        isLoading = true
        errorMessage = nil
        arrPokemon.removeAll()

        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=20") else {
            errorMessage = "Invalid API URL."
            isLoading = false
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                errorMessage = "Server error. Please try again later."
                isLoading = false
                return
            }

            let list = try JSONDecoder().decode(PokemonListResponse.self, from: data)

            for entry in list.results {
                await fetchPokemonDetail(from: entry.url)
            }

        } catch {
            handleNetworkError(error)
        }

        isLoading = false
    }

    func fetchPokemonDetail(from urlString: String) async {
        guard let url = URL(string: urlString) else {
            print("Invalid Pokémon URL: \(urlString)")
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Failed to load Pokémon detail")
                return
            }

            let pokemon = try JSONDecoder().decode(PokeAPI.self, from: data)

            arrPokemon.append(pokemon)

        } catch {
            print("Failed to decode Pokémon detail: \(error.localizedDescription)")
        }
    }

    func handleNetworkError(_ error: Error) {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                errorMessage = "No internet connection. Please try again."
            case .timedOut:
                errorMessage = "The request timed out. Try again later."
            default:
                errorMessage = "Network error: \(urlError.localizedDescription)"
            }
        } else {
            errorMessage = "Unexpected error: \(error.localizedDescription)"
        }

        isLoading = false
    }
}

