import SwiftUI

struct Onboarding_1View: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            BottomCurveShape()
                .fill(Color.gray.opacity(0.1))
                .frame(height: 500)
                .edgesIgnoringSafeArea(.bottom)
            VStack {
                Spacer()
                
                // Illustration
                Image("Onboarding_1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 300)
                    .padding(.horizontal)
                
                Spacer()
                
                
                VStack(spacing: 10) {
                    Text("Discover Donor Based\nOn Blood Type")
                        .font(.system(size: 24, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                    
                    Text("Find blood that has been properly screened in your local hospital or donation center")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                HStack {
                    Text("Skip")
                        .foregroundColor(.black)
                        .font(.system(size: 16))
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color(red: 230/255, green: 4/255, blue: 73/255))
                            .frame(width: 8, height: 8)
                        
                        Circle()
                            .fill(Color.gray.opacity(0.4))
                            .frame(width: 8, height: 8)
                        Circle()
                            .fill(Color.gray.opacity(0.4))
                            .frame(width: 8, height: 8)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Handle next
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color(red: 230/255, green: 4/255, blue: 73/255))
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: "arrow.right")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold))
                        }
                    }
                }
                }
                
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
            
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
        }
    }


#Preview {
    Onboarding_1View()
}
