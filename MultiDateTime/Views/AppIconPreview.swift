import SwiftUI

struct AppIconView: View {
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.10, blue: 0.25),
                    Color(red: 0.12, green: 0.05, blue: 0.30)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Subtle globe meridian rings
            ForEach(0..<3) { i in
                Ellipse()
                    .stroke(Color.white.opacity(0.07), lineWidth: 1)
                    .scaleEffect(x: CGFloat(i + 1) * 0.28, y: 1.0)
                    .frame(width: 260, height: 260)
            }
            Circle()
                .stroke(Color.white.opacity(0.07), lineWidth: 1)
                .frame(width: 260, height: 260)

            // Horizontal equator line
            Rectangle()
                .fill(Color.white.opacity(0.07))
                .frame(width: 260, height: 1)

            // Clock face circle
            Circle()
                .fill(Color.white.opacity(0.10))
                .frame(width: 180, height: 180)

            Circle()
                .stroke(Color.white.opacity(0.25), lineWidth: 1.5)
                .frame(width: 180, height: 180)

            // Hour markers
            ForEach(0..<12) { i in
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color.white.opacity(i % 3 == 0 ? 0.8 : 0.35))
                    .frame(width: i % 3 == 0 ? 2.5 : 1.5, height: i % 3 == 0 ? 10 : 6)
                    .offset(y: -78)
                    .rotationEffect(.degrees(Double(i) * 30))
            }

            // Hour hand (pointing ~10 o'clock)
            Capsule()
                .fill(Color.white)
                .frame(width: 3, height: 50)
                .offset(y: -25)
                .rotationEffect(.degrees(-60))

            // Minute hand (pointing ~2 o'clock)
            Capsule()
                .fill(Color.white)
                .frame(width: 2, height: 68)
                .offset(y: -34)
                .rotationEffect(.degrees(60))

            // Center dot
            Circle()
                .fill(Color(red: 0.5, green: 0.4, blue: 1.0))
                .frame(width: 8, height: 8)
        }
        .frame(width: 1024, height: 1024)
        .clipShape(RoundedRectangle(cornerRadius: 224, style: .continuous))
    }
}

#Preview("App Icon") {
    AppIconView()
        .frame(width: 300, height: 300)
}
