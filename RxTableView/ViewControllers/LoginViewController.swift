//
//  LoginViewController.swift
//  RxTableView
//
//  Created by Paul Matar on 02/07/2022.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        bindTFsAndLoginButton()
    }
    
    private func bindTFsAndLoginButton() {
        let obs1 = usernameTF.rx.text.orEmpty
        let obs2 = passwordTF.rx.text.orEmpty
        
        let observableCombined = Observable.combineLatest(obs1, obs2)
        
        loginButton.rx.tap
            .withLatestFrom(observableCombined)
            .subscribe(onNext: {
                self.login(user: $0, pass: $1)
            })
            .disposed(by: bag)
    }
    
    private func login(user: String, pass: String) {
        let emailRexEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRexEx)
        let emailValid = emailTest.evaluate(with: user)
        let passValid = pass != "" && pass.count >= 6
        
        if emailValid && passValid {
            let foodListVC = storyboard?.instantiateViewController(withIdentifier: "FoodListVC") as! ViewController
            navigationController?.pushViewController(foodListVC, animated: true)
        } else {
            Utils.displaySimpleAlert(title: "Wrong credentials",
                                     message: "Please enter a valid username and passwod",
                                     viewController: self)
        }
    }

}
