import UIKit

protocol QuizDelegate: AnyObject {
    func updateQuiz(result: Int, num: Int, section: Int)
}

class QuizController: UIViewController, UIScrollViewDelegate {
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.isUserInteractionEnabled = true

        return view
    }()

    private let titleLabel: UILabel = {
        let labelTitle = UILabel()
        labelTitle.textColor = .black
        labelTitle.text = "Quiz".localize()
        labelTitle.font = .systemFont(ofSize: 18, weight: .bold)
        labelTitle.textAlignment = .center
        
        return labelTitle
    }()
    
    private lazy var close: UIImageView = {
        var close = UIImageView()
        close.contentMode = .scaleAspectFit
        close.isUserInteractionEnabled = true
        close.image = UIImage(named: "close")
        close.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closePage)))
        
        return close
    }()

    private var progressImg: UIImageView = {
        var close = UIImageView()
        close.contentMode = .scaleAspectFit
        close.image = UIImage(named: "quiz1")
        return close
    }()

    private var img: UIImageView = {
        var img = UIImageView()
        img.image = UIImage(named: "quiz1.2")
        img.contentMode = .scaleToFill
        img.layer.cornerRadius = 20
        img.layer.masksToBounds = true

        return img
    }()

    private let questionLbl: UILabel = {
        let labelTitle = UILabel()
        labelTitle.textColor = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1)
        labelTitle.text = "question1.2".localize()
        labelTitle.font = .systemFont(ofSize: 20, weight: .semibold)
        labelTitle.textAlignment = .center
        labelTitle.lineBreakMode = .byWordWrapping
        labelTitle.numberOfLines = 0

        return labelTitle
    }()

    private lazy var view1: UIButton = {
        let viewTest = UIButton()
        viewTest.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1)
        viewTest.layer.cornerRadius = 14
        viewTest.addTarget(self, action: #selector(btnClickCheck), for: .touchUpInside)
        viewTest.tag = 0

        return viewTest
    }()

    private lazy var view2: UIButton = {
        let viewTest = UIButton()
        viewTest.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1)
        viewTest.layer.cornerRadius = 14
        viewTest.addTarget(self, action: #selector(btnClickCheck), for: .touchUpInside)
        viewTest.tag = 1

        return viewTest
    }()

    private lazy var view3: UIButton = {
        let viewTest = UIButton()
        viewTest.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1)
        viewTest.layer.cornerRadius = 14
        viewTest.addTarget(self, action: #selector(btnClickCheck), for: .touchUpInside)
        viewTest.tag = 2

        return viewTest
    }()

    private lazy var view4: UIButton = {
        let viewTest = UIButton()
        viewTest.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1)
        viewTest.layer.cornerRadius = 14
        viewTest.addTarget(self, action: #selector(btnClickCheck), for: .touchUpInside)
        viewTest.tag = 3

        return viewTest
    }()

    private let answerLbl1: UILabel = {
        let labelTitle = UILabel()
        labelTitle.textColor = UIColor(red: 0.22, green: 0.22, blue: 0.23, alpha: 1)
        labelTitle.text = "answer1.2.1".localize()
        labelTitle.font = .systemFont(ofSize: 15, weight: .regular)
        labelTitle.textAlignment = .left
        labelTitle.lineBreakMode = .byWordWrapping
        labelTitle.numberOfLines = 0

        return labelTitle
    }()

    private let answerLbl2: UILabel = {
        let labelTitle = UILabel()
        labelTitle.textColor = UIColor(red: 0.22, green: 0.22, blue: 0.23, alpha: 1)
        labelTitle.text = "answer1.2.2".localize()
        labelTitle.font = .systemFont(ofSize: 15, weight: .regular)
        labelTitle.textAlignment = .left
        labelTitle.lineBreakMode = .byWordWrapping
        labelTitle.numberOfLines = 0

        return labelTitle
    }()

    private let answerLbl3: UILabel = {
        let labelTitle = UILabel()
        labelTitle.textColor = UIColor(red: 0.22, green: 0.22, blue: 0.23, alpha: 1)
        labelTitle.text = "answer1.2.3".localize()
        labelTitle.font = .systemFont(ofSize: 15, weight: .regular)
        labelTitle.textAlignment = .left
        labelTitle.lineBreakMode = .byWordWrapping
        labelTitle.numberOfLines = 0

        return labelTitle
    }()

    private let answerLbl4: UILabel = {
        let labelTitle = UILabel()
        labelTitle.textColor = UIColor(red: 0.22, green: 0.22, blue: 0.23, alpha: 1)
        labelTitle.text = "answer1.2.3".localize()
        labelTitle.font = .systemFont(ofSize: 15, weight: .regular)
        labelTitle.textAlignment = .left
        labelTitle.lineBreakMode = .byWordWrapping
        labelTitle.numberOfLines = 0

        return labelTitle
    }()

    private lazy var nextButton: UIButton = {
        let nextButton = UIButton()
        nextButton.backgroundColor = UIColor(red: 0.04, green: 0.52, blue: 1, alpha: 1)
        nextButton.layer.cornerRadius = 14
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.setTitle("Next".localize(), for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        nextButton.addTarget(self, action: #selector(tapButtonNext), for: .touchUpInside)

        return nextButton
    }()

    private var topicVal = [QuizeModel]()
    private var number = 0
    private var trueNums = [(1, 1, 1), (1, 1, 1), (1, 2, 0), (1, 1, 1), (1, 2, 1),
                            (1, 1, 1), (2, 1, 1), (1, 1, 2), (1, 0, 3), (1, 1, 1),
                            (1, 2, 2), (1, 2, 2), (2, 2, 2),
                            (2, 2, 2), (1, 2, 2), (1, 2, 1)
    ]
    private var circle = 1
    private var result = 0
    private var nums = 0
    weak var delegate: QuizDelegate?
    private var numSection = 0

    private var numForArray = -1

    private var isChecked: Int = -1 {
        didSet {
            var numTrue = 0
            switch circle {
            case 1:
                numTrue = trueNums[number].0
            case 2:
                numTrue = trueNums[number].1
            case 3:
                numTrue = trueNums[number].2
            default: break
            }
            if isChecked == numTrue {
                result += 1
                switch isChecked {
                case 0: view1.backgroundColor = UIColor(red: 0.19, green: 0.86, blue: 0.36, alpha: 1)
                    answerLbl1.textColor = .white
                case 1: view2.backgroundColor = UIColor(red: 0.19, green: 0.86, blue: 0.36, alpha: 1)
                    answerLbl2.textColor = .white
                case 2: view3.backgroundColor = UIColor(red: 0.19, green: 0.86, blue: 0.36, alpha: 1)
                    answerLbl3.textColor = .white
                case 3: view4.backgroundColor = UIColor(red: 0.19, green: 0.86, blue: 0.36, alpha: 1)
                    answerLbl4.textColor = .white
                default: break
                }
            } else {
                let trueNum = numTrue
                switch isChecked {
                case 0: view1.backgroundColor = UIColor(red: 0.84, green: 0, blue: 0.08, alpha: 1)
                    answerLbl1.textColor = .white
                case 1: view2.backgroundColor = UIColor(red: 0.84, green: 0, blue: 0.08, alpha: 1)
                    answerLbl2.textColor = .white
                case 2: view3.backgroundColor = UIColor(red: 0.84, green: 0, blue: 0.08, alpha: 1)
                    answerLbl3.textColor = .white
                case 3: view4.backgroundColor = UIColor(red: 0.84, green: 0, blue: 0.08, alpha: 1)
                    answerLbl4.textColor = .white
                default: break
                }

                switch trueNum {
                case 0: view1.backgroundColor = UIColor(red: 0.19, green: 0.86, blue: 0.36, alpha: 1)
                    answerLbl1.textColor = .white
                case 1: view2.backgroundColor = UIColor(red: 0.19, green: 0.86, blue: 0.36, alpha: 1)
                    answerLbl2.textColor = .white
                case 2: view3.backgroundColor = UIColor(red: 0.19, green: 0.86, blue: 0.36, alpha: 1)
                    answerLbl3.textColor = .white
                case 3: view4.backgroundColor = UIColor(red: 0.19, green: 0.86, blue: 0.36, alpha: 1)
                    answerLbl4.textColor = .white
                default: break
                }
            }
            view1.isUserInteractionEnabled = false
            view2.isUserInteractionEnabled = false
            view3.isUserInteractionEnabled = false
            view4.isUserInteractionEnabled = false
            nextButton.alpha = 1
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.layoutIfNeeded()
        scrollView.updateContentView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        nextButton.alpha = 0
        scrollView.delegate = self
        view.addSubviews(scrollView, titleLabel, close, nextButton)
        scrollView.addSubviews(progressImg, img, questionLbl, view1, view2, view3, view4)
        view1.addSubview(answerLbl1)
        view2.addSubview(answerLbl2)
        view3.addSubview(answerLbl3)
        view4.addSubview(answerLbl4)

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(nextButton.snp.top).offset(-5)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        close.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.leading.equalToSuperview().offset(14)
            make.height.equalTo(24)
            make.width.equalTo(18)
        }

        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(50)
        }

        progressImg.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(6)
        }

        img.snp.makeConstraints { make in
            make.top.equalTo(progressImg.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(180)
        }

        questionLbl.snp.makeConstraints { make in
            make.top.equalTo(img.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        view1.snp.makeConstraints { make in
            make.top.equalTo(questionLbl.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(26)
        }

        view2.snp.makeConstraints { make in
            make.top.equalTo(view1.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(26)
        }

        view3.snp.makeConstraints { make in
            make.top.equalTo(view2.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(26)
        }

        view4.snp.makeConstraints { make in
            make.top.equalTo(view3.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(26)
        }

        answerLbl1.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.edges.equalToSuperview().inset(16)
        }

        answerLbl2.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.edges.equalToSuperview().inset(16)
        }

        answerLbl3.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.edges.equalToSuperview().inset(16)
        }

        answerLbl4.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.edges.equalToSuperview().inset(16)
        }
    }
}

extension QuizController: LessonDelegate {
    func updateLesson(title: String, num: Int, section: Int) {
        if section == 0 {
            numForArray = num
            number = num
            img.image = UIImage(named: "quiz\(number + 1).1")
        } else if section == 1 {
            numForArray = 10 + num
            number = 10 + num
            img.image = UIImage(named: "quiz\(number + 1 - 10).1")
        } else {
            numForArray = 13 + num
            number = 13 + num
            img.image = UIImage(named: "quiz\(number + 1 - 13).1")
        }

        numSection = section

        questionLbl.text = "question\(number + 1).1".localize()
        answerLbl1.text = "answer\(number + 1).1.1".localize()
        answerLbl2.text = "answer\(number + 1).1.2".localize()
        if "answer\(number + 1).1.3".localize() == "answer\(number + 1).1.3" {
            view3.isHidden = true
        } else {
            view3.isHidden = false
            answerLbl3.text = "answer\(number + 1).1.3".localize()
        }
        if "answer\(number + 1).1.4".localize() == "answer\(number + 1).1.4" {
            view4.isHidden = true
        } else {
            view4.isHidden = false
            answerLbl4.text = "answer\(number + 1).1.4".localize()
        }
    }
}

extension QuizController {
    @objc func btnClickCheck(_ sender: UIButton) {
        switch (sender) {
        case view1:
            isChecked = 0
        case view2:
            isChecked = 1
        case view3:
            isChecked = 2
        case view4:
            isChecked = 3
        default: break
        }
    }

    @objc private func tapButtonNext(sender: UITapGestureRecognizer) {
        if isChecked != -1 {
            circle += 1
            if circle == 4 {
                let vc = ResultController()
                navigationController?.pushViewController(vc, animated: false)
                self.delegate = vc
                self.delegate?.updateQuiz(result: result, num: numForArray, section: numSection)
            } else {
                nextButton.alpha = 0
                isChecked = -1
                questionLbl.text = "question\(number + 1).\(circle)".localize()
                answerLbl1.text = "answer\(number + 1).\(circle).1".localize()
                answerLbl2.text = "answer\(number + 1).\(circle).2".localize()
                if "answer\(number + 1).\(circle).3".localize() == "answer\(number + 1).\(circle).3" {
                    view3.isHidden = true
                } else {
                    view3.isHidden = false
                    answerLbl3.text = "answer\(number + 1).\(circle).3".localize()
                }
                if "answer\(number + 1).\(circle).4".localize() == "answer\(number + 1).\(circle).4" {
                    view4.isHidden = true
                } else {
                    view4.isHidden = false
                    answerLbl4.text = "answer\(number + 1).\(circle).4".localize()
                }

                if numSection == 0 {
                    img.image = UIImage(named: "quiz\(number + 1).\(circle)")
                } else if numSection == 1 {
                    img.image = UIImage(named: "quiz\(number + 1 - 10).\(circle)")
                } else {
                    img.image = UIImage(named: "quiz\(number + 1 - 13).\(circle)")
                }

                progressImg.image = UIImage(named: "quiz\(circle)")

                view1.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1)
                view2.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1)
                view3.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1)
                view4.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1)
                answerLbl1.textColor = .black
                answerLbl2.textColor = .black
                answerLbl3.textColor = .black
                answerLbl4.textColor = .black
                view1.isUserInteractionEnabled = true
                view2.isUserInteractionEnabled = true
                view3.isUserInteractionEnabled = true
                view4.isUserInteractionEnabled = true
            }
        }
    }
}

extension QuizController {
    @objc private func closePage() {
        navigationController?.popViewController(animated: true)
    }
}
