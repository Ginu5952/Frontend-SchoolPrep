import SwiftUI

struct Parent: View {
    @State private var isMenuOpen = false
    @State private var isLoading = true
    @State private var parentProfile: [String: Any] = [:]
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        ZStack {
           
            if isLoading {
                           
                            VStack {
                                ProgressView("Loading...")
                                    .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                                    .scaleEffect(1.5)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.white)
                            .navigationBarHidden(true)
            } else {
            
            
                VStack {
                   
                    ZStack {
                        LinearGradient(
                                   gradient: Gradient(colors: [Color(red: 0/255, green: 0/255, blue: 50/255),
                                                               Color(red: 0/255, green: 0/255, blue: 150/255)]),
                                   startPoint: .top,
                                   endPoint: .bottom
                        )
                            .edgesIgnoringSafeArea(.top)
                            .frame(height: 200)

                        VStack(spacing: 16) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.white)
                            
                            

                            
                            if let user = parentProfile["user"] as? [String: Any],
                                    let firstName = user["first_name"] as? String,
                                    let lastName = user["last_name"] as? String {
                                    Text("\(firstName.capitalized) \(lastName.capitalized)")
                                    .font(.title)
                                    .foregroundColor(.white)
                            } else {
                                    Text("Anna Avetisyan")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.top, 10)
                    } .padding(.top, 0)

                    Form {
                        
                        HStack {
                            Image(systemName: "tag")
                                .foregroundColor(.blue)
                                .opacity(0.8)
                            if let id = parentProfile["id"] as? Int {
                                   Text("\(id)")
                               } else {
                                   Text("0")
                               }
                            Spacer()
                        }

                        
                        
                        
                        HStack {
                            Image(systemName: "person")
                                .foregroundColor(.blue)
                                .opacity(0.8)
                            if let user = parentProfile["user"] as? [String: Any],
                                let username = user["username"] as? String {
                                Text(username)
                            } else {
                                Text("Anna Avetisyan")
                            }
                            Spacer()
                        }

                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.blue)
                                .opacity(0.8)
                            if let user = parentProfile["user"] as? [String: Any],
                               let email = user["email"] as? String {
                                Text(email)
                            } else {
                                Text("info@aplusdesign.co")
                            }
                            
                            Spacer()
                        }

                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.blue)
                                .opacity(0.8)
                            if let gender = parentProfile["gender"] as? String {
                                Text(gender == "M" ? "Male" : (gender == "F" ? "Female" : "Unknown"))
                            } else {
                                Text("M")
                            }
                            
                            Spacer()
                        }

                        HStack {
                            Image(systemName: "house")
                                .foregroundColor(.blue)
                                .opacity(0.8)
                            if let address = parentProfile["address"] as? String {
                                Text(address)
                            } else {
                                Text("Address not available")
                            }
                            
                            Spacer()
                        }

                        HStack {
                            Image(systemName: "phone")
                                .foregroundColor(.blue)
                                .opacity(0.8)
                            if let phoneNumber = parentProfile["phone_number"] as? String {
                                Text(phoneNumber)
                            } else {
                                Text("Phone number not available")
                            }
                            
                            Spacer()
                        }
                        
                        HStack {
                                Image(systemName: "calendar")
                                .foregroundColor(.blue)
                                .opacity(0.8)
                                if let user = parentProfile["user"] as? [String: Any],
                                   let dateJoined = user["date_joined"] as? String {
                                    let formattedDate = formatDate(dateString: dateJoined)
                                    Text(formattedDate)
                                } else {
                                    Text("Date not available")
                                }
                                Spacer()
                            }
                        
                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.blue)
                                .opacity(0.8)
                            Text("Password")
                            Spacer()
                        }

                      
                        Button(action: {
                            playSound(sound: "sound-tap", type: "mp3")
                            feedback.notificationOccurred(.success)
                        }) {
                            Text("Edit Profile")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(LinearGradient(
                                    gradient: Gradient(colors: [Color(red: 0/255, green: 0/255, blue: 50/255),
                                                                Color(red: 0/255, green: 0/255, blue: 150/255)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                         ))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                        .padding(.top)
                    }
                    .padding(.top, -10)
                }
                
               
                .offset(x: isMenuOpen ? 250 : 0)
                .animation(.easeInOut, value: isMenuOpen)
            }

           
            if isMenuOpen {
                
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isMenuOpen.toggle()
                        }
                    }

              
                SideMenuView()
                    .frame(width: 270)
                    .background(Color.gray.opacity(0.9))
                   
                    .offset(x: isMenuOpen ? -80 : -100)
                    .animation(.easeInOut, value: isMenuOpen)
                    

            }
        }
        
        .toolbar {
                   ToolbarItemGroup(placement: .navigationBarLeading) {
                       
                     
                      
                       VStack {
                         
                          
                           Button(action: {
                               withAnimation {
                                   isMenuOpen.toggle()
                               }
                           }) {
                               Image(systemName: "line.horizontal.3")
                                   .font(.title)
                                   .foregroundColor(.white)
                           }
                       }
                   }
               }
        .navigationBarBackButtonHidden(isMenuOpen)
        .onAppear {
                   
                    ParentProfileService.shared.getParentProfile { result in
                        switch result {
                        case .success(let profile):
                            DispatchQueue.main.async {
                                self.parentProfile = profile
                                self.isLoading = false
                            }
                        case .failure(let error):
                            print("Error: \(error.localizedDescription)")
                            self.isLoading = false
                            alertMessage = error.localizedDescription
                            showAlert = true
                        }
                    }
        }
        .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
    }
    
    func formatDate(dateString: String) -> String {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = inputFormatter.date(from: dateString) {
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "dd-MM-yyyy"
                return outputFormatter.string(from: date)
            }
            return "Invalid date"
        }
}
