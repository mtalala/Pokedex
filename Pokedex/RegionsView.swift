import SwiftUI

struct RegionsView: View {
    @StateObject private var vm = RegionsViewModel()

    var body: some View {
        List(vm.regions) { region in
            NavigationLink(value: region) {
                Text(region.name)
            }
        }
        .navigationTitle("Regions")
        .task { await vm.load() }
        .navigationDestination(for: Region.self) {
            RegionPokemonView(region: $0)
        }
    }
}