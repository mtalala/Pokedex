//
//  PokeAPIService.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//

//
//  PokeAPIService.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//

import Foundation

/// Erros possíveis durante a comunicação com a PokeAPI.
enum PokeAPIError: Error {
    /// A URL montada para a requisição não é válida.
    case invalidURL

    /// A resposta HTTP não indica sucesso.
    case invalidResponse

    /// Os dados recebidos não puderam ser decodificados para o modelo esperado.
    case decodingError
}

/// Serviço responsável por buscar regiões, listas e detalhes de Pokémon na PokeAPI.
///
/// A classe centraliza as requisições de rede e transforma as respostas JSON em modelos usados pelo app.
final class PokeAPIService {

    /// Instância compartilhada do serviço.
    static let shared = PokeAPIService()
    private init() {}

    /// Endereço base da PokeAPI.
    private let baseURL = "https://pokeapi.co/api/v2"

    /// Executa uma requisição e decodifica a resposta para o tipo solicitado.
    private func request<T: Decodable>(_ url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw PokeAPIError.invalidResponse
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw PokeAPIError.decodingError
        }
    }

    /// Busca as regiões principais disponíveis para navegação no aplicativo.
    func fetchRegions() async throws -> [Region] {
        guard let url = URL(string: "\(baseURL)/region") else {
            throw PokeAPIError.invalidURL
        }

        let response: RegionResponse = try await request(url)

        let allowed: Set<String> = [
            "kanto",
            "johto",
            "hoenn",
            "sinnoh",
            "unova",
            "kalos",
            "alola",
            "galar",
            "paldea"
        ]

        return response.results.filter {
            allowed.contains($0.name.lowercased())
        }
    }
    
    /// Converte o nome da região para o nome de Pokédex esperado pela PokeAPI.
    private func pokedexName(for region: String) -> String {
        switch region.lowercased() {

        case "kanto":
            return "kanto"

        case "johto":
            return "original-johto"

        case "hoenn":
            return "hoenn"

        case "sinnoh":
            return "original-sinnoh"

        case "unova":
            return "original-unova"

        case "kalos":
            return "kalos"

        case "alola":
            return "original-alola"

        case "galar":
            return "galar"

        case "paldea":
            return "paldea"

        default:
            return "kanto"
        }
    }

    private func fetchDex(_ name: String) async throws -> PokedexResponse {
        guard let url = URL(string: "\(baseURL)/pokedex/\(name)") else {
            throw PokeAPIError.invalidURL
        }
        return try await request(url)
    }

    /// Extrai o identificador numérico de uma URL de recurso da PokeAPI.
    private func extractId(from url: String) -> Int? {
        let parts = url.split(separator: "/").compactMap { Int($0) }
        return parts.last
    }

    /// Retorna o intervalo de identificadores associado à geração principal de cada região.
    private func generationRange(for region: String) -> ClosedRange<Int>? {
        switch region.lowercased() {

        case "kanto":
            return 1...151

        case "johto":
            return 152...251

        case "hoenn":
            return 252...386

        case "sinnoh":
            return 387...493

        case "unova":
            return 494...649

        case "kalos":
            return 650...721

        case "alola":
            return 722...809

        case "galar":
            return 810...905

        case "paldea":
            return 906...1025

        default:
            return nil
        }
    }

    /// Busca os Pokémon pertencentes a uma região e aplica os filtros necessários para a listagem.
    func fetchPokemonsByRegion(regionName: String) async throws -> [PokemonEntry] {

        let region = regionName.lowercased()

        if region == "kalos" {

            async let central: PokedexResponse = fetchDex("kalos-central")
            async let coastal: PokedexResponse = fetchDex("kalos-coastal")
            async let mountain: PokedexResponse = fetchDex("kalos-mountain")

            let results = try await (central, coastal, mountain)

            let combined =
                results.0.pokemon_entries +
                results.1.pokemon_entries +
                results.2.pokemon_entries

            let unique = Dictionary(
                grouping: combined,
                by: { $0.pokemon_species.name }
            )
            .compactMap { $0.value.first }

            return applyCleanMode(region: region, entries: unique)
                .sorted { $0.entry_number < $1.entry_number }
        }

        let pokedex = pokedexName(for: region)
        let response: PokedexResponse = try await fetchDex(pokedex)

        return applyCleanMode(region: region, entries: response.pokemon_entries)
            .sorted { $0.entry_number < $1.entry_number }
    }

    /// Remove entradas fora do intervalo esperado para a geração principal da região.
    private func applyCleanMode(region: String, entries: [PokemonEntry]) -> [PokemonEntry] {

        guard let range = generationRange(for: region) else {
            return entries
        }

        return entries.compactMap { entry in
            guard let id = extractId(from: entry.pokemon_species.url) else {
                return nil
            }

            return range.contains(id) ? entry : nil
        }
    }

    /// Busca os detalhes completos de um Pokémon pelo identificador numérico.
    func fetchPokemonDetail(id: Int) async throws -> PokemonDetail {
        guard let url = URL(string: "\(baseURL)/pokemon/\(id)") else {
            throw PokeAPIError.invalidURL
        }

        return try await request(url)
    }

    /// Busca os detalhes completos de um Pokémon pelo nome.
    func fetchPokemonDetail(name: String) async throws -> PokemonDetail {
        guard let url = URL(string: "\(baseURL)/pokemon/\(name.lowercased())") else {
            throw PokeAPIError.invalidURL
        }

        return try await request(url)
    }
}
