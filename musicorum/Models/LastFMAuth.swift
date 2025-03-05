import Foundation
import SwiftData

@Model
final class LastFMAuth {
    var token: String
    var username: String
    var sessionKey: String
    var timestamp: Date

    init(token: String, username: String, sessionKey: String, timestamp: Date = Date()) {
        self.token = token
        self.username = username
        self.sessionKey = sessionKey
        self.timestamp = timestamp
    }
}
