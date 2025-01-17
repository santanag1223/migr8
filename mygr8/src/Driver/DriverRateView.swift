import SwiftUI
import MapKit

// View contains driver's setters for their
// rate and any offered RiderExtras.
struct DriverRateView: View {
    @ObservedObject var driver: Driver
    @ObservedObject var userState: UserState
    @State private var isEditingRate = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Current Rate Display
                    currentRateSection
                    
                    // Rider Extras Section
                    riderExtrasSection
                }
                .padding()
            }
            .navigationTitle("Your Rate")
            VStack {
                Spacer()
                
                // Status Toggle
                statusToggleButton
                    .padding()
            }
        }
    }
    
    private var statusToggleButton: some View {
        Button(action: {
            withAnimation {
                driver.driverStatus = driver.driverStatus == .online ? .offline : .online
            }
        }) {
            Text(driver.driverStatus == .online ? "Go Offline" : "Go Online")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(driver.driverStatus == .online ? Color.green : Color.purple)
                .cornerRadius(10)
        }
        .padding(.horizontal)
    }
    
    private var currentRateSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Current Rate")
                .font(.headline)
            
            HStack {
                Text("$\(driver.ratePerMile, specifier: "%.2f")")
                    .font(.system(size: 48, weight: .bold))
                Text("per mile")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if driver.regionSurgeMultiplier > 1.0 {
                Text("Surge pricing active: \(driver.regionSurgeMultiplier)x")
                    .foregroundColor(.orange)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private var riderExtrasSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Rider Extras")
                .font(.headline)
            
            ForEach(driver.riderExtras) { extra in
                RiderExtraRow(extra: extra)
            }
            
            Button(action: {
                // Add new extra
            }) {
                Label("Add New Extra", systemImage: "plus.circle")
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct RiderExtraRow: View {
    let extra: RiderExtra
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(extra.name)
                    .font(.headline)
                Text(extra.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("$\(extra.price, specifier: "%.2f")")
                .font(.headline)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

