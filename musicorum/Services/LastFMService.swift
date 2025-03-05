import CryptoKit
import Foundation

class LastFMService {
    private let apiKey = "f1ec6a5448ba4717116643c69ac5b1c1"
    private let apiSecret = "c1b4c110ef136048fae10260b2aa23b6"
    private let baseURL = "https://ws.audioscrobbler.com/2.0/"

    func getAuthURL() -> URL? {
        let callbackURL = "musicorum://auth"
        return URL(string: "https://www.last.fm/api/auth/?api_key=\(apiKey)&cb=\(callbackURL)")
    }

    func getSession(token: String) async throws -> (String, String) {
        let params: [String: String] = [
            "method": "auth.getSession",
            "api_key": apiKey,
            "token": token,
        ]

        // Generate API signature as per Last.fm docs
        let signature = generateSignature(params: params)

        let url = URL(
            string:
                "\(baseURL)?method=auth.getSession&api_key=\(apiKey)&token=\(token)&api_sig=\(signature)&format=json"
        )!

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(SessionResponse.self, from: data)

        return (response.session.key, response.session.name)
    }

    private func generateSignature(params: [String: String]) -> String {
        let sortedKeys = params.keys.sorted()
        let signatureString =
            sortedKeys.reduce("") { result, key in
                result + key + params[key]!
            } + apiSecret

        return signatureString.md5
    }
}

struct SessionResponse: Codable {
    struct Session: Codable {
        let name: String
        let key: String
    }
    let session: Session
}

extension String {
    var md5: String {
        guard let data = self.data(using: .utf8) else { return "" }
        let digest = Insecure.MD5.hash(data: data)
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}
