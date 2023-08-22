import UIKit

protocol MenuDelegate: AnyObject {
    func updateMenu(title: String, num: Int, section: Int)
}

class MenuController: UIViewController {
    private let viewResult: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.35, green: 0.78, blue: 0.98, alpha: 1)
        view.layer.cornerRadius = 40
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        return view
    }()

    private let viewForLbls: UIView = {
        let view = UIView()
        view.backgroundColor = .clear

        return view
    }()

    private lazy var nextBtn: UIButton = {
        var nextButton = UIButton()
        nextButton.backgroundColor = UIColor(red: 0.04, green: 0.52, blue: 1, alpha: 1)
        nextButton.layer.cornerRadius = 14
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.setTitle("Read the lesson".localize(), for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        nextButton.addTarget(self, action: #selector(tapButtonNext), for: .touchUpInside)

        return nextButton
    }()

    private let titleLabel: UILabel = {
        let labelTitle = UILabel()
        labelTitle.textColor = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1)
        labelTitle.text = "title1".localize()
        labelTitle.font = .systemFont(ofSize: 22, weight: .bold)
        labelTitle.textAlignment = .center
        labelTitle.numberOfLines = 0
        labelTitle.lineBreakMode = .byWordWrapping

        return labelTitle
    }()

    private let lessonLabel: UILabel = {
        let labelTitle = UILabel()
        labelTitle.textColor = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1)
        labelTitle.text = "Lesson 1".localize()
        labelTitle.font = .systemFont(ofSize: 17, weight: .medium)
        labelTitle.textAlignment = .center

        return labelTitle
    }()

    private var capImg: UIImageView = {
        let capImg = UIImageView()
        capImg.image = UIImage(named: "cap")
        capImg.contentMode = .scaleAspectFit

        return capImg
    }()

    private lazy var nextImg: UIImageView = {
        let capImg = UIImageView()
        capImg.image = UIImage(named: "next")
        capImg.contentMode = .scaleAspectFit
        capImg.isUserInteractionEnabled = true
        capImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapNext)))

        return capImg
    }()

    private lazy var prevImg: UIImageView = {
        let capImg = UIImageView()
        capImg.image = UIImage(named: "prev")
        capImg.contentMode = .scaleAspectFit
        capImg.isUserInteractionEnabled = true
        capImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapPrev)))

        return capImg
    }()

    private lazy var personImg: UIImageView = {
        let capImg = UIImageView()
        capImg.image = UIImage(named: "person1")
        capImg.contentMode = .scaleAspectFit
        capImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapNext)))

        return capImg
    }()

    private var progressImg: UIImageView = {
        let capImg = UIImageView()
        capImg.image = UIImage(named: "progress1")
        capImg.contentMode = .scaleAspectFit

        return capImg
    }()

    private lazy var qrImg: UIImageView = {
        let capImg = UIImageView()
        capImg.image = UIImage(named: "qr")
        capImg.contentMode = .scaleAspectFit
        capImg.isUserInteractionEnabled = true
        capImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closePage)))

        return capImg
    }()

    weak var delegate: MenuDelegate?
    private var numberIndex = 0
    private var tempIndex = 0
    private var sectionIndex = 0
    private var numberIndex1 = 0
    private var tempIndex1 = 0
    private var sectionIndex1 = 0
    private var isFirst = false
    private let topics: [[String]] = [["title1".localize(), "title2".localize(), "title3".localize(), "title4".localize(), "title5".localize(), "title6".localize(), "title7".localize(), "title8".localize(), "title9".localize(), "title10".localize()], ["title11".localize(), "title12".localize(), "title13".localize()], ["title14".localize(), "title15".localize(), "title16".localize()]]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        view.addSubviews(viewResult, nextBtn, titleLabel, viewForLbls)
        viewForLbls.addSubviews(capImg, lessonLabel)
        viewResult.addSubviews(nextImg, prevImg, personImg, qrImg, progressImg)

        nextBtn.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(50)
        }

        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(nextBtn.snp.top).offset(-120)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        viewForLbls.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.top).offset(-35)
            make.centerX.equalTo(view.snp.centerX).offset(-60)
        }

        capImg.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.height.width.equalTo(24)
        }

        lessonLabel.snp.makeConstraints { make in
            make.leading.equalTo(capImg.snp.trailing).offset(8)
            make.centerY.equalTo(capImg.snp.centerY)
        }

        viewResult.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.centerY)
            make.top.leading.trailing.equalToSuperview()
        }

        nextImg.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(-15)
            make.height.width.equalTo(40)
        }

        prevImg.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.bottom.equalToSuperview().offset(-15)
            make.height.width.equalTo(40)
        }

        qrImg.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.height.width.equalTo(24)
        }

        progressImg.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(16)
            make.top.equalTo(qrImg.snp.bottom).offset(8)
        }

        personImg.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(80)
            make.bottom.equalTo(prevImg.snp.top).offset(-10)
            make.top.equalTo(qrImg.snp.bottom).offset(44)
        }
    }
}

