//
//  AddUserViewController.swift
//  TheThingsApp
//
//  Created by Pandeyan Rokr on 2022-07-29.
//

import UIKit

protocol AddUserViewDelegate: AnyObject {
    func getAddedUserInfo(user: User)
}

class AddUserViewController: UIViewController {
    
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var userView: UIView!
    
    weak var delegate: AddUserViewDelegate?
    var isTextEmpty = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setUpView()
    }
    
    //MARk: - Set Up View
    func setUpView() {
        userView.layer.cornerRadius = Constants.CornerRadius.value8
        textFieldFirstName.layer.cornerRadius = Constants.CornerRadius.value5
        textFieldLastName.layer.cornerRadius = Constants.CornerRadius.value5
        textFieldFirstName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textFieldLastName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    //MARK: - Text Field Did Change
    @objc func textFieldDidChange(_ textField: UITextField) {
        if isTextEmpty {
            isTextEmpty = false
            textFieldFirstName.addDefaulBorderForNameField()
            textFieldLastName.addDefaulBorderForNameField()
        }
    }
    
    //MARK: - Add Button Action
    @IBAction func addButtonAction(_ sender: UIButton) {
        isTextEmpty = true
        if !(textFieldFirstName.hasText) && !(textFieldLastName.hasText) {
            textFieldFirstName.addRedBorder()
            textFieldLastName.addRedBorder()
            self.throwAlert(title: nil, msg: "Please enter both first name & last name.")
        }else if !(textFieldFirstName.hasText) {
            textFieldFirstName.addRedBorder()
            self.throwAlert(title: nil, msg: "Please enter first name.")
        } else if !(textFieldLastName.hasText) {
            textFieldLastName.addRedBorder()
            self.throwAlert(title: nil, msg: "Please enter last name.")
        } else {
            isTextEmpty = false
            let userId = Int.random(in: 1000..<10000)
            let name = textFieldFirstName.text! + " " + textFieldLastName.text!
            let user = User(id: userId, name: name, email: "", gender: "", status: "")
            self.delegate?.getAddedUserInfo(user: user)
            dismissController()
        }
    }
    
    //MARK: - Close Button Action
    @IBAction func closeButtonAction(_ sender: UIButton) {
        dismissController()
    }
    
    //MARK: - Dismiss Controller
    func dismissController() {
        self.dismiss(animated: true, completion: nil)
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

extension AddUserViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = Constants.Value.AllowedAlphaNumericCharacters
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
        return alphabet
    }
}
