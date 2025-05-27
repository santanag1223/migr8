import SwiftUI
import MapKit

/// Model for a pending rider
struct PendingRider: Identifiable, View {
    var id = UUID()
    var name: String = "Rider Name"
    var locationDescription: String = "Location"
    var rideDistance: CLLocationDistance = 0.0
    var fareEstimate: Float = 0.0
    var coordinate: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0)
    
    init(name: String = "Rider Name",
         locationDescription: String = "Location",
         rideDistance: CLLocationDistance = 0.0,
         fareEstimate: Float = 0.0,
         coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    ) {
        self.name = name
        self.locationDescription = locationDescription
        self.rideDistance = rideDistance
        self.fareEstimate = fareEstimate
        self.coordinate = coordinate
    }

    var body : some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                Text(locationDescription)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(String(format: "$%.2f", fareEstimate))
                    .foregroundColor(.white)
                Text(String(format: "%.1f mi", rideDistance))
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
    }
    
    func mapConent() -> some MapContent {
        Annotation(self.name,
                   coordinate: coordinate,
                   content: {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.indigo)
                Image(systemName: "figure.wave")
                    .background(Color.indigo.opacity(0.25))
                    .foregroundStyle(.white)
                    .padding(5)
            }
        })
    }
}

/// Model for a surge pricing zone
struct SurgePricingZone: Identifiable {
    var id: UUID = UUID()
    var name: String = ""
    var multiplier: Float = 0.0
    var coordinate: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0)
    
    init(name: String = "",
         multiplier: Float = 0.0,
         coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0))
    {
        self.name = name
        self.multiplier = multiplier
        self.coordinate = coordinate
    }
    
    func ZoneCircle() -> some MapContent {
        MapCircle(center: self.coordinate, radius: 100 /* meters */)
            .foregroundStyle(.yellow.opacity(0.50))
            .mapOverlayLevel(level: .aboveRoads)
    }
    
    func ZoneMarker() {
        Marker(self.name, coordinate: self.coordinate)
    }
    
    func view() -> some View {
        HStack() {
            Text(self.name)
                .foregroundColor(.white)
                .font(.callout)
                .padding(.leading, 20)
            
            Spacer()
            
            Button(action: {
                
            }, label: {
                Label(title: {
                    Text(String(format: "x%.2f", self.multiplier))
                        .fontDesign(.monospaced)
                }, icon: {
                    Image(systemName: "mappin.circle")
                })
            })
            .tint(.yellow)
            .padding(.trailing, 40)
        }
    }
}

enum DriverMapStatus {
    case driverOffline
    case pendingRider
    case rideActive
}

/// Collapsible overlay showing surge rates
struct CollapsibleRateMapOverlay: View {
    @Binding var isCollapsed: Bool
    @Binding var zones: [SurgePricingZone]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15 ) {
            HStack {
                Text("High Demand Areas")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.leading, 15)
                Spacer()
                Button(action: { isCollapsed.toggle() }) {
                    Image(systemName: isCollapsed ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white)
                }
                .padding(.trailing, 30)
            }
            
            if !isCollapsed {
                ForEach(zones) { zone in
                    zone.view()
                }
            }
        }
        .padding(.bottom, 20)
        .background(Color.gray.opacity(0.75))
    }
}

struct DriverMapView: View {
    @Namespace var mapScope
    
    @State private var selectedItem: UUID? = nil
    
    @State private var mapStatus: DriverMapStatus = .driverOffline
    @State private var locationManager: CLLocationManager = CLLocationManager()
    @State private var cameraPosition: MapCameraPosition = .region(
        .init(
            center: .MercerAndFirst,
            span: MKCoordinateSpan(
                latitudeDelta: 1500,
                longitudeDelta: 1500)
        )
    )
    
    @State private var route: MKRoute? = nil
    
    @State private var pendingRiders: [PendingRider] = []
    
    @State private var surgeZones: [SurgePricingZone] = [
        SurgePricingZone(
            name: "Space Needle",
            multiplier: Float.random(in: 1...2),
            coordinate: .SpaceNeedle),
        SurgePricingZone(
            name: "Climate Arena",
            multiplier: Float.random(in: 1...2),
            coordinate: .ClimateArena),
        SurgePricingZone(
            name: "Park",
            multiplier: Float.random(in: 1...2),
            coordinate: .KerryPark),
        SurgePricingZone(
            name: "Pike Place Market",
            multiplier: Float.random(in: 1...2),
            coordinate: .PikePlace)
    ]
    
