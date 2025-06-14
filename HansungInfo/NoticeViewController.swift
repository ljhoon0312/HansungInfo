//
//  NoticeViewController.swift
//  HansungInfo
//
//  Created by 이재훈 on 6/14/25.
//

import UIKit
import SafariServices

@objcMembers
class NoticeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var noticeTableView: UITableView!
    
    var notices: [Notice] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noticeTableView.dataSource = self
        noticeTableView.delegate = self
        loadNoticesFromJSON()

        // Do any additional setup after loading the view.
    }
    
    func loadNoticesFromJSON() {
        guard let url = Bundle.main.url(forResource: "Notices", withExtension: "json") else {
            print("Notices.json 파일을 찾을 수 없습니다.")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            self.notices = try decoder.decode([Notice].self, from: data)
            noticeTableView.reloadData()
        } catch {
            print("JSON 디코딩 오류: \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notices.count + 1 // 마지막 줄은 "더보기"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeCell", for: indexPath)

        if indexPath.row < notices.count {
            cell.textLabel?.text = "📌 \(notices[indexPath.row].title)"
            cell.textLabel?.textColor = .label
        } else {
            cell.textLabel?.text = "더보기"
            cell.textLabel?.textColor = .systemBlue
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < notices.count {
            let notice = notices[indexPath.row]
            if let url = URL(string: notice.url) {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true)
            }
        } else {
            // 더보기 눌렀을 때 학교 홈페이지 공지사항으로 이동
            if let moreURL = URL(string: "https://hansung.ac.kr/hansung/8385/subview.do") {
                let safariVC = SFSafariViewController(url: moreURL)
                present(safariVC, animated: true)
            }
        }

        tableView.deselectRow(at: indexPath, animated: true)
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
