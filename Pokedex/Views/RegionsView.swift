//
//  RegionsView.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//


import SwiftUI

struct RegionsView: View {
    @StateObject private var vm = RegionsViewModel()

    var body: some View {
        List {
            if vm.isLoading {
                ProgressView()
            }

            ForEach(vm.regions) { region in
                NavigationLink {
                    RegionPokemonView(region: region)
                } label: {
                    Text(region.name)
                }
            }
        }
        .navigationTitle("Regions")
        .task {
            await vm.load()
        }
    }
}