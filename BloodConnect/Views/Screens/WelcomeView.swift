import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.white
                .edgesIgnoringSafeArea(.all)

            // Bottom curve
            BottomCurveShape()
                .fill(Color.gray.opacity(0.1))
                .frame(height: 400)
                .edgesIgnoringSafeArea(.bottom)

            VStack(spacing: 30) {
                Spacer()

                // Top illustration
                Image("Welcome") // Make sure it's in Assets
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 300)
                    .padding(.horizontal)

                Spacer()

                // Title and description
                VStack(spacing: 10) {
                    Text("Welcome BloodConnect:\nNearby City")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)

                    Text("Create an Account to get Started")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }

                // Buttons
                VStack(spacing: 16) {
                    Button(action: {
                        // Navigate to Sign Up
                    }) {
                        Text("Sign Up")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppColor.primaryRed)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        // Navigate to Sign In
                    }) {
                        Text("Sign In")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(AppColor.primaryRed, lineWidth: 1.5)
                            )
                            .foregroundColor(AppColor.primaryRed)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            }
        }
    }
}
#Preview {
    WelcomeView()
}
