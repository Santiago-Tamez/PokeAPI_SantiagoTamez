//
//  ContentView.swift
//  PokeAPI_SantiagoTamez
//
//  Created by Alumno on 25/08/25.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = PokeAPIViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.arrPokemon) { pokemon in
                NavigationLink(destination: PokeAPIDetailView(pokemon: pokemon)) {
                    HStack {
                        AsyncImage(url: pokemon.sprites.front_default) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                            } else {
                                ProgressView()
                                    .frame(width: 50, height: 50)
                            }
                        }

                        Text(pokemon.name.capitalized)
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("Pokémon")
        }
    }
}


#Preview {
    ContentView()
}
