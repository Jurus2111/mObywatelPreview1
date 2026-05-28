import SwiftUI

struct mDowodDetailView: View {
  @Environment(\.presentationMode) var presentationMode
  
  @AppStorage("firstName") var firstName: String = ""
  @AppStorage("lastName") var lastName: String = ""
  @AppStorage("fathersName") var fathersName: String = ""
  @AppStorage("mothersName") var mothersName: String = ""
  @AppStorage("avatarIndex") var avatarIndex: Int = 0
  @AppStorage("birthDateString") var birthDateString: String = ""
  @AppStorage("pesel") var pesel: String = ""
  @AppStorage("documentNumber") var documentNumber: String = ""
  
  @State private var qrCountdown = 30
  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  
  var body: some View {
    ZStack {
      Color(uiColor: .systemGroupedBackground)
        .ignoresSafeArea()
      
      VStack(spacing: 0) {
        // Official Deep Blue Navigation Bar Header
        HStack {
          Button(action: {
            presentationMode.wrappedValue.dismiss()
          }) {
            Image(systemName: "chevron.left")
              .font(.title3.weight(.bold))
              .foregroundColor(.white)
          }
          
          Spacer()
          
          Text("mDowód")
            .font(.headline)
            .foregroundColor(.white)
          
          Spacer()
          
          // Small Polish Eagle emblem placeholder
          Image(systemName: "crown.fill")
            .foregroundColor(.yellow)
            .font(.title3)
        }
        .padding(.horizontal)
        .padding(.bottom, 12)
        .padding(.top, 10)
        .background(Color(red: 12/255, green: 43/255, blue: 107/255))
        
        // Polish Flag Ribbon under Header
        HStack(spacing: 0) {
          Color.white.frame(height: 4)
          Color.red.frame(height: 4)
        }
        
        ScrollView {
          VStack(spacing: 16) {
            
            // Valid Document Status Badge
            HStack {
              Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.title2)
              
              VStack(alignment: .leading, spacing: 2) {
                Text("Dokument ważny")
                  .font(.headline)
                  .foregroundColor(.primary)
                Text("Dane z Rejestru Dowodów Osobistych")
                  .font(.caption)
                  .foregroundColor(.secondary)
              }
              Spacer()
            }
            .padding()
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 2)
            .padding(.horizontal)
            .padding(.top, 16)
            
            // The mDowód ID Card representation
            VStack(spacing: 16) {
              // Top Flag and Country Name
              HStack {
                VStack(alignment: .leading, spacing: 2) {
                  Text("RZECZPOSPOLITA POLSKA")
                    .font(.caption.weight(.bold))
                    .foregroundColor(Color(red: 12/255, green: 43/255, blue: 107/255))
                  Text("DOWÓD OSOBISTY")
                    .font(.system(size: 10).weight(.medium))
                    .foregroundColor(.secondary)
                }
                Spacer()
                
                // EU Flag with PL inside
                ZStack {
                  RoundedRectangle(cornerRadius: 3)
                    .fill(Color.blue)
                    .frame(width: 28, height: 18)
                  Text("PL")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                }
              }
              .padding(.bottom, 8)
              
              HStack(alignment: .top, spacing: 16) {
                // Photo Area
                VStack(spacing: 8) {
                  ZStack(alignment: .bottomTrailing) {
                    Circle()
                      .fill(UserProfile.avatarGradients[avatarIndex % UserProfile.avatarGradients.count])
                      .frame(width: 100, height: 100)
                    
                    Text(UserProfile.avatars[avatarIndex % UserProfile.avatars.count])
                      .font(.system(size: 55))
                      .frame(width: 100, height: 100)
                    
                    // Small Polish Flag Ribbon overlaying the photo
                    HStack(spacing: 0) {
                      Color.white.frame(width: 16, height: 8)
                      Color.red.frame(width: 16, height: 8)
                    }
                    .cornerRadius(1)
                    .padding([.bottom, .right], 4)
                  }
                  .overlay(
                    RoundedRectangle(cornerRadius: 50)
                      .stroke(Color.gray.opacity(0.2), lineWidth: 1.5)
                  )
                  
                  Text("POL")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.secondary)
                }
                
                // Text details
                VStack(alignment: .leading, spacing: 10) {
                  detailItem(label: "Nazwisko", value: lastName.uppercased(), isBold: true)
                  detailItem(label: "Imię (imiona)", value: firstName.uppercased(), isBold: true)
                  detailItem(label: "Obywatelstwo", value: "POLSKIE")
                  detailItem(label: "Data urodzenia", value: birthDateString)
                  detailItem(label: "PESEL", value: pesel)
                }
              }
              
              Divider()
                .padding(.vertical, 4)
              
              // Expiry details
              HStack {
                detailItem(label: "Numer dokumentu", value: documentNumber)
                Spacer()
                detailItem(label: "Termin ważności", value: "28.05.2036") // 10 years expiry
              }
            }
            .padding(18)
            .background(
              // Hologram pattern / gradient background for premium look
              ZStack {
                Color(uiColor: .secondarySystemGroupedBackground)
                
                // Subtle soft pink/cyan radial gradient for security hologram effect
                RadialGradient(colors: [Color.red.opacity(0.04), Color.blue.opacity(0.03), Color.clear], center: .center, startRadius: 10, endRadius: 200)
              }
            )
            .cornerRadius(20)
            .overlay(
              RoundedRectangle(cornerRadius: 20)
                .stroke(Color.red.opacity(0.15), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
            .padding(.horizontal)
            
            // Dynamic Verification QR Code Card
            VStack(spacing: 12) {
              Text("KOD WERYFIKACYJNY")
                .font(.caption.weight(.semibold))
                .foregroundColor(.secondary)
              
              // Simulated QR code
              ZStack {
                RoundedRectangle(cornerRadius: 12)
                  .fill(Color.white)
                  .frame(width: 140, height: 140)
                  .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                
                // Draw a mock QR code pattern using system icons or custom shape
                Image(systemName: "qrcode")
                  .resizable()
                  .foregroundColor(Color(red: 12/255, green: 43/255, blue: 107/255))
                  .frame(width: 110, height: 110)
              }
              
              // Counter
              HStack(spacing: 6) {
                Image(systemName: "arrow.triangle.2.circlepath")
                  .font(.caption)
                  .foregroundColor(.blue)
                
                Text("Kod odświeży się za \(qrCountdown) s")
                  .font(.caption.weight(.medium))
                  .foregroundColor(.secondary)
              }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 2)
            .padding(.horizontal)
            .onReceive(timer) { _ in
              if qrCountdown > 1 {
                qrCountdown -= 1
              } else {
                qrCountdown = 30 // Reset every 30s
              }
            }
            
            // Extended details section (Parents' names, etc.)
            VStack(alignment: .leading, spacing: 16) {
              Text("Dane Szczegółowe")
                .font(.headline)
                .foregroundColor(Color(red: 12/255, green: 43/255, blue: 107/255))
                .padding(.bottom, 4)
              
              detailItemHorizontal(label: "Imię ojca", value: fathersName)
              detailItemHorizontal(label: "Imię matki", value: mothersName)
              detailItemHorizontal(label: "Płeć", value: guessGender(firstName: firstName))
              detailItemHorizontal(label: "Miejsce urodzenia", value: "WARSZAWA")
              detailItemHorizontal(label: "Kraj urodzenia", value: "POLSKA")
            }
            .padding()
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 2)
            .padding(.horizontal)
            .padding(.bottom, 32)
          }
        }
      }
    }
    .navigationBarHidden(true)
  }
  
  // Vertical label/value pair
  private func detailItem(label: String, value: String, isBold: Bool = false) -> some View {
    VStack(alignment: .leading, spacing: 1) {
      Text(label.uppercased())
        .font(.system(size: 8, weight: .bold))
        .foregroundColor(.secondary)
      Text(value)
        .font(.system(size: 13, weight: isBold ? .bold : .semibold))
        .foregroundColor(.primary)
    }
  }
  
  // Horizontal details for bottom card
  private func detailItemHorizontal(label: String, value: String) -> some View {
    HStack {
      Text(label)
        .foregroundColor(.secondary)
        .font(.subheadline)
      Spacer()
      Text(value)
        .fontWeight(.semibold)
        .foregroundColor(.primary)
        .font(.subheadline)
    }
    .padding(.vertical, 2)
  }
  
  // Simple heuristic to guess gender from polish first name (typically ends in 'a' for female)
  private func guessGender(firstName: String) -> String {
    let name = firstName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    if name.isEmpty { return "Nieznana" }
    
    // Most Polish female names end with 'a'
    if name.hasSuffix("a") {
      return "Kobieta"
    } else {
      return "Mężczyzna"
    }
  }
}
