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
            Group {
                if viewModel.isLoading {
                    // Loading Spinner
                    VStack {
                        Spacer()
                        ProgressView("Loading Pokémon...")
                            .progressViewStyle(CircularProgressViewStyle())
                        Spacer()
                    }
                } else if let error = viewModel.errorMessage {
                    // Error Message + Retry
                    VStack(spacing: 16) {
                        Spacer()
                        Text(error)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.red)
                            .padding()

                        Button("Retry") {
                            Task {
                                await viewModel.loadAPI()
                            }
                        }
                        .padding()
                        .buttonStyle(.borderedProminent)

                        Spacer()
                    }
                } else {
                    // Main List View
                    List(viewModel.arrPokemon) { pokemon in
                        NavigationLink(destination: PokeAPIDetailView(pokemon: pokemon)) {
                            HStack {
                                AsyncImage(url: pokemon.sprites.front_default) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 50, height: 50)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(.gray)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }

                                Text(pokemon.name.capitalized)
                                    .font(.headline)
                            }
                        }
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
