//
//  CaptureView.swift
//  Pokedex
//
//  Created by mtalala on 5/25/26.
//

import SwiftUI

struct CaptureView: View {

    let onCapture: () -> Void

    @State private var offsetY: CGFloat = 120
    @State private var scale: CGFloat = 1.9
    @State private var progress: CGFloat = 0
    @State private var captured = false
    @State private var isHinting = true

    @State private var animateHint = false

    private let pokeballURL =
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png")

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


    private func startHintLoop() {

        guard isHinting else { return }

        animateHint = true

        runHintStep()
    }

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
