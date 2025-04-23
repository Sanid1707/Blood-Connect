import SwiftUI

struct Onboarding_3View: View {
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
                Image("Onboarding_3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 300)
                    .padding(.horizontal)
                
                Spacer()
                
                
                VStack(spacing: 10) {
                    Text("Locate Donors Around\n You")
                        .font(.system(size: 24, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                    
                    Text("Using our map feature locate possible donation centers around you.")
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
                            .fill(Color.gray.opacity(0.4))
                            .frame(width: 8, height: 8)
                                        
                        Circle()
                            .fill(Color.gray.opacity(0.4))
                            .frame(width: 8, height: 8)
                        Circle()
                            .fill(AppColor.primaryRed)
                            .frame(width: 8, height: 8)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Handle next
                    }) {
                        ZStack {
                            Circle()
                                .fill(AppColor.primaryRed)
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
    Onboarding_3View()
}
