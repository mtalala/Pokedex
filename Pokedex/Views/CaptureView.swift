import SwiftUI

struct CaptureView: View {

    let onCapture: () -> Void

    @State private var offsetY: CGFloat = 0
    @State private var progress: CGFloat = 0

    var body: some View {
        ZStack {

            backgroundLoop

            VStack {
                Spacer()

                Image("pokeball")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .scaleEffect(1 - progress * 0.5)
                    .offset(y: offsetY)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let t = min(value.translation.height, 0)
                                offsetY = t
                                progress = min(abs(t) / 300, 1)
                            }
                            .onEnded { _ in
                                if progress > 0.9 {
                                    onCapture()
                                }

                                withAnimation(.spring()) {
                                    offsetY = 0
                                    progress = 0
                                }
                            }
                    )

                Spacer()
            }
        }
    }

    private var backgroundLoop: some View {
        VStack {
            ForEach(0..<6, id: \.self) { _ in
                Image("pokeball")
                    .resizable()
                    .frame(width: 200)
                    .opacity(0.05)
                    .offset(y: -CGFloat.random(in: 50...300))
                    .animation(.linear(duration: 4).repeatForever(), value: UUID())
            }
        }
    }
}