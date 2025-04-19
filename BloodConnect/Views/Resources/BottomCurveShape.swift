import SwiftUI

struct BottomCurveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Start from bottom-left corner
        path.move(to: CGPoint(x: 0, y: rect.height * 0.3))

        // Curve to bottom-right corner
        path.addQuadCurve(
            to: CGPoint(x: rect.width, y: rect.height * 0.3),
            control: CGPoint(x: rect.width / 2, y: 0)
        )

        // Draw down to the bottom corners
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()

        return path
    }
}
