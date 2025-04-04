import SwiftUI

struct BloodDropComponent: View {
    let bloodType: String
    var size: CGFloat = 40
    var textSize: CGFloat = 14
    
    var body: some View {
        ZStack(alignment: .center) {
            Image(systemName: "drop.fill")
                .font(.system(size: size, weight: .semibold))
                .foregroundColor(AppColor.primaryRed)
                .frame(width: size * 1.3, height: size * 1.3)
            
            Text(bloodType)
                .font(.system(size: textSize, weight: .bold))
                .foregroundColor(.white)
                .offset(y: 1)
        }
        .frame(width: size * 1.3, height: size * 1.3)
    }
}

struct BloodDropComponent_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack(spacing: 20) {
                    BloodDropComponent(bloodType: "A+")
                    BloodDropComponent(bloodType: "B-")
                    BloodDropComponent(bloodType: "O+")
                    BloodDropComponent(bloodType: "AB+")
                }
                
                HStack(spacing: 20) {
                    BloodDropComponent(bloodType: "A-")
                    BloodDropComponent(bloodType: "B+")
                    BloodDropComponent(bloodType: "O-")
                    BloodDropComponent(bloodType: "AB-")
                }
            }
            .padding()
        }
        .previewLayout(.sizeThatFits)
    }
} 