//
//  SwipeView.swift
//  BloodConnect
//
import SwiftUI

struct SwipeView: View {
    var defaultText: String
    var swipedText: String = "Action Triggered" // Optional override
    
    @GestureState private var dragOffset = CGSize.zero
    @State private var isSwiped = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(AppColor.primaryRed.opacity(0.1))
                .frame(height: 50)

            Text(isSwiped ? swipedText : defaultText)
                .foregroundColor(AppColor.primaryRed)
                .bold()
        }
        .gesture(
            DragGesture()
                .updating($dragOffset) { value, state, _ in
                    state = value.translation
                }
                .onEnded { value in
                    if value.translation.width > 100 {
                        withAnimation {
                            isSwiped = true
                        }
                        // Trigger your custom logic here if needed
                    }
                }
        )
        .padding()
    }
}

struct SwipeView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            SwipeView(defaultText: "Swipe to Get Direction", swipedText: "Getting Directions...")
            SwipeView(defaultText: "Swipe to Request Blood", swipedText: "Request Sent!")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
