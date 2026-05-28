import SwiftUI

struct ContentView: View {
  @AppStorage("isConfigured") var isConfigured: Bool = false
  @AppStorage("firstName") var firstName: String = ""
  @AppStorage("lastName") var lastName: String = ""
  @AppStorage("avatarIndex") var avatarIndex: Int = 0
  
  @State private var selectedDowod = false
  @State private var selectedPrawoJazdy = false
  
  var body: some View {
    Group {
      if isConfigured {
        dashboardView
      } else {
        ProfileSetupView()
      }
    }
  }
  
  // Dashboard UI View
  private var dashboardView: some View {
    NavigationView {
      ZStack {
        // System background color
        Color(uiColor: .systemGroupedBackground)
          .ignoresSafeArea()
        
        ScrollView {
          VStack(spacing: 24) {
            
            // Header: Polish flag ribbon
            HStack(spacing: 0) {
              Color.white.frame(height: 5)
              Color.red.frame(height: 5)
            }
            .cornerRadius(2.5)
            .padding(.horizontal)
            
            // Welcome Section with Avatar
            HStack(spacing: 16) {
              VStack(alignment: .leading, spacing: 4) {
                Text("Dzień dobry,")
                  .font(.subheadline)
                  .foregroundColor(.secondary)
                
                Text(firstName)
                  .font(.title.weight(.bold))
                  .foregroundColor(Color(red: 12/255, green: 43/255, blue: 107/255))
              }
              
              Spacer()
              
              // Small Profile Image
              ZStack {
                Circle()
                  .fill(UserProfile.avatarGradients[avatarIndex % UserProfile.avatarGradients.count])
                  .frame(width: 50, height: 50)
                
                Text(UserProfile.avatars[avatarIndex % UserProfile.avatars.count])
                  .font(.system(size: 28))
              }
              .overlay(Circle().stroke(Color.gray.opacity(0.15), lineWidth: 1))
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            // Documents Title
            HStack {
              Text("Dokumenty")
                .font(.headline)
                .foregroundColor(.primary)
              Spacer()
              Text("Wszystkie")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.blue)
            }
            .padding(.horizontal)
            
            // Main Documents Carousel/List
            VStack(spacing: 16) {
              // mDowód Document Card
              Button(action: {
                selectedDowod = true
              }) {
                HStack(spacing: 16) {
                  // Small Photo podgląd
                  ZStack {
                    Circle()
                      .fill(UserProfile.avatarGradients[avatarIndex % UserProfile.avatarGradients.count])
                      .frame(width: 54, height: 54)
                    
                    Text(UserProfile.avatars[avatarIndex % UserProfile.avatars.count])
                      .font(.system(size: 30))
                  }
                  .overlay(Circle().stroke(Color.white.opacity(0.5), lineWidth: 1))
                  
                  VStack(alignment: .leading, spacing: 4) {
                    Text("mDowód")
                      .font(.headline)
                      .foregroundColor(.white)
                    
                    Text("\(firstName) \(lastName)")
                      .font(.subheadline)
                      .foregroundColor(.white.opacity(0.85))
                      .lineLimit(1)
                  }
                  
                  Spacer()
                  
                  Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.7))
                    .font(.headline)
                }
                .padding()
                .background(
                  LinearGradient(
                    gradient: Gradient(colors: [
                      Color(red: 180/255, green: 20/255, blue: 30/255),
                      Color(red: 230/255, green: 50/255, blue: 60/255)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                  )
                )
                .cornerRadius(18)
                .shadow(color: Color.red.opacity(0.15), radius: 8, x: 0, y: 4)
              }
              .sheet(isPresented: $selectedDowod) {
                mDowodDetailView()
              }
              
              // mPrawo Jazdy Document Card
              Button(action: {
                selectedPrawoJazdy = true
              }) {
                HStack(spacing: 16) {
                  // Small Photo podgląd
                  ZStack {
                    Circle()
                      .fill(UserProfile.avatarGradients[avatarIndex % UserProfile.avatarGradients.count])
                      .frame(width: 54, height: 54)
                    
                    Text(UserProfile.avatars[avatarIndex % UserProfile.avatars.count])
                      .font(.system(size: 30))
                  }
                  .overlay(Circle().stroke(Color.white.opacity(0.5), lineWidth: 1))
                  
                  VStack(alignment: .leading, spacing: 4) {
                    Text("mPrawo jazdy")
                      .font(.headline)
                      .foregroundColor(.white)
                    
                    Text("Kategoria AM, B1, B")
                      .font(.subheadline)
                      .foregroundColor(.white.opacity(0.85))
                  }
                  
                  Spacer()
                  
                  Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.7))
                    .font(.headline)
                }
                .padding()
                .background(
                  LinearGradient(
                    gradient: Gradient(colors: [
                      Color(red: 35/255, green: 79/255, blue: 153/255),
                      Color(red: 60/255, green: 110/255, blue: 190/255)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                  )
                )
                .cornerRadius(18)
                .shadow(color: Color.blue.opacity(0.15), radius: 8, x: 0, y: 4)
              }
              .sheet(isPresented: $selectedPrawoJazdy) {
                mPrawoJazdyDetailView()
              }
            }
            .padding(.horizontal)
            
            // Services Title
            HStack {
              Text("Usługi")
                .font(.headline)
                .foregroundColor(.primary)
              Spacer()
            }
            .padding(.horizontal)
            
            // Grid of Services
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
              serviceCell(iconName: "car.2.fill", label: "Historia pojazdu", color: .purple)
              serviceCell(iconName: "exclamationmark.triangle.fill", label: "Punkty karne", color: .orange, badge: "0 pkt")
              serviceCell(iconName: "wind", label: "Jakość powietrza", color: .green)
              serviceCell(iconName: "globe", label: "Polak za granicą", color: .blue)
              serviceCell(iconName: "heart.text.square.fill", label: "E-recepta", color: .pink)
              serviceCell(iconName: "doc.text.fill", label: "Zgłoś naruszenie", color: .cyan)
            }
            .padding(.horizontal)
            
            // Bottom banner / app promo
            VStack(spacing: 8) {
              HStack {
                Image(systemName: "info.circle.fill")
                  .foregroundColor(.blue)
                  .font(.title2)
                Text("Bezpieczeństwo to priorytet")
                  .font(.headline)
                Spacer()
              }
              Text("Twoje dane są w pełni szyfrowane i zabezpieczone na tym urządzeniu zgodnie z normami bezpieczeństwa CSIRT.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .cornerRadius(16)
            .padding(.horizontal)
            .padding(.bottom, 24)
          }
        }
      }
      .navigationBarTitle("mObywatel", displayMode: .inline)
      .navigationBarItems(leading: Image(systemName: "line.3.horizontal")
        .foregroundColor(Color(red: 12/255, green: 43/255, blue: 107/255)),
        trailing: Image(systemName: "bell.fill")
          .foregroundColor(Color(red: 12/255, green: 43/255, blue: 107/255))
      )
    }
    .navigationViewStyle(.stack)
  }
  
  // Custom cell for the services grid
  @ViewBuilder
  private func serviceCell(iconName: String, label: String, color: Color, badge: String? = nil) -> some View {
    VStack(spacing: 12) {
      ZStack(alignment: .topTrailing) {
        // Icon background bubble
        RoundedRectangle(cornerRadius: 14)
          .fill(color.opacity(0.12))
          .frame(width: 50, height: 50)
          .overlay(
            Image(systemName: iconName)
              .font(.title3)
              .foregroundColor(color)
          )
        
        if let badge {
          Text(badge)
            .font(.system(size: 8, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .background(Color.red)
            .clipShape(Capsule())
            .offset(x: 10, y: -6)
        }
      }
      
      Text(label)
        .font(.caption.weight(.medium))
        .foregroundColor(.primary)
        .multilineTextAlignment(.center)
        .lineLimit(2)
        .frame(height: 32)
    }
    .padding(.vertical, 12)
    .padding(.horizontal, 6)
    .frame(maxWidth: .infinity)
    .background(Color(uiColor: .secondarySystemGroupedBackground))
    .cornerRadius(16)
    .shadow(color: Color.black.opacity(0.02), radius: 3, x: 0, y: 1)
  }
}
