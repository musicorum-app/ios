import Foundation
import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var authViewModel: AuthViewModel

    init(modelContext: ModelContext) {
        _authViewModel = State(initialValue: AuthViewModel(modelContext: modelContext))
    }

    var body: some View {
        ZStack {
            if authViewModel.isAuthenticated {
                VStack {
                    Text("Welcome, \(authViewModel.username)!")
                        .font(.title)
                }
            } else {
                LoginView(modelContext: modelContext)
            }
        }
        .preferredColorScheme(.dark)
        .onOpenURL { url in
            Task {
                await authViewModel.handleCallback(url: url)
            }
        }
    }
}

#Preview {
    do {
        let container = try ModelContainer(for: LastFMAuth.self)
        return ContentView(modelContext: ModelContext(container))
    } catch {
        fatalError("Failed to create ModelContainer: \(error)")
    }
}
