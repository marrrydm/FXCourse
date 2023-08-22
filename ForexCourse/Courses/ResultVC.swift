import UIKit

class ResultController: UIViewController, UIScrollViewDelegate {
    private let titleLabel: UILabel = {
        let labelTitle = UILabel()
        labelTitle.textColor = .black
        labelTitle.text = "That's great!".localize()
        labelTitle.font = .systemFont(ofSize: 18, weight: .bold)
        labelTitle.textAlignment = .center
        
        return labelTitle
    }()

    private let descritionLabel: UILabel = {
        let labelTitle = UILabel()
        labelTitle.textColor = UIColor(red: 0.23, green: 0.23, blue: 0.24, alpha: 1)
        labelTitle.text = "result.description" .localize()
        labelTitle.font = .systemFont(ofSize: 15, weight: .regular)
        labelTitle.textAlignment = .center
        labelTitle.numberOfLines = 0
        labelTitle.lineBreakMode = .byWordWrapping

        return labelTitle
    }()
    
    private var personImg: UIImageView = {
        var personImg = UIImageView()
        personImg.contentMode = .scaleAspectFit
        personImg.isUserInteractionEnabled = true
        personImg.image = UIImage(named: "result")
        
        return personImg
    }()

    private let view1: UIView = {
        let viewTest = UIView()
        viewTest.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1)
        viewTest.layer.cornerRadius = 14
        viewTest.contentMode = .center

        return viewTest
    }()

    private let answerLbl1: UILabel = {
        let labelTitle = UILabel()
        labelTitle.textColor = UIColor(red: 0.22, green: 0.22, blue: 0.23, alpha: 1)
        labelTitle.font = .systemFont(ofSize: 15, weight: .semibold)
        labelTitle.textAlignment = .left
        labelTitle.lineBreakMode = .byWordWrapping
        labelTitle.numberOfLines = 0

        return labelTitle
    }()

    private var completeImg: UIImageView = {
        var personImg = UIImageView()
        personImg.contentMode = .scaleAspectFit
        personImg.isUserInteractionEnabled = true
        personImg.image = UIImage(named: "complete")

        return personImg
    }()

    private lazy var nextBtn: UIButton = {
        var nextButton = UIButton()
        nextButton.backgroundColor = UIColor(red: 0.04, green: 0.52, blue: 1, alpha: 1)
        nextButton.layer.cornerRadius = 14
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.setTitle("Next".localize(), for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        nextButton.addTarget(self, action: #selector(tapButtonNext), for: .touchUpInside)

        return nextButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        view.addSubviews(titleLabel, descritionLabel, personImg, view1, nextBtn)
        view1.addSubviews(answerLbl1, completeImg)

        personImg.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(90)
            make.bottom.equalTo(view.snp.centerY).offset(-20)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(personImg.snp.bottom).offset(30)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(36)
        }

        descritionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(36)
        }

        view1.snp.makeConstraints { make in
            make.top.equalTo(descritionLabel.snp.bottom).offset(20)
            make.trailing.equalTo(answerLbl1.snp.trailing).offset(16)
            make.leading.equalTo(completeImg.snp.leading).offset(-16)
            make.centerX.equalToSuperview()
        }

        answerLbl1.snp.makeConstraints { make in
            make.centerY.equalTo(completeImg.snp.centerY)
            make.leading.equalTo(completeImg.snp.trailing).offset(10)
        }

        completeImg.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(16)
            make.height.width.equalTo(24)
        }

        nextBtn.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(50)
        }
    }
}

extension ResultController {
    @objc private func tapButtonNext() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension ResultController: QuizDelegate {
    func updateQuiz(result: Int, num: Int, section: Int) {
        answerLbl1.text = "\(result)/3 " + "correct".localize()
        if section == 0 {
            var savedNumbers = UserDefaults.standard.array(forKey: "arrLessons") as? [Int]
            let old = savedNumbers
            savedNumbers?.removeAll(where: { $0 == num })
            if savedNumbers != old {
                UserDefaults.standard.set(savedNumbers, forKey: "arrLessons")
                let percent = UserDefaults.standard.string(forKey: "percent")
                var intPercent = Int(percent ?? "")
                intPercent! += 10
                UserDefaults.standard.set(String(intPercent!), forKey: "percent")
            }
        } else if section == 1 {
            var savedNumbers = UserDefaults.standard.array(forKey: "arrLessons2") as? [Int]
            if savedNumbers == [] {
                UserDefaults.standard.set(String("100"), forKey: "percent3")
            } else {
                let old = savedNumbers
                savedNumbers?.removeAll(where: { $0 == num })
                if savedNumbers != old {
                    UserDefaults.standard.set(savedNumbers, forKey: "arrLessons2")
                    let percent = UserDefaults.standard.string(forKey: "percent2")
                    var intPercent = Int(percent ?? "")
                    intPercent! += 33
                    UserDefaults.standard.set(String(intPercent!), forKey: "percent2")
                }
            }
        } else {
            var savedNumbers = UserDefaults.standard.array(forKey: "arrLessons3") as? [Int]
            if savedNumbers == [] {
                UserDefaults.standard.set(String("100"), forKey: "percent3")
            } else {
                let old = savedNumbers
                savedNumbers?.removeAll(where: { $0 == num })
                if savedNumbers != old {
                    UserDefaults.standard.set(savedNumbers, forKey: "arrLessons3")
                    let percent = UserDefaults.standard.string(forKey: "percent3")
                    var intPercent = Int(percent ?? "")
                    intPercent! += 33
                    UserDefaults.standard.set(String(intPercent!), forKey: "percent3")
                }
            }
        }
    }
}
