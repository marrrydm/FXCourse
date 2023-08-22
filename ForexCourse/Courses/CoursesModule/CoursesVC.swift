import UIKit

protocol CoursesDelegate: AnyObject {
    func updateCourses(title: String, num: Int, section: Int)
}

class CoursesController: UIViewController {
    private lazy var coursesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.isUserInteractionEnabled = true
        tableView.register(CoursesCell.self, forCellReuseIdentifier: CoursesCell.id)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }()

    private var topicsFirst: [[CoursesModel]] = [
        [CoursesModel(title: "title1".localize(), img: UIImage(named: "img1"), checkImg: UIImage(named: "go"), description: "desctiprion1".localize(), isWaiting: false, num: 0),
         CoursesModel(title: "topic22".localize(), img: UIImage(named: "img2"), checkImg: UIImage(named: "timer"), description: "desctiprion2".localize(), isWaiting: false, num: 0),
         CoursesModel(title: "topic33".localize(), img: UIImage(named: "img3"), checkImg: UIImage(named: "go"), description: "desctiprion1".localize(), isWaiting: false, num: 0)]
    ]

    private var arrayTtiles: [String] = ["My courses".localize()]
    private var imgForTable: [UIImage?] = []
    var titleTopic: String?
    weak var delegate: CoursesDelegate?
    private var strategyValue: String?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coursesTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        view.addSubviews(coursesTableView)

        coursesTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.leading.trailing.equalToSuperview().inset(12)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension CoursesController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CoursesCell.id , for: indexPath) as! CoursesCell

        cell.setup(data: topicsFirst[indexPath.section][indexPath.row], selected: topicsFirst[indexPath.section][indexPath.row].title == titleTopic)

        cell.percentLbl.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1)

        if indexPath.row == 0 {
            if UserDefaults.standard.string(forKey: "percent") != "0" {
                let percent = UserDefaults.standard.string(forKey: "percent")
                cell.percentLbl.text = "passed".localize() + " " + String(percent!) + "%"
            } else {
                cell.percentLbl.text = "passed".localize() + " 0%"
            }

            if UserDefaults.standard.string(forKey: "percent") == "100" {
                cell.percentLbl.text = "passed".localize() + " 100%"
                cell.percentLbl.backgroundColor = UIColor(red: 0.204, green: 0.78, blue: 0.349, alpha: 1)
            } else {
                cell.percentLbl.backgroundColor = UIColor(red: 1, green: 0.62, blue: 0.04, alpha: 1)
            }

        } else if indexPath.row == 1 {
            if UserDefaults.standard.string(forKey: "percent2") != "0" {
                let percent = UserDefaults.standard.string(forKey: "percent2")
                cell.percentLbl.text = "passed".localize() + " " + String(percent!) + "%"
            } else {
                cell.percentLbl.text = "passed".localize() + " 0%"
            }
            if UserDefaults.standard.string(forKey: "percent2") == "99" {
                cell.percentLbl.text = "passed".localize() + " 100%"
                cell.percentLbl.backgroundColor = UIColor(red: 0.204, green: 0.78, blue: 0.349, alpha: 1)
            } else {
                cell.percentLbl.backgroundColor = UIColor(red: 1, green: 0.62, blue: 0.04, alpha: 1)
            }
        } else {
            if UserDefaults.standard.string(forKey: "percent3") != "0" {
                let percent = UserDefaults.standard.string(forKey: "percent3")
                cell.percentLbl.text = "passed".localize() + " " + String(percent!) + "%"
            } else {
                cell.percentLbl.text = "passed".localize() + " 0%"
            }
            if UserDefaults.standard.string(forKey: "percent3") == "99" {
                cell.percentLbl.text = "passed".localize() + " 100%"
                cell.percentLbl.backgroundColor = UIColor(red: 0.204, green: 0.78, blue: 0.349, alpha: 1)
            } else {
                cell.percentLbl.backgroundColor = UIColor(red: 1, green: 0.62, blue: 0.04, alpha: 1)
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topicsFirst[section].count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return topicsFirst.count
    }
}

extension CoursesController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionButton = UIButton()
        for (ind, value) in arrayTtiles.enumerated() where section == ind {
            sectionButton.setTitle((value), for: .normal)
        }
        sectionButton.contentHorizontalAlignment = .left
        sectionButton.titleLabel?.font = .systemFont(ofSize: 34, weight: .bold)
        sectionButton.setTitleColor(.black, for: .normal)
        sectionButton.backgroundColor = .clear
        sectionButton.tag = section
        return sectionButton
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let vc = MenuController()
        navigationController?.pushViewController(vc, animated: false)
        self.delegate = vc
        if indexPath.row == 0 {
            self.delegate?.updateCourses(title: topicsFirst[0][indexPath.row].title, num: topicsFirst[0][indexPath.row].num, section: indexPath.row)
        } else if indexPath.row == 1 {
            self.delegate?.updateCourses(title: "title11".localize(), num: topicsFirst[0][indexPath.row].num, section: indexPath.row)
        } else {
            self.delegate?.updateCourses(title: "title14".localize(), num: topicsFirst[0][indexPath.row].num, section: indexPath.row)
        }
    }
}
