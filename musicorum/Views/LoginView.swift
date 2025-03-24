import Foundation
import SwiftData
import SwiftUI

struct LoginView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var authViewModel: AuthViewModel
    
    init(modelContext: ModelContext) {
        _authViewModel = State(initialValue: AuthViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: 16) {
                Text("Welcome to the Musicorum App")
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Text(
                    "We need access to your Last.fm account to continue. By continuing you agree with our Privacy and Policy terms."
                )
                .font(.system(.footnote, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 40)
                .padding(.bottom, 20)

                Button(action: {
                    authViewModel.startAuth()
                }) {
                    Text("Login with Last.fm")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 40)
                }
            }

            Spacer()
        }
    }
}

#Preview {
    do {
        let container = try ModelContainer(for: LastFMAuth.self)
        return LoginView(modelContext: ModelContext(container))
    } catch {
        fatalError("Failed to create ModelContainer: \(error)")
    }
}
