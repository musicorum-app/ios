import SwiftData
import SwiftUI

@Observable
class AuthViewModel {
    private let lastFMService = LastFMService()
    private let modelContext: ModelContext

    var isAuthenticated: Bool = false
    var username: String = ""

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        checkAuthStatus()
    }

    func startAuth() {
        if let url = lastFMService.getAuthURL() {
            UIApplication.shared.open(url)
        }
    }

    func handleCallback(url: URL) async {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let token = components.queryItems?.first(where: { $0.name == "token" })?.value
        else { return }

        do {
            let (sessionKey, username) = try await lastFMService.getSession(token: token)

            await MainActor.run {
                let auth = LastFMAuth(token: token, username: username, sessionKey: sessionKey)
                modelContext.insert(auth)
                try? modelContext.save()
                isAuthenticated = true
                self.username = username
            }
        } catch {
            print("Authentication failed: \(error)")
        }
    }

    private func checkAuthStatus() {
        let descriptor = FetchDescriptor<LastFMAuth>()
        if let auth = try? modelContext.fetch(descriptor).first {
            isAuthenticated = true
            username = auth.username
        }
    }
}
