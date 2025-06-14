//
//  GradeDetailViewController.swift
//  HansungInfo
//
//  Created by 이재훈 on 6/15/25.
//

import UIKit

class GradeDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var summaryLabel: UILabel!
    
    var gradeSemesters: [GradeSemester] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100

        loadGradeData()
        print("로드된 학기 수: \(gradeSemesters.count)")
        for semester in gradeSemesters {
            print("학기 \(semester.year)-\(semester.semester), 과목수: \(semester.courses.count)")
        }
        updateSummary()

        // Do any additional setup after loading the view.
    }
    
    private func loadGradeData() {
        guard let url = Bundle.main.url(forResource: "GradeRecords", withExtension: "json") else {
            print("GradeRecords.json 파일을 찾을 수 없습니다.")
            return
        }
        print("JSON 파일 경로: \(url)")  // 여기서 경로 출력

        do {
            let data = try Data(contentsOf: url)
            gradeSemesters = try JSONDecoder().decode([GradeSemester].self, from: data)
            tableView.reloadData()
        } catch {
            print("JSON 파싱 오류: \(error)")
        }
    }

    private func updateSummary() {
        let allCourses = gradeSemesters.flatMap { $0.courses }

        let gradeToPoint: [String: Double] = [
            "A+": 4.5, "A0": 4.0,
            "B+": 3.5, "B0": 3.0,
            "C+": 2.5, "C0": 2.0,
            "D+": 1.5, "D0": 1.0,
            "F": 0.0
        ]

        var totalCredits = 0
        var totalPoints: Double = 0.0

        print("=== 로드된 과목 및 성적 ===")
        for course in allCourses {
            print("과목명: \(course.name), 성적: \(course.grade), 학점: \(course.credit)")

            guard let point = gradeToPoint[course.grade] else {
                print("❗️정의되지 않은 성적: \(course.grade)")
                continue
            }
            totalCredits += course.credit
            totalPoints += point * Double(course.credit)
        }

        let gpa = totalCredits > 0 ? totalPoints / Double(totalCredits) : 0.0
        let percentage = (gpa / 4.5) * 100

        print("=== 계산 결과 ===")
        print("총 과목 수: \(allCourses.count)")
        print("총 이수 학점: \(totalCredits)")
        print("총 포인트: \(totalPoints)")
        print("GPA: \(gpa)")
        print("백분율: \(percentage)%")

        summaryLabel.text = String(format: "총 이수학점: %d | GPA: %.2f | 백분율: %.1f%%", totalCredits, gpa, percentage)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return gradeSemesters.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gradeSemesters[section].courses.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let s = gradeSemesters[section]
        return "\(s.year)년 \(s.semester)학기"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GradeCell", for: indexPath) as? GradeCell else {
            return UITableViewCell()
        }

        let semester = gradeSemesters[indexPath.section]
        let record = semester.courses[indexPath.row]
        cell.configure(name: record.name, code: record.code, credit: record.credit, grade: record.grade)
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