extension MenuController: CoursesDelegate {
    func updateCourses(title: String, num: Int, section: Int) {
        numberIndex = num
        numberIndex1 = num
        sectionIndex = section
        let number = num + 1
        tempIndex = number
        titleLabel.text = title
        lessonLabel.text = "Lesson".localize() + " \(1)"
        personImg.image = UIImage(named: "person\(1)")
        if section == 0 {
            progressImg.image = UIImage(named: "progress\(1)")
        } else if section == 1 {
            progressImg.image = UIImage(named: "progress\(11)")
        } else {
            progressImg.image = UIImage(named: "progress\(11)")
        }
        prevImg.isHidden = true
        isFirst = true
    }
}

extension MenuController {
    @objc private func tapNext() {
        numberIndex += 1
        numberIndex1 = numberIndex
        prevImg.isHidden = false
        if sectionIndex == 0 {
            progressImg.image = UIImage(named: "progress\(numberIndex + 1)")
            if numberIndex == 9 {
                nextImg.isHidden = true
            } else {
                nextImg.isHidden = false
            }
        } else if sectionIndex == 1 || sectionIndex == 2 {
            progressImg.image = UIImage(named: "progress\(numberIndex + 11)")
            if numberIndex == 2 {
                nextImg.isHidden = true
            } else {
                nextImg.isHidden = false
            }
        }
        titleLabel.text = topics[sectionIndex][numberIndex]
        lessonLabel.text = "Lesson".localize() + " \(numberIndex + 1)"
        personImg.image = UIImage(named: "person\(1)")

    }

    @objc private func tapPrev() {
        numberIndex -= 1
        numberIndex1 = numberIndex
        nextImg.isHidden = false
        if sectionIndex == 0 {
            progressImg.image = UIImage(named: "progress\(numberIndex + 1)")
            if numberIndex == 0 {
                prevImg.isHidden = true
            } else {
                prevImg.isHidden = false
            }
        } else if sectionIndex == 1 || sectionIndex == 2 {
            progressImg.image = UIImage(named: "progress\(numberIndex + 11)")
            if numberIndex == 0 {
                prevImg.isHidden = true
            } else {
                prevImg.isHidden = false
            }
        }
        titleLabel.text = topics[sectionIndex][numberIndex]
        lessonLabel.text = "Lesson".localize() + " \(numberIndex + 1)"
        personImg.image = UIImage(named: "person\(1)")
    }

    @objc private func tapButtonNext() {
        let vc = LessonController()
        navigationController?.pushViewController(vc, animated: false)
        self.delegate = vc
        self.delegate?.updateMenu(title: titleLabel.text!, num: numberIndex1, section: sectionIndex)
    }

    @objc private func closePage() {
        navigationController?.popViewController(animated: true)
    }
}
