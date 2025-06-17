//
//  MoreViewController.swift
//  HansungInfo
//
//  Created by 이재훈 on 6/18/25.
//

import UIKit
import FirebaseAuth

struct MoreOption: Codable {
    let title: String
    let icon: String
    let url: String
}

class MoreViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var options: [MoreOption] = []
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "더 보기"
        view.backgroundColor = .systemBackground

        // 톱니바퀴 버튼
        let gearItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(openSettings))
        navigationItem.rightBarButtonItem = gearItem

        setupCollectionView()
        loadOptions()
        
        view.backgroundColor = .systemBackground
        /*
        setupNavigationBar()
        loadOptions()
        setupCollectionView()
         */

        // Do any additional setup after loading the view.
    }
    
    func setupNavigationBar() {
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(openSettings))
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    @objc func openSettings() {
        let alert = UIAlertController(title: "설정", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "개발자 정보", style: .default, handler: { _ in
            let infoAlert = UIAlertController(title: nil, message: "개발자 : 1871405 이재훈", preferredStyle: .alert)
            infoAlert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(infoAlert, animated: true)
        }))

        alert.addAction(UIAlertAction(title: "로그아웃", style: .destructive, handler: { _ in
            do {
                try Auth.auth().signOut()
                let loginVC = LoginViewController()
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true)
            } catch {
                print("로그아웃 실패: \(error.localizedDescription)")
            }
        }))

        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true)
    }
    
    func loadOptions() {
        if let path = Bundle.main.path(forResource: "MoreOptions", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
           let decoded = try? JSONDecoder().decode([MoreOption].self, from: data) {
            options = decoded
        }
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width / 3 - 16, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MoreOptionCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let option = options[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MoreOptionCell
        cell.configure(with: option)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let option = options[indexPath.item]
        if let url = URL(string: option.url) {
            UIApplication.shared.open(url)
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
