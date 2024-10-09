import SwiftUI

struct Logout: View {
    
    @State private var isLoggingOut = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showGoodbyeView = false
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode

       

    var body: some View {
        VStack {
            if isLoggingOut {
                ProgressView("Logging out...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
            }
            if showGoodbyeView {
                            Goodbye()
                                .transition(.opacity)  // Add a transition effect
                        }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Logout Status"), message: Text(alertMessage), dismissButton: .default(Text("OK"), action: {
                if alertMessage == "Successfully logged out." {
                  
                                          
                    showGoodbyeView = true 
                  
                       
                        
                                     
                }
            }))
        }
        .onAppear {
            logout()  // Automatically call logout when the view appears
        }
        .navigationBarHidden(true)
    }
    
    func logout() {
        isLoggingOut = true
        guard let url = URL(string: "http://192.168.0.219:8000/api/v1/auth/logout/") else {
            DispatchQueue.main.async {
                alertMessage = "Invalid URL"
                showAlert = true
                isLoggingOut = false
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoggingOut = false
                if let error = error {
                    alertMessage = "Error: \(error.localizedDescription)"
                    showAlert = true
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    alertMessage = "Failed to log out. Please try again."
                    showAlert = true
                    return
                }

                alertMessage = "Successfully logged out."
                showAlert = true
            }
        }.resume()
    }
}
