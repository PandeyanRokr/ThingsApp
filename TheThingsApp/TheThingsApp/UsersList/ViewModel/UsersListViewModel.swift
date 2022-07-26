//
//  UsersListViewModel.swift
//  TheThingsApp
//
//  Created by Pandeyan Rokr on 2022-07-27.
//

import UIKit
import Combine

protocol UsersListViewModelProtocol: AnyObject {
    var networkController: NetworkControllerProtocol { get }
    func getUsersList()
}

class UsersListViewModel: NSObject, UsersListViewModelProtocol {
    
    var usersList = [User]()
    var usersListSubject = PassthroughSubject<Bool,Error>()
    private var cancellables = Set<AnyCancellable>()
    var selectedUsersList = [User]()
    
    let networkController: NetworkControllerProtocol
    
    //MARK: - Initializer
    init(networkController: NetworkControllerProtocol) {
        self.networkController = networkController
    }
    
    //MARK: - Get Users List
    func getUsersList() {
        
        networkController.getArrayOfData(type: User.self, url: Server.UsersList.url(), requestType: .GET, headers: [:], params: [:])
            .receive(on: RunLoop.main)
            .sink { [unowned self] completion in
                switch completion {
                case .failure(let error):
                    debugLog(error.localizedDescription)
                    self.usersListSubject.send(completion: .failure(error))
                case .finished:
                    debugLog("Finished")
                }
            }
            receiveValue:{ [unowned self] arrUser in
                self.usersList = arrUser
                self.usersListSubject.send(true)
                self.usersListSubject.send(completion: .finished)
            }
    .store(in: &cancellables)
    }
    
    //MARK: - Add User
    func addUser(user: User) {
        let isSelected = user.isSelected
        if isSelected {
            selectedUsersList.append(user)
        } else {
            if let indexValue = selectedUsersList.firstIndex(where: { $0.id == user.id }), indexValue <= (selectedUsersList.count - 1) {
                selectedUsersList.remove(at: indexValue)
            }
        }
    }
    
    //MARK: - Insert New User
    func insertNewUser(_ user: User) {
        self.usersList.insert(user, at: 0)
    }
    
    //MARK: - Reset Selected User List
    func resetUserListSelected() {
        self.selectedUsersList.removeAll()
        self.usersList.mapProperty(\.isSelected, false)
    }
    
}
