import SwiftUI

struct mPrawoJazdyDetailView: View {
  @Environment(\.presentationMode) var presentationMode
  
  @AppStorage("firstName") var firstName: String = ""
  @AppStorage("lastName") var lastName: String = ""
  @AppStorage("avatarIndex") var avatarIndex: Int = 0
  @AppStorage("birthDateString") var birthDateString: String = ""
  @AppStorage("driverLicenseNumber") var driverLicenseNumber: String = ""
  
  var body: some View {
    ZStack {
      Color(uiColor: .systemGroupedBackground)
        .ignoresSafeArea()
      
      VStack(spacing: 0) {
        headerView
        
        ScrollView {
          VStack(spacing: 16) {
            documentStatusView
            licenseCardView
            categoriesListView
          }
        }
      }
    }
    .navigationBarHidden(true)
  }

  // MARK: - Subviews
  
  private var headerView: some View {
    VStack(spacing: 0) {
      // Driver License Blue Header
      HStack {
        Button(action: {
          presentationMode.wrappedValue.dismiss()
        }) {
          Image(systemName: "chevron.left")
            .font(.title3.weight(.bold))
            .foregroundColor(.white)
        }
        
        Spacer()
        
        Text("mPrawo jazdy")
          .font(.headline)
          .foregroundColor(.white)
        
        Spacer()
        
        // EU PL Flag
        ZStack {
          RoundedRectangle(cornerRadius: 3)
            .fill(Color.blue)
            .frame(width: 28, height: 18)
          Text("PL")
            .font(.system(size: 9, weight: .bold))
            .foregroundColor(.white)
        }
      }
      .padding(.horizontal)
      .padding(.bottom, 12)
      .padding(.top, 10)
      .background(Color(red: 35/255, green: 79/255, blue: 153/255))
      
      // Ribbon separator
      Color.blue.frame(height: 4)
    }
  }

