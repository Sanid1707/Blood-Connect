import SwiftUI

struct BloodCenterDetailView: View {
    @State private var isSwiped = false

    var body: some View {
        VStack(spacing: 16) {
            // Top image
            Image("BloodCenter") // Replace with asset name or AsyncImage
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 400)
                .clipped()
                .overlay(
                    HStack {
                        Image(systemName: "chevron.left")
                            .padding()
                            .foregroundColor(.black)
                        Spacer()
                    }, alignment: .topLeading
                )

            // Title and rating
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Cork Blood Center")
                        .font(.headline)
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.subheadline)
                        Text("3.5")
                            .font(.subheadline)
                    }
                }

                HStack(spacing: 4) {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.red)
                    Text("Cork")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Text("A blood donation facility centered at the heart of Cork")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)

            // Review section
            VStack(alignment: .leading, spacing: 10) {
                Text("Review (256)")
                    .font(.headline)

                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(UIColor.systemGray6))
                    .frame(height: 40)
                    .overlay(Text("Write A Review").foregroundColor(.gray))
                
                // Review example
                HStack(alignment: .top, spacing: 12) {
                    Image( "Person")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray)

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Lilian Jack").bold()
                            Spacer()
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .font(.caption)
                                Text("4.7")
                                    .font(.caption)
                            }
                        }
                        Text("1 hour ago").font(.caption).foregroundColor(.gray)
                        Text("I was very happy donating today they made me feel like i was saving the workld and that was a really nice feeling.Also appreciated the complimentart snacks.")
                            .font(.caption)
                    }
                }
                .padding(.vertical, 4)

            }
            .padding(.horizontal)

            Spacer()

            // Swipe to Get Direction
            SwipeToDirectionView()
        }
        .padding(.top)
    }
}

struct SwipeToDirectionView: View {
    @GestureState private var dragOffset = CGSize.zero
    @State private var isSwiped = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.blue.opacity(0.1))
                .frame(height: 50)

            Text(isSwiped ? "Getting Directions..." : "Swipe to Get Direction")
                .foregroundColor(.blue)
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
                        // Insert logic to launch maps or navigation here
                    }
                }
        )
        .padding()
    }
}
#Preview {
    BloodCenterDetailView()
}

