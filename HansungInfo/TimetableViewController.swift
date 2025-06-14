//
//  TimetableViewController.swift
//  HansungInfo
//
//  Created by 이재훈 on 6/15/25.
//

import UIKit

struct Lecture: Codable {
    let subject: String
    let classNum: String
    let professor: String
    let room: String
    let time: String

    enum CodingKeys: String, CodingKey {
        case subject
        case classNum = "class"
        case professor
        case room
        case time
    }
}

struct Timetable: Codable {
    let timetable: [String: [Lecture]]
}

class TimetableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var daySegmentedControl: UISegmentedControl!
    
    var timetable: Timetable?
    var filteredLectures: [Lecture] = []
    var currentDay: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self

        // 셀 등록 (코드로 만든 셀이라서 직접 등록 필요)
        tableView.register(LectureCell.self, forCellReuseIdentifier: "LectureCell")

        setupSegmentedControl()
        loadTimetableData()

        // 고정 셀 높이 (더 크게)
        tableView.rowHeight = 90
        tableView.estimatedRowHeight = 90
    }
    
    func setupSegmentedControl() {
        daySegmentedControl.removeAllSegments()
        let days = ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"]
        for (index, day) in days.enumerated() {
            daySegmentedControl.insertSegment(withTitle: day, at: index, animated: false)
        }

        let today = getTodayWeekday()
        if let todayIndex = days.firstIndex(of: today) {
            daySegmentedControl.selectedSegmentIndex = todayIndex
            currentDay = today
        } else {
            daySegmentedControl.selectedSegmentIndex = 0
            currentDay = days[0]
        }

        daySegmentedControl.addTarget(self, action: #selector(daySegmentChanged(_:)), for: .valueChanged)
    }

    func loadTimetableData() {
        guard let loaded = loadTimetable() else {
            filteredLectures = []
            tableView.reloadData()
            return
        }
        timetable = loaded
        filterLectures(for: currentDay)
        tableView.reloadData()
    }

    func filterLectures(for day: String) {
        filteredLectures = timetable?.timetable[day] ?? []
        currentDay = day
    }

    @objc func daySegmentChanged(_ sender: UISegmentedControl) {
        let days = ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"]
        let selectedIndex = sender.selectedSegmentIndex
        if selectedIndex >= 0 && selectedIndex < days.count {
            filterLectures(for: days[selectedIndex])
            tableView.reloadData()
        }
    }

    func getTodayWeekday() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "EEEE"
        return formatter.string(from: Date())
    }

    func loadTimetable() -> Timetable? {
        guard let url = Bundle.main.url(forResource: "timetable", withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(Timetable.self, from: data)
    }
}

extension TimetableViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // 선택한 요일만 보여주니까 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLectures.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return currentDay
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LectureCell", for: indexPath) as? LectureCell else {
            return UITableViewCell()
        }

        let lecture = filteredLectures[indexPath.row]
        cell.configure(with: lecture)
        return cell
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
