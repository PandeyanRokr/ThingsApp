//
//  SelectedUserViewController.swift
//  TheThingsApp
//
//  Created by Pandeyan Rokr on 2022-07-27.
//

import UIKit

class SelectedUserViewController: UIViewController {
    
    @IBOutlet weak var tableUserList: UITableView!
    @IBOutlet weak var selectedUserView: UIView!
    @IBOutlet weak var lblSelectedUser: UILabel!
    
    var selectedUserViewModel: SelectedUserViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        selectedUserView.layer.cornerRadius = Constants.CornerRadius.value8
        tableUserList.register(UINib(nibName: Constants.NibName.SelectedUserTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.CellIdentifier.SelectedUserTableViewCell)
        self.setUpView()
        
    }
    
    //MARK: - Set Up View
    func setUpView() {
        if let viewModel = selectedUserViewModel,
           let usersList = viewModel.selectedUsersList {
            self.lblSelectedUser.text = usersList.first?.name ?? ""
            self.tableUserList.reloadData()
            self.animateSelectedUserView()
        }
    }
    
    //MARK: - Animate Selected User View
    private func animateSelectedUserView() {
        UIView .transition(with: self.selectedUserView, duration: 1.0, options: .transitionCurlUp,animations: {
            let scale = CGAffineTransform(scaleX: 1.15, y: 1.15)
            self.lblSelectedUser.transform = scale
            UIView.animate(withDuration: 0.5, delay: 1.0, options: .curveEaseInOut, animations: {
                self.lblSelectedUser.transform = .identity
            }, completion: nil)
        })
    }

    //MARK: - Navigate Back
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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

extension SelectedUserViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedUserViewModel?.selectedUsersList?.count ?? Constants.Value.zeroInt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.SelectedUserTableViewCell, for: indexPath) as! SelectedUserTableViewCell
        if let user = selectedUserViewModel?.selectedUsersList?[indexPath.row] {
            cell.configureView(user: user)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewModel = selectedUserViewModel,
           let usersList = viewModel.selectedUsersList {
            self.lblSelectedUser.text = usersList[indexPath.row].name
            self.animateSelectedUserView()
        }
    }

}
