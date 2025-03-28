import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
                
                ZStack(alignment: .leading) {
                    if searchText.isEmpty {
                        Text("Search")
                            .foregroundColor(.gray)
                    }
                    TextField("", text: $searchText)
                        .foregroundColor(.black)
                        .accentColor(.black)
                        .tint(.black)
                }
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .cornerRadius(10)
            
            Button(action: {
                // Filter action
            }) {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.red)
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