  private var documentStatusView: some View {
    // Valid Document Status Badge
    HStack {
      Image(systemName: "checkmark.shield.fill")
        .foregroundColor(.green)
        .font(.title2)
      
      VStack(alignment: .leading, spacing: 2) {
        Text("Uprawnienia aktywne")
          .font(.headline)
          .foregroundColor(.primary)
        Text("Dane z Centralnej Ewidencji Kierowców")
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
  }

  private var licenseHeader: some View {
    HStack {
      Text("PRAWO JAZDY")
        .font(.system(size: 14, weight: .bold))
        .foregroundColor(Color(red: 35/255, green: 79/255, blue: 153/255))
      Spacer()
      Text("RZECZPOSPOLITA POLSKA")
        .font(.caption2.weight(.semibold))
        .foregroundColor(.secondary)
    }
    .padding(.bottom, 6)
  }

  private var licensePhoto: some View {
    VStack(spacing: 4) {
      ZStack {
        Circle()
          .fill(UserProfile.avatarGradients[avatarIndex % UserProfile.avatarGradients.count])
          .frame(width: 90, height: 90)
        
        Text(UserProfile.avatars[avatarIndex % UserProfile.avatars.count])
          .font(.system(size: 50))
          .frame(width: 90, height: 90)
      }
      .overlay(
        RoundedRectangle(cornerRadius: 45)
          .stroke(Color.blue.opacity(0.2), lineWidth: 1.5)
      )
      
      Text("PL")
        .font(.caption.weight(.bold))
        .foregroundColor(Color(red: 35/255, green: 79/255, blue: 153/255))
    }
  }

  private var licenseDetails: some View {
    VStack(alignment: .leading, spacing: 8) {
      detailItem(label: "1. Nazwisko", value: lastName.uppercased(), isBold: true)
      detailItem(label: "2. Imię (imiona)", value: firstName.uppercased(), isBold: true)
      detailItem(label: "3. Data i miejsce urodzenia", value: "\(birthDateString), WARSZAWA")
      detailItem(label: "4d. PESEL", value: "94081512345") // Simulated matching or default
      detailItem(label: "5. Numer prawa jazdy", value: driverLicenseNumber)
    }
  }

  private var licenseFooter: some View {
    VStack(spacing: 0) {
      Divider()
        .padding(.vertical, 2)
      
      HStack {
        detailItem(label: "9. Kategoria uprawnień", value: "AM, B1, B", isBold: true)
        Spacer()
        detailItem(label: "4a. Data wydania", value: "28.05.2020")
      }
    }
  }

  private var licenseCardView: some View {
    // Driver License Card mockup (Pinkish-Blue gradient)
    VStack(spacing: 14) {
      licenseHeader
      
      HStack(alignment: .top, spacing: 16) {
        licensePhoto
        licenseDetails
      }
      
      licenseFooter
    }
    .padding(18)
    .background(
      ZStack {
        // Pinkish/blue driver's license aesthetic gradient
        LinearGradient(
          gradient: Gradient(colors: [
            Color(red: 255/255, green: 220/255, blue: 230/255),
            Color(red: 220/255, green: 235/255, blue: 255/255)
          ]),
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        )
      }
    )
    .cornerRadius(20)
    .overlay(
      RoundedRectangle(cornerRadius: 20)
        .stroke(Color.blue.opacity(0.15), lineWidth: 1)
    )
    .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
    .padding(.horizontal)
  }

  private var categoriesListView: some View {
    // Categories detailed list
    VStack(alignment: .leading, spacing: 12) {
      Text("Kategorie i Uprawnienia")
        .font(.headline)
        .foregroundColor(Color(red: 35/255, green: 79/255, blue: 153/255))
        .padding(.bottom, 4)
      
      categoryRow(category: "B", desc: "Samochody osobowe", dateIssued: "28.05.2020", dateExpiry: "28.05.2035", active: true)
      categoryRow(category: "B1", desc: "Czterokołowce lekkie", dateIssued: "28.05.2020", dateExpiry: "28.05.2035", active: true)
      categoryRow(category: "AM", desc: "Motorowery i czterokołowce", dateIssued: "28.05.2020", dateExpiry: "28.05.2035", active: true)
      categoryRow(category: "A", desc: "Motocykle", dateIssued: "—", dateExpiry: "—", active: false)
    }
    .padding()
    .background(Color(uiColor: .secondarySystemGroupedBackground))
    .cornerRadius(16)
    .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 2)
    .padding(.horizontal)
    .padding(.bottom, 32)
  }
  
  private func detailItem(label: String, value: String, isBold: Bool = false) -> some View {
    VStack(alignment: .leading, spacing: 1) {
      Text(label)
        .font(.system(size: 8, weight: .bold))
        .foregroundColor(.secondary)
      Text(value)
        .font(.system(size: 13, weight: isBold ? .bold : .semibold))
        .foregroundColor(.primary)
    }
  }
  
  private func categoryRow(category: String, desc: String, dateIssued: String, dateExpiry: String, active: Bool) -> some View {
    HStack(spacing: 12) {
      // Category bubble
      Text(category)
        .font(.headline)
        .bold()
        .foregroundColor(active ? .white : .secondary)
        .frame(width: 44, height: 44)
        .background(active ? Color(red: 35/255, green: 79/255, blue: 153/255) : Color.gray.opacity(0.15))
        .cornerRadius(10)
      
      VStack(alignment: .leading, spacing: 2) {
        Text(desc)
          .font(.subheadline.weight(.semibold))
          .foregroundColor(active ? .primary : .secondary)
        
        HStack(spacing: 8) {
          Text("Wydano: \(dateIssued)")
          Text("•")
          Text("Ważne do: \(dateExpiry)")
        }
        .font(.caption)
        .foregroundColor(.secondary)
      }
      
      Spacer()
      
      if active {
        Image(systemName: "checkmark.circle.fill")
          .foregroundColor(.green)
      }
    }
    .padding(.vertical, 4)
  }
}
