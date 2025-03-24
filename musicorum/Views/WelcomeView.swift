import SwiftUI

struct WelcomeView: View {
    @State private var isCrashReportEnabled = true
    
    var body: some View {
        VStack(spacing: 20) {
            // Profile Image
            Image("profileImage") // Replace "profileImage" with your image asset name
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .shadow(radius: 10)
            
            // Welcome Text
            Text("Welcome, metye!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            // Toggle for Crash Reports
            HStack {
                Toggle(isOn: $isCrashReportEnabled) {
                    Text("Agree to share crash reports and device information")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .toggleStyle(SwitchToggleStyle(tint: Color.green))
            }
            .padding()
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all)) // Background color
    }
}

#Preview {
    WelcomeView()
}
