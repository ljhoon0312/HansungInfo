//
//  LoginViewController.swift
//  HansungInfo
//
//  Created by 이재훈 on 6/18/25.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    var stackView: UIStackView!
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인"
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let hakbunField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "학번"
        tf.keyboardType = .numberPad
        tf.borderStyle = .roundedRect
        return tf
    }()

    let passwordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "비밀번호"
        tf.isSecureTextEntry = true
        tf.borderStyle = .roundedRect
        return tf
    }()

    let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("로그인", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 8
        btn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return btn
    }()
    
    let backgroundImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "background"))
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        setupUI()

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -24)
        ])

        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        stackView = UIStackView(arrangedSubviews: [hakbunField, passwordField, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])

        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }

    @objc func handleLogin() {
        guard let id = hakbunField.text, !id.isEmpty,
              let pw = passwordField.text, !pw.isEmpty else {
            showAlert("학번과 비밀번호를 입력하세요.")
            return
        }
        
        let email = "\(id)@hansung.ac.kr"
        
        Auth.auth().signIn(withEmail: email, password: pw) { result, error in
            if let error = error as NSError?,
               let code = AuthErrorCode(_bridgedNSError: error) {
                switch code.code {
                case .userNotFound:
                    self.showAlert("등록되지 않은 회원입니다.")
                case .wrongPassword:
                    self.showAlert("회원 정보를 다시 확인해주세요.")
                default:
                    self.showAlert("내부 오류가 발생했습니다. (\(error.localizedDescription))")
                }
                return // 에러가 났으면 여기서 끝내야 함
            }
            
            // 에러가 없더라도 result?.user가 없으면 로그인 실패
            guard let user = result?.user else {
                self.showAlert("로그인에 실패했습니다. 다시 시도해주세요.")
                return
            }
            
            // 로그인 성공 → 탭바 전환
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let tabBarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBar") as? UITabBarController {
                tabBarVC.modalPresentationStyle = .fullScreen
                self.present(tabBarVC, animated: true)
            }
        }
    }

    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
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
