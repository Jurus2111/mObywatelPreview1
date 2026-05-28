import Foundation
import SwiftUI

public struct UserProfile {
  public static let avatars = [
    "👨‍💼", // Avatar 1
    "👩‍💼", // Avatar 2
    "🧑‍💻", // Avatar 3
    "👤"   // Avatar 4 (Domyślny)
  ]
  
  public static let avatarGradients: [LinearGradient] = [
    LinearGradient(colors: [Color.blue, Color.cyan], startPoint: .topLeading, endPoint: .bottomTrailing),
    LinearGradient(colors: [Color.purple, Color.pink], startPoint: .topLeading, endPoint: .bottomTrailing),
    LinearGradient(colors: [Color.orange, Color.yellow], startPoint: .topLeading, endPoint: .bottomTrailing),
    LinearGradient(colors: [Color.gray, Color(white: 0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
  ]
  
  public static func generateRandomPesel(from birthDate: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyMMdd"
    let datePart = formatter.string(from: birthDate)
    
    // Generate 5 random digits for the rest of the PESEL
    var randomDigits = ""
    for _ in 0..<5 {
      randomDigits += String(Int.random(in: 0...9))
    }
    
    return "\(datePart)\(randomDigits)"
  }
  
  public static func generateRandomDocumentNumber() -> String {
    let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    var documentNo = ""
    
    // 3 random letters
    for _ in 0..<3 {
      if let randomLetter = letters.randomElement() {
        documentNo.append(randomLetter)
      }
    }
    
    // 6 random digits
    for _ in 0..<6 {
      documentNo.append(String(Int.random(in: 0...9)))
    }
    
    return documentNo
  }
  
  public static func generateRandomDriverLicenseNumber() -> String {
    var dlNo = ""
    // Format: 12345/67/8901
    for _ in 0..<5 {
      dlNo.append(String(Int.random(in: 0...9)))
    }
    dlNo.append("/")
    for _ in 0..<2 {
      dlNo.append(String(Int.random(in: 0...9)))
    }
    dlNo.append("/")
    for _ in 0..<4 {
      dlNo.append(String(Int.random(in: 0...9)))
    }
    return dlNo
  }
}
