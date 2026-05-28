import SwiftUI

struct ProfileSetupView: View {
  @AppStorage("firstName") var firstName: String = ""
  @AppStorage("lastName") var lastName: String = ""
  @AppStorage("fathersName") var fathersName: String = ""
  @AppStorage("mothersName") var mothersName: String = ""
  @AppStorage("avatarIndex") var avatarIndex: Int = 0
  @AppStorage("birthDateString") var birthDateString: String = ""
  @AppStorage("pesel") var pesel: String = ""
  @AppStorage("documentNumber") var documentNumber: String = ""
  @AppStorage("driverLicenseNumber") var driverLicenseNumber: String = ""
  @AppStorage("isConfigured") var isConfigured: Bool = false
  
  @State private var birthDate = Date()
  @State private var showingAvatarPicker = false
  @State private var showingSimulatedGalleryAlert = false
  
  // Basic validation state
  private var isFormValid: Bool {
    !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
    !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
    !fathersName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
    !mothersName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }
  
  var body: some View {
    NavigationView {
      ZStack {
        // Light background resembling iOS system background
        Color(uiColor: .systemGroupedBackground)
          .ignoresSafeArea()
        
        ScrollView {
          VStack(spacing: 24) {
            // Polish Flag Decorative Ribbon at the top
            HStack(spacing: 0) {
              Color.white.frame(height: 6)
              Color.red.frame(height: 6)
            }
            .frame(maxWidth: .infinity)
            .cornerRadius(3)
            .padding(.horizontal)
            
            // Header Info
            VStack(spacing: 8) {
              Text("Aktywacja Tożsamości")
                .font(.title2)
                .bold()
                .foregroundColor(Color(red: 12/255, green: 43/255, blue: 107/255))
              
              Text("Wprowadź dane osobowe, aby wygenerować dokumenty w aplikacji mObywatel.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            }
            .padding(.top, 8)
            
            // Avatar Selector Card
            VStack(spacing: 12) {
              ZStack(alignment: .bottomTrailing) {
                Circle()
                  .fill(UserProfile.avatarGradients[avatarIndex % UserProfile.avatarGradients.count])
                  .frame(width: 100, height: 100)
                  .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                
                Text(UserProfile.avatars[avatarIndex % UserProfile.avatars.count])
                  .font(.system(size: 55))
                  .frame(width: 100, height: 100)
                
                Button(action: {
                  showingAvatarPicker = true
                }) {
                  Image(systemName: "camera.fill")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color(red: 12/255, green: 43/255, blue: 107/255))
                    .clipShape(Circle())
                    .overlay(
                      Circle().stroke(Color.white, lineWidth: 2)
                    )
                }
              }
              
              Text("Wybierz lub dodaj zdjęcie")
                .font(.footnote.weight(.medium))
                .foregroundColor(.secondary)
            }
            
            // Input Fields Section
            VStack(spacing: 16) {
              customTextField(label: "Imię", text: $firstName, placeholder: "np. Jan")
              customTextField(label: "Nazwisko", text: $lastName, placeholder: "np. Kowalski")
              customTextField(label: "Imię ojca", text: $fathersName, placeholder: "np. Józef")
              customTextField(label: "Imię matki", text: $mothersName, placeholder: "np. Maria")
              
              // Date of Birth DatePicker Styled Neatly
              VStack(alignment: .leading, spacing: 6) {
                Text("Data urodzenia")
                  .font(.caption.weight(.semibold))
                  .foregroundColor(.secondary)
                  .frame(maxWidth: .infinity, alignment: .leading)
                
                DatePicker("", selection: $birthDate, displayedComponents: .date)
                  .labelsHidden()
                  .datePickerStyle(.wheel)
                  .frame(height: 120)
                  .frame(maxWidth: .infinity)
                  .background(Color(uiColor: .secondarySystemGroupedBackground))
                  .cornerRadius(12)
              }
              .padding(.horizontal, 4)
            }
            .padding(.horizontal)
            
            // Submit Button
            Button(action: {
              if isFormValid {
                // Generate other values automatically and randomly
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                birthDateString = dateFormatter.string(from: birthDate)
                
                pesel = UserProfile.generateRandomPesel(from: birthDate)
                documentNumber = UserProfile.generateRandomDocumentNumber()
                driverLicenseNumber = UserProfile.generateRandomDriverLicenseNumber()
                
                // Animate entry to app
                withAnimation(.spring()) {
                  isConfigured = true
                }
              }
            }) {
              HStack {
                Text("Aktywuj aplikację")
                  .font(.headline)
                  .foregroundColor(.white)
                Image(systemName: "checkmark.seal.fill")
                  .foregroundColor(.white)
              }
              .frame(maxWidth: .infinity)
              .frame(height: 54)
              .background(isFormValid ? Color(red: 12/255, green: 43/255, blue: 107/255) : Color.gray.opacity(0.4))
              .cornerRadius(14)
              .shadow(color: isFormValid ? Color(red: 12/255, green: 43/255, blue: 107/255).opacity(0.3) : Color.clear, radius: 8, x: 0, y: 4)
            }
            .disabled(!isFormValid)
            .padding(.horizontal)
            .padding(.bottom, 32)
          }
        }
      }
      .navigationBarTitle("Logowanie", displayMode: .inline)
      .sheet(isPresented: $showingAvatarPicker) {
        avatarSelectionSheet
      }
      .alert("Symulacja galerii", isPresented: $showingSimulatedGalleryAlert) {
        Button("OK", role: .cancel) { }
      } message: {
        Text("Z powodzeniem zaimportowano i zoptymalizowano wybrane zdjęcie z Twojego urządzenia (Symulacja).")
      }
    }
    .navigationViewStyle(.stack)
  }
  
  // Custom styled Text Field
  @ViewBuilder
  private func customTextField(label: String, text: Binding<String>, placeholder: String) -> some View {
    VStack(alignment: .leading, spacing: 6) {
      Text(label)
        .font(.caption.weight(.semibold))
        .foregroundColor(.secondary)
      
      HStack {
        TextField(placeholder, text: text)
          .autocorrectionDisabled()
          .textInputAutocapitalization(.words)
          .font(.body)
        
        if !text.wrappedValue.isEmpty {
          Button(action: {
            text.wrappedValue = ""
          }) {
            Image(systemName: "xmark.circle.fill")
              .foregroundColor(.secondary)
          }
        }
      }
      .padding()
      .frame(height: 52)
      .background(Color(uiColor: .secondarySystemGroupedBackground))
      .cornerRadius(12)
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .stroke(text.wrappedValue.isEmpty ? Color.clear : Color.green.opacity(0.3), lineWidth: 1.5)
      )
    }
    .padding(.horizontal, 4)
  }
  