    @State private var isOnline: Bool = false
    @State private var isRateCollapsed: Bool = false
    
    var body: some View {
        ZStack {
            Map(position: $cameraPosition,
                selection: $selectedItem,
                scope: mapScope,
                content: {
                
                UserAnnotation()
            
                if let route {
                    MapPolyline(route).stroke(Color.indigo, lineWidth: 3)
                }
                
                if !$pendingRiders.isEmpty {
                    ForEach(pendingRiders) { rider in
                        rider.mapConent()
                            .tag(rider.id)
                    }
                }
                
                if !$surgeZones.isEmpty {
                    ForEach(surgeZones) { zone in
                        zone.ZoneCircle()
                            .tag(zone.id)
                    }
                }
            })
            .mapScope(mapScope)
            .mapControls {
                MapCompass(scope: mapScope)
                MapScaleView(scope: mapScope)
                MapUserLocationButton(scope: mapScope)
                MapPitchToggle(scope: mapScope)
            }
            .safeAreaInset(edge: .bottom) {
                LowerButtonStack()
            }
            .safeAreaInset(edge: .top) {
                CollapsibleRateMapOverlay(isCollapsed: $isRateCollapsed, zones: $surgeZones)
            }
            .onAppear(){
                locationManager.requestWhenInUseAuthorization()
            }
            .onChange(of: selectedItem) {
                guard let selectedItem else { return }
                guard let item = pendingRiders.first(where: { $0.id == selectedItem }) else { return }
                print(item.coordinate)
            }
        }
    }
    
    func LowerButtonStack() -> some View {
        HStack(alignment: .center, spacing: 20) {
            Button(action: {
                AddNewRider()
            }) {
                Image(systemName: "figure.wave")
                    .resizable()
                    .frame(width: 10, height: 20)
                    .padding(14)
                    .background(Color.white.opacity(0.8))
                    .clipShape(Circle())
                    .padding(.bottom, 15)
            }
            
            Button(action: {
                AddNewZone()
            }) {
                Image(systemName: "car.circle")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(15)
                    .background(Color.white.opacity(0.8))
                    .clipShape(Circle())
                    .padding(.bottom, 15)
            }
            
            Button(action: {
                AddNewZone()
            }) {
                Image(systemName: "arrow.clockwise")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .padding(12)
                    .background(Color.white.opacity(0.8))
                    .clipShape(Circle())
                    .padding(.bottom, 15)
            }
        }
    }

    func getUserLocation() async -> CLLocationCoordinate2D? {
        let updates = CLLocationUpdate.liveUpdates()
        do {
            let update = try await updates.first {$0.location?.coordinate != nil}
            return update?.location?.coordinate
        }
        catch {
            print("Cannot get user location.")
            return nil
        }
    }
    
    func getDirections(to destination: CLLocationCoordinate2D) {
        Task {
            guard let userLocation = await getUserLocation() else { return }
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
            request.transportType = .automobile
            do {
                let directions = try await MKDirections(request: request).calculate()
                route = directions.routes.first
            }
            catch {
                print("Error calculating directions.")
            }
        }
    }
    
    func randomLocalCoordinate() -> CLLocationCoordinate2D {
        let cameraPos = locationManager.location?.coordinate ?? .MercerAndFirst
        return CLLocationCoordinate2D(
            latitude: cameraPos.latitude + Double.random(in: -0.005...0.005),
            longitude: cameraPos.longitude + Double.random(in: -0.005...0.005))
    }
    
    func AddNewZone() {
        surgeZones.append(
            SurgePricingZone(
            name: "New Zone",
            multiplier: Float.random(in: 1...2),
            coordinate: randomLocalCoordinate()))
    }
    
    func AddNewRider() {
        pendingRiders.append(
            PendingRider(
            coordinate: randomLocalCoordinate()))
    }
}

struct DriverMapView_Preview: PreviewProvider {
    static var previews: some View {
        DriverMapView()
    }
}

extension CLLocationCoordinate2D {
    static let SpaceNeedle: CLLocationCoordinate2D = .init(latitude: 47.62009, longitude: -122.34928)
    static let ClimateArena: CLLocationCoordinate2D = .init(latitude: 47.62110, longitude: -122.35512)
    static let KerryPark: CLLocationCoordinate2D = .init(latitude: 47.62872, longitude: -122.35939)
    static let PikePlace: CLLocationCoordinate2D = .init(latitude: 47.60886, longitude: -122.34001)
    static let MercerAndFirst: CLLocationCoordinate2D = .init(latitude: 47.62455, longitude: -122.35540)
}
