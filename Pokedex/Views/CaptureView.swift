//
//  CaptureView.swift
//  Pokedex
//
//  Created by mtalala on 5/25/26.
//

import SwiftUI

/// Tela interativa que simula a captura de um Pokémon.
///
/// O usuário arrasta a Poké Ball para confirmar a ação. Quando o gesto atinge o progresso necessário,
/// a view executa o fechamento recebido em `onCapture`.
struct CaptureView: View {

    /// Nome do Pokémon prestes a ser capturado.
    let pokemonName: String

    /// URL da sprite do Pokémon prestes a ser capturado.
    let pokemonSpriteURL: URL?

    /// Ação chamada quando o usuário volta para a tela de detalhes.
    let onBack: () -> Void

    /// Ação chamada quando a captura é concluída.
    let onCapture: () -> Void

    /// Posição vertical da Poké Ball durante a animação.
    @State private var offsetY: CGFloat = 120

    /// Escala visual da Poké Ball.
    @State private var scale: CGFloat = 1.9

    /// Progresso do gesto de captura.
    @State private var progress: CGFloat = 0

    /// Indica se a captura já foi confirmada.
    @State private var captured = false

    /// Indica se a animação de sugestão ainda deve ser exibida.
    @State private var isHinting = true

    /// Estado auxiliar para o ciclo de sugestão visual.
    @State private var animateHint = false

    /// Conteúdo visual da experiência de captura.
    var body: some View {

        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                AsyncImage(url: pokemonSpriteURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable().interpolation(.none).scaledToFit()
                    case .failure:
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 72))
                            .foregroundStyle(.secondary)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 220, height: 220)
                .accessibilityLabel(pokemonName.capitalized)

                Image("pokeball")
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .scaleEffect(scale - progress * 0.9)
                    .offset(y: offsetY)
                    .onAppear {
                        startHintLoop()
                    }
                    .gesture(
                    DragGesture()
                        .onChanged { value in

                            if isHinting {
                                isHinting = false
                                animateHint = false
                            }

                            guard !captured else { return }

                            let drag = min(value.translation.height, 0)

                            offsetY = 120 + drag
                            progress = min(abs(drag) / 220, 1)
                        }
                        .onEnded { _ in

                            guard !captured else { return }

                            if progress > 0.7 {

                                captured = true

                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    offsetY = -650
                                    scale = 0.8
                                    progress = 1
                                }

                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                    onCapture()
                                }

                            } else {
                                withAnimation(.spring()) {
                                    offsetY = 120
                                    scale = 1.9
                                    progress = 0
                                }
                            }
                        }
                )

                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        onBack()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .accessibilityLabel("Voltar")
                }
            }
        }
    }


    /// Inicia a animação que sugere ao usuário o movimento de arrastar.
    private func startHintLoop() {

        guard isHinting else { return }

        animateHint = true

        runHintStep()
    }

    /// Executa uma etapa do ciclo de sugestão visual da Poké Ball.
    private func runHintStep() {

        guard isHinting else { return }

        withAnimation(.easeInOut(duration: 0.9)) {
            offsetY = -120      // sobe
            scale = 1.2         // diminui
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {

            guard isHinting else { return }

            withAnimation(.easeInOut(duration: 0.9)) {
                offsetY = 120      // volta
                scale = 1.9        // volta grande
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                runHintStep() // loop
            }
        }
    }
}
