//Created by jeon 23.03.19

import Foundation

struct user: Identifiable,Encodable,Decodable {
    let number = UUID()
    let name: String            //유저 이름
    let birthDate: Date
    let id: String              //유저 아이디
    let password: String
    let isVaccinated: Bool
}

class UsersStore: ObservableObject {
    @Published var users: [user] = []
}
