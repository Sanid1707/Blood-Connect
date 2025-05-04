import SwiftUI
struct SearchBarView: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            TextField("Search", text: $searchText)
                .padding()
                .padding(.horizontal, 30)
                .background(AppColor.card)
                .cornerRadius(10)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .foregroundColor(AppColor.secondaryText)
                )

            Button(action: {}) {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(.white)
                    .padding()
                    .background(AppColor.primaryRed)
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchText: .constant(""))
            .background(Color.white)
            .previewLayout(.sizeThatFits)
    }
}
