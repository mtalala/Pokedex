//
//  SkeletonRectangle.swift
//  Pokedex
//
//  Created by mtalala on 5/21/26.
//


import SwiftUI

/// Retângulo animado utilizado para indicar que uma informação ainda está sendo carregada.
///
/// Esse componente cria um efeito visual de carregamento, oferecendo ao usuário uma resposta imediata
/// enquanto imagens ou dados remotos ainda não foram concluídos.
struct SkeletonRectangle: View {

    /// Controla a posição da faixa luminosa da animação.
    @State private var phase: CGFloat = -1

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.3))
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.clear,
                            Color.white.opacity(0.6),
                            Color.clear
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .rotationEffect(.degrees(20))
                    .offset(x: phase * geo.size.width)
                }
            )
            .clipped()
            .onAppear {
                withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                    phase = 1.5
                }
            }
    }
}