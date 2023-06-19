//created by jeon 23.03.19

import SwiftUI
import Foundation
import Combine

class UserManager: ObservableObject {
    @Published var users: [user] = [user(name: "관리자", birthDate: Date(), id: "Admin", password: "aa1234!", isVaccinated: true)]
    
    init() {
           loadUsers()
       }
       
       // 사용자 추가
       func addUser(name: String, birthDate: Date, id: String, password: String, isVaccinated: Bool) {
           let user = user(name: name, birthDate: birthDate, id: id, password: password, isVaccinated: isVaccinated)
           users.append(user)
           saveUsers()
       }
       
       // 사용자 삭제
       func deleteUser(_ user: user) {
           if let index = users.firstIndex(where: { $0.id == user.id }) {
               users.remove(at: index)
               saveUsers()
           }
       }
       
       // 사용자 업데이트
       func updateUser(_ user: user) {
           if let index = users.firstIndex(where: { $0.id == user.id }) {
               users[index] = user
               saveUsers()
           }
       }
       
       // 사용자 저장
       private func saveUsers() {
           do {
               let data = try JSONEncoder().encode(users)
               UserDefaults.standard.set(data, forKey: "Users")
           } catch {
               print("Failed to save users: \(error)")
           }
       }
       
       // 사용자 로드
       private func loadUsers() {
           if let data = UserDefaults.standard.data(forKey: "Users") {
               do {
                   users = try JSONDecoder().decode([user].self, from: data)
               } catch {
                   print("Failed to load users: \(error)")
               }
           }
       }
   }
