import SwiftUI
import MapKit
import CoreLocation

struct Singapore2DMapView: View {
    @StateObject private var locationManager = LocationMapManager()
    @State private var mapType: MKMapType = .standard
    @State private var users: [UserPoints] = []
    @State private var selectedUser: UserPoints?

    private let singaporeRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 1.3521, longitude: 103.8198),
        span: MKCoordinateSpan(latitudeDelta: 0.35, longitudeDelta: 0.35)
    )

    var body: some View {
        VStack {
            MapViewRepresentable(
                region: singaporeRegion,
                mapType: $mapType,
                showsUserLocation: true,
                users: users,
                selectedUser: $selectedUser
            )
            .edgesIgnoringSafeArea(.all)
            .sheet(item: $selectedUser) { user in

                UserDetailView(user: user)
            }
        }
        .onAppear {

            Task {
                if let allUsers = await SupabaseManager.shared.getAllUsers() {
                    self.users = allUsers
                }
            }
        }
    }
}

struct UserDetailView: View {
    let user: UserPoints
    @State private var posts: [Post] = []
    @State private var postContent: String = ""
    @State private var canPost: Bool = true
    @State private var showAlert: Bool = false

    var body: some View {
        VStack(spacing: 20) {

            Text("User ID: \(user.id)")
                .font(.headline)
            Text("Points: \(user.points)")
                .font(.subheadline)

            Text("Recent Posts")
                .font(.headline)
                .padding(.top)

            ScrollView {
                ForEach(posts) { post in
                    VStack(alignment: .leading) {
                        Text(post.content)
                            .font(.body)
                        Text("Posted on: \(post.timestamp, formatter: dateFormatter)")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.bottom)
                }
            }

            HStack {
                TextField("What's on your mind?", text: $postContent)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)

                Button(action: {
                    Task {
                        if canPost {
                            print("Attempting to post with user ID: \(user.id)")
                            let success = await SupabaseManager.shared.addPost(userId: user.id, content: postContent)
                            if (success != nil) {
                                print("Post successful with ID: \(success!)")
                                postContent = ""
                                loadPosts()
                            } else {
                                print("Post failed - no post ID returned")
                                showAlert = true
                            }
                        } else {
                            showAlert = true
                        }
                    }
                }) {
                    Text("Post")
                        .padding()
                        .background(canPost ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!canPost)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Post Limit Reached"),
                      message: Text("You can only post twice a day."),
                      dismissButton: .default(Text("OK")))
            }
        }
        .onAppear {
            Task {
                let userPosts = await SupabaseManager.shared.getUserPosts(userId: user.id)
                posts = userPosts ?? []

                canPost = await SupabaseManager.shared.canPostToday(userId: user.id)
            }
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }

    func loadPosts() {
        Task {

            let userPosts = await SupabaseManager.shared.getUserPosts(userId: user.id)
            posts = userPosts ?? []
        }
    }
}

struct MapViewRepresentable: UIViewRepresentable {
    let region: MKCoordinateRegion
    @Binding var mapType: MKMapType
    let showsUserLocation: Bool
    let users: [UserPoints]
    @Binding var selectedUser: UserPoints?

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = showsUserLocation
        mapView.mapType = mapType
        mapView.region = region
        mapView.delegate = context.coordinator

        addUserAnnotations(to: mapView)

        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.mapType = mapType
        addUserAnnotations(to: mapView)
    }

    func addUserAnnotations(to mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations)

        for user in users {
            let userCoordinate = CLLocationCoordinate2D(latitude: user.latitude, longitude: user.longitude)
            let annotation = UserAnnotation(id: user.id, title: "User \(user.id)", coordinate: userCoordinate, userPoints: user.points)
            mapView.addAnnotation(annotation)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewRepresentable

        init(_ parent: MapViewRepresentable) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
            guard let userAnnotation = annotation as? UserAnnotation else { return }

            parent.selectedUser = UserPoints(id: userAnnotation.id, points: userAnnotation.userPoints, latitude: userAnnotation.coordinate.latitude, longitude: userAnnotation.coordinate.longitude)
        }
    }
}

class LocationMapManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()

    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus

    override init() {
        authorizationStatus = locationManager.authorizationStatus

        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = location
        }
    }
}

struct Connect: View {
    @AppStorage("userPoints") var storedPoints: Int = 0
    @State var points: Int = 0

    var body: some View {
        VStack {
            Singapore2DMapView()
                .overlay {
                    VStack {
                        GeometryReader { geometry in
                            HStack {
                                Spacer()
                                VStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.7))
                                        .frame(width: geometry.size.width * 0.9, height: 60)
                                        .overlay {
                                            HStack {
                                                Spacer()
                                                Button {
                                                    points += 10
                                                    storedPoints = points
                                                } label: {
                                                    Label("Medal", systemImage: "medal")
                                                        .font(.title)
                                                        .labelStyle(.iconOnly)
                                                }
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.red)
                                                    .overlay {
                                                        HStack {
                                                            
                                                            Text("XP: \(points)")
                                                                .font(.custom("Outfit", size: 32))
                                                                .foregroundStyle(.white)
                                                        }
                                                    }
                                                    .frame(width: 280, height: 40)
                                                Spacer()
                                            }
                                        }
                                        .padding()
                                        .shadow(radius: 10)
                                }
                            }
                            .offset(y: 20)
                        }
                        Spacer()
                    }
                }
        }
        .onAppear {
            points = storedPoints
        }
    }
}

#Preview {
    Connect()
}