  // Sheet layout for choosing avatar
  private var avatarSelectionSheet: some View {
    NavigationView {
      VStack(spacing: 24) {
        Text("Wybierz zdjęcie tożsamości")
          .font(.headline)
          .padding(.top)
        
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2), spacing: 20) {
          ForEach(0..<UserProfile.avatars.count, id: \.self) { index in
            Button(action: {
              avatarIndex = index
              showingAvatarPicker = false
            }) {
              VStack(spacing: 12) {
                ZStack {
                  Circle()
                    .fill(UserProfile.avatarGradients[index])
                    .frame(width: 80, height: 80)
                  
                  Text(UserProfile.avatars[index])
                    .font(.system(size: 45))
                }
                .overlay(
                  Circle()
                    .stroke(avatarIndex == index ? Color(red: 12/255, green: 43/255, blue: 107/255) : Color.clear, lineWidth: 3)
                )
                
                Text(index == 3 ? "Domyślne" : "Zdjęcie \(index + 1)")
                  .font(.caption)
                  .bold()
                  .foregroundColor(avatarIndex == index ? Color(red: 12/255, green: 43/255, blue: 107/255) : .secondary)
              }
              .padding()
              .frame(maxWidth: .infinity)
              .background(Color(uiColor: .secondarySystemGroupedBackground))
              .cornerRadius(16)
              .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            }
          }
        }
        .padding(.horizontal)
        
        Divider()
          .padding(.vertical, 8)
        
        // Mock Photo / Camera Buttons
        VStack(spacing: 12) {
          Button(action: {
            // Mock taking a photo
            avatarIndex = 0 // Assign male professional avatar
            showingAvatarPicker = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
              showingSimulatedGalleryAlert = true
            }
          }) {
            HStack {
              Image(systemName: "camera.fill")
              Text("Zrób nowe zdjęcie aparatem")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(uiColor: .systemBackground))
            .cornerRadius(12)
            .foregroundColor(Color(red: 12/255, green: 43/255, blue: 107/255))
            .overlay(
              RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
          }
          
          Button(action: {
            // Mock choosing photo from gallery
            avatarIndex = 1 // Assign female professional avatar
            showingAvatarPicker = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
              showingSimulatedGalleryAlert = true
            }
          }) {
            HStack {
              Image(systemName: "photo.on.rectangle.angled")
              Text("Wgraj zdjęcie z biblioteki")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(uiColor: .systemBackground))
            .cornerRadius(12)
            .foregroundColor(Color(red: 12/255, green: 43/255, blue: 107/255))
            .overlay(
              RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
          }
        }
        .padding(.horizontal)
        .padding(.bottom, 24)
        
        Spacer()
      }
      .background(Color(uiColor: .systemGroupedBackground))
      .navigationBarItems(trailing: Button("Anuluj") {
        showingAvatarPicker = false
      })
    }
  }
}
