import SwiftUI

@main
struct migr8: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// migr8 app ContentView
struct ContentView: View {
    @State private var modelData = ModelData()
    
    var body: some View {
        if modelData.userState.isLoggedIn {
            if modelData.userState.isDriver
            {
                DriverMainView(driverData: DriverData())
                    .environment(modelData)
            }
            else
            {
                RiderMainView(riderData: RiderData())
                    .environment(modelData)
            }
        }
        else {
            LoginView()
                .environment(modelData)
        }
    }
}

// LoginView
struct LoginView: View {
    @Environment(ModelData.self) var modelData
    @State private var loginAsDriver: Bool = true
    
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
                    login()
                }
                .buttonStyle(LoginButtonStyle())
                
                Button("Create Account") {
                    createAccount()
                }
                .buttonStyle(CreateAccountButtonStyle())
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    private func login() {
        modelData.userState.isDriver = loginAsDriver
        modelData.userState.isLoggedIn = true
    }
    
    private func createAccount() {
        modelData.userState.isDriver = loginAsDriver
        modelData.userState.isLoggedIn = true
    }
    
    private func devSkip() {
        modelData.userState.isDriver = loginAsDriver
        modelData.userState.isLoggedIn = true
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
