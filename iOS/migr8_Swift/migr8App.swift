import SwiftUI

@main
struct migr8: App {
    var appData = AppData()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.userState, appData.userState)
                .environment(\.driverData, appData.driverData)
                .environment(\.riderData, appData.riderData)
        }
    }
}

// migr8 app ContentView
struct ContentView: View {
    @Environment(\.userState) var userState
    
    var body: some View {
        if userState.isLoggedIn {
            if userState.isDriver
            {
                DriverMainView()
            }
            else
            {
                RiderMainView()
            }
        }
        else {
            LoginView()
        }
    }
}

// LoginView
struct LoginView: View {
    @State private var loginAsDriver: Bool = true
    @Environment(\.userState) var userState
    
    var body: some View {

        VStack(spacing: 30) {
            Text("migr8")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.indigo)
            
            Picker("Select Type", selection: $loginAsDriver) {
                Text("Driver").tag(true)
                Text("Rider").tag(false)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            VStack(spacing: 15) {
                Button("Log In") {
                    userState.isDriver = loginAsDriver
                    userState.isLoggedIn = true
                }
                .buttonStyle(LoginButtonStyle())
                
                Button("Create Account") {
                    userState.isDriver = loginAsDriver
                    userState.isLoggedIn = true
                }
                .buttonStyle(CreateAccountButtonStyle())
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

// Button Styles
struct LoginButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.indigo)
            .cornerRadius(10)
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

struct CreateAccountButtonStyle: ButtonStyle {
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
