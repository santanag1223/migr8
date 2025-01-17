import SwiftUI

@main
struct MigrateApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

enum UserType {
    case rider
    case driver
}

// StateModel for login page
class UserState: ObservableObject {
    @Published var isLoggedIn = false
    @Published var userType: UserType = .rider
}

struct ContentView: View {
    @StateObject private var userState = UserState()
    
    var body: some View {
        if userState.isLoggedIn {
            switch userState.userType {
            case .driver:
                DriverMainView(userState: self.userState)
            case .rider:
                RiderMainView(userState: self.userState)
            }
        } else {
            LoginView()
                .environmentObject(userState)
        }
    }
}

struct LoginView: View {
    @EnvironmentObject var userState: UserState
    @State private var selectedType: UserType = .rider
    
    var body: some View {
        VStack(spacing: 30) {
            Text("migr8")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.blue)
            
            Picker("Select Type", selection: $selectedType) {
                Text("Rider").tag(UserType.rider)
                Text("Driver").tag(UserType.driver)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            VStack(spacing: 15) {
                Button("Log In") {
                    login()
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Button("Create Account") {
                    createAccount()
                }
                .buttonStyle(SecondaryButtonStyle())
                
                Button("Dev Skip") {
                    devSkip()
                }
                .foregroundColor(.purple)
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    private func login() {
        userState.userType = selectedType
        userState.isLoggedIn = true
    }
    
    private func createAccount() {
        userState.userType = selectedType
        userState.isLoggedIn = true
    }
    
    private func devSkip() {
        userState.userType = selectedType
        userState.isLoggedIn = true
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .cornerRadius(10)
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}
