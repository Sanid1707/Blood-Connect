import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 53.3498, longitude: -6.2603), // Dublin
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        ZStack {
            // Map Background
            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: viewModel.donationCenters) { center in
                MapAnnotation(coordinate: center.coordinate) {
                    DonationCenterPinView(isSelected: viewModel.selectedCenter?.id == center.id)
                        .onTapGesture {
                            viewModel.selectCenter(center)
                            
                            // Update map region to center on selected donation center
                            withAnimation {
                                region = MKCoordinateRegion(
                                    center: center.coordinate,
                                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                )
                            }
                        }
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            // Top Bar
            VStack {
                HStack {
                    Text("Donation Centers")
                        .font(.headline)
                        .foregroundColor(AppColor.text)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(AppColor.card.opacity(0.9))
                        )
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 50)
                
                Spacer()
                
                // Bottom Card (if a donation center is selected)
                if let selected = viewModel.selectedCenter {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(selected.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(AppColor.text)
                        
                        Text(selected.formattedAddress)
                            .font(.subheadline)
                            .foregroundColor(AppColor.secondaryText)
                        
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(AppColor.primaryRed)
                            Text(selected.formattedHours)
                                .font(.caption)
                                .foregroundColor(AppColor.secondaryText)
                        }
                        
                        HStack {
                            Image(systemName: "location.circle")
                                .foregroundColor(AppColor.primaryRed)
                            Text(String(format: "%.1f km away", selected.distance ?? 0.0))
                                .font(.caption)
                                .foregroundColor(AppColor.secondaryText)
                        }
                        
                        if !selected.acceptedBloodTypes.isEmpty {
                            HStack {
                                Image(systemName: "drop.fill")
                                    .foregroundColor(AppColor.primaryRed)
                                Text("Accepts: " + selected.acceptedBloodTypes.map { $0.rawValue }.joined(separator: ", "))
                                    .font(.caption)
                                    .foregroundColor(AppColor.secondaryText)
                            }
                        }
                        
                        if !selected.currentNeed.isEmpty {
                            HStack {
                                Image(systemName: "exclamationmark.triangle")
                                    .foregroundColor(selected.currentNeed.contains(.critical) ? .red : .orange)
                                Text("Need: " + selected.currentNeed.map { $0.rawValue }.joined(separator: ", "))
                                    .font(.caption)
                                    .foregroundColor(AppColor.secondaryText)
                            }
                        }
                        
                        HStack(spacing: 15) {
                            Button(action: {
                                viewModel.callCenter(selected)
                            }) {
                                VStack {
                                    Image(systemName: "phone.fill")
                                        .font(.title3)
                                    Text("Call")
                                        .font(.caption)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(AppColor.primaryRed)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            
                            Button(action: {
                                viewModel.getDirections(to: selected)
                            }) {
                                VStack {
                                    Image(systemName: "map.fill")
                                        .font(.title3)
                                    Text("Directions")
                                        .font(.caption)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(AppColor.primaryRed)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        }
                        .padding(.top, 5)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(AppColor.card)
                            .shadow(color: AppColor.shadow, radius: 5, x: 0, y: 2)
                    )
                    .padding()
                }
            }
            
            // Loading indicator
            if viewModel.isLoading {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                    Text("Locating nearby donation centers...")
                        .foregroundColor(.white)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColor.card.opacity(0.8))
                )
                .padding()
            }
        }
        .onAppear {
            viewModel.requestLocationAccess()
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct DonationCenterPinView: View {
    var isSelected: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(isSelected ? AppColor.primaryRed : Color.red)
                    .frame(width: 24, height: 24)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 12, height: 12)
            }
            
            Triangle()
                .fill(isSelected ? AppColor.primaryRed : Color.red)
                .frame(width: 16, height: 8)
                .offset(y: -1)
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
} 