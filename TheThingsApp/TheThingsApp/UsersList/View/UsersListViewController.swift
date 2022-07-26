//
//  UsersListViewController.swift
//  TheThingsApp
//
//  Created by Pandeyan Rokr on 2022-07-27.
//

import UIKit
import Combine

class UsersListViewController: UIViewController {
    
    @IBOutlet weak var tableUserList: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var userListViewModel = UsersListViewModel(networkController: NetworkController())
    var dictColorCode = [Int: CGFloat]()
    var subscriptions = Set<AnyCancellable>()
    var dictColor = [Int: TupleRGB]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableUserList.register(UINib(nibName: Constants.NibName.UserTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.CellIdentifier.UserTableViewCell)
        self.setupObservers()
        self.startLoader()
        userListViewModel.getUsersList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !(self.userListViewModel.usersList.isEmpty) {
            self.userListViewModel.resetUserListSelected()
            self.tableUserList.reloadData()
        }
    }
    
    //MARK: - Start Loader
    private func startLoader() {
        self.activityIndicator.startAnimating()
    }
    
    private func stopLoader() {
        self.activityIndicator.stopAnimating()
    }
    
    //MARK: - Setup Observers
    func setupObservers() {
        
        userListViewModel.usersListSubject.sink { [weak self] completion in
            switch completion {
            case .finished:
                print("Received finished")
            case .failure(let error):
                print("Received error: \(error)")
                self?.throwAlert(title: nil, msg: error.localizedDescription)
            }
        } receiveValue: { [weak self] isSuccess in
            debugLog("Received data isSuccess: \(isSuccess)")
            DispatchQueue.main.async {
                self?.stopLoader()
                 self?.tableUserList.reloadData()
            }
        }
        .store(in: &subscriptions)
    }
    
    //MARK: - Add User Button Action
    @IBAction func addUserButtonAction(_ sender: UIButton) {
        let vc = UIStoryboard(name: Constants.Storyboard.UsersList, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewControllerId.AddUserViewController) as! AddUserViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: - Next Button Action
    @IBAction func nextButtonAction(_ sender: UIButton) {
        if userListViewModel.selectedUsersList.count < 3 {
            self.throwAlert(title: nil, msg: "Please select atleast 3 users.")
        } else {
            self.navigateToSelectedUserListView()
        }
    }
    
    //MARK: - Navigate To Selected User List View
    func navigateToSelectedUserListView() {
        let vc = UIStoryboard(name: Constants.Storyboard.UsersList, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewControllerId.SelectedUserViewController) as! SelectedUserViewController
        vc.selectedUserViewModel = SelectedUserViewModel.init(usersList: self.userListViewModel.selectedUsersList)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func formColorCode(index: Int) {
        if dictColor.keys.isEmpty {
            dictColor[index] = (Constants.ColorCode.red, Constants.ColorCode.green, Constants.ColorCode.blue)
        } else {
            if index != 0,
               dictColor.keys.count != self.userListViewModel.usersList.count,
               let tupleColorCode = dictColor[index - 1] {
                var red = tupleColorCode.0 + 5.0
                var green = tupleColorCode.1 + 5.0
                var blue = tupleColorCode.2 + 5.0
                if red >= Constants.ColorCode.fadedGray,
                    green >= Constants.ColorCode.fadedGray,
                    blue >= Constants.ColorCode.fadedGray {
                    red = Constants.ColorCode.fadedGray
                    green = Constants.ColorCode.fadedGray
                    blue = Constants.ColorCode.fadedGray
                }
                
                dictColor[index] = (red, green, blue)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - Extension for TableView
extension UsersListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userListViewModel.usersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.UserTableViewCell, for: indexPath) as! UserTableViewCell
        cell.configureView(user: userListViewModel.usersList[indexPath.row])
        self.formColorCode(index: indexPath.row)
        if let tupleRGB = dictColor[indexPath.row] {
            cell.setCellColor(tupleRGB)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserTableViewCell
        var user = userListViewModel.usersList[indexPath.row]
        user.isSelected.toggle()
        self.userListViewModel.usersList[indexPath.row] = user
        cell.configureView(user: user)
        self.userListViewModel.addUser(user: user)
    }
    
}

extension UsersListViewController: AddUserViewDelegate {
    func getAddedUserInfo(user: User) {
        DispatchQueue.main.async {
            self.userListViewModel.insertNewUser(user)
            self.tableUserList.reloadData()
        }
    }
}
