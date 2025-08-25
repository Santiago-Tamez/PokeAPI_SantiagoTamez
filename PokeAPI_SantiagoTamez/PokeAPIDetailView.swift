//
//  PokeAPIDetailView.swift
//  PokeAPI_SantiagoTamez
//
//  Created by Alumno on 25/08/25.
//

// PokemonDetailView.swift

import SwiftUI

struct PokeAPIDetailView: View {
    let pokemon: PokeAPI

    var body: some View {
        VStack(spacing: 16) {
            Text(pokemon.name.capitalized)
                .font(.largeTitle)
                .padding(.top)

            if let imageURL = pokemon.sprites.front_default {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                    case .failure:
                        Image(systemName: "photo")
                    @unknown default:
                        EmptyView()
                    }
                }
            }

            Text("Base Experience: \(pokemon.base_experience)")
            Text("Height: \(pokemon.height)")
            Text("Weight: \(pokemon.weight)")

            VStack(alignment: .leading) {
                Text("Abilities:")
                    .font(.headline)
                ForEach(pokemon.abilities, id: \.ability.name) { entry in
                    Text("• \(entry.ability.name.capitalized)")
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle(pokemon.name.capitalized)
        .navigationBarTitleDisplayMode(.inline)
    }
}
