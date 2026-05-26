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

    /// URL pública da imagem da Poké Ball usada na animação.
    private let pokeballURL =
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png")

    /// Conteúdo visual da experiência de captura.
    var body: some View {

        ZStack {
            

            VStack {
                Spacer()

                AsyncImage(url: pokeballURL) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
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
