import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color(hex: "FFEEF1")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                VStack(spacing: 20) {
                    // App logo
                    Image(systemName: "drop.fill")
                        .font(.system(size: 80))
                        .foregroundColor(AppColor.primaryRed)
                    
                    // App name
                    Text("BloodConnect")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(AppColor.primaryRed)
                    
                    // Tagline
                    Text("Donate Blood, Save Lives")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 1.0
                        self.opacity = 1.0
                    }
                }
                
                // Loading indicator
                VStack {
                    Spacer().frame(height: 80)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: AppColor.primaryRed))
                        .scaleEffect(1.5)
                }
            }
        }
        .onAppear {
            // Automatically transition to AuthView after 2.5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            AuthView()
        }
    }
}

#Preview {
    SplashView()
} 