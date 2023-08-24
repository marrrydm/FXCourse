import AppsFlyerLib
import FirebaseAnalytics
import StoreKit
import UIKit

class OnboardingControllerSecond: UIViewController {
    private let bgView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(named: "bg2")
        logoView.contentMode = .scaleToFill

        return logoView
    }()

    private let view1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1)
        view.layer.cornerRadius =  10

        return view
    }()

    private let view2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1)
        view.layer.cornerRadius =  10

        return view
    }()

    private let person1: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(named: "person1.onb")
        logoView.contentMode = .scaleAspectFit

        return logoView
    }()

    private let person2: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(named: "person2.onb")
        logoView.contentMode = .scaleAspectFit

        return logoView
    }()

    private let name1: UILabel = {
        let contentLabel = UILabel()
        contentLabel.text = "name1".localize()
        contentLabel.textColor = UIColor(red: 0.11, green: 0.11, blue: 0.118, alpha: 1)
        contentLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .left
        contentLabel.lineBreakMode = .byWordWrapping

        return contentLabel
    }()

    private let name2: UILabel = {
        let contentLabel = UILabel()
        contentLabel.text = "name2".localize()
        contentLabel.textColor = UIColor(red: 0.11, green: 0.11, blue: 0.118, alpha: 1)
        contentLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .left
        contentLabel.lineBreakMode = .byWordWrapping

        return contentLabel
    }()

    private let comment1: UILabel = {
        let contentLabel = UILabel()
        contentLabel.text = "comment1".localize()
        contentLabel.textColor = UIColor(red: 0.388, green: 0.388, blue: 0.4, alpha: 1)
        contentLabel.font = .systemFont(ofSize: 15, weight: .regular)
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .left
        contentLabel.lineBreakMode = .byWordWrapping

        return contentLabel
    }()

    private let comment2: UILabel = {
        let contentLabel = UILabel()
        contentLabel.text = "comment2".localize()
        contentLabel.textColor = UIColor(red: 0.388, green: 0.388, blue: 0.4, alpha: 1)
        contentLabel.font = .systemFont(ofSize: 15, weight: .regular)
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .left
        contentLabel.lineBreakMode = .byWordWrapping

        return contentLabel
    }()

    private let labelTitle: UILabel = {
        let labelTitle = UILabel()
        labelTitle.textColor = .white
        labelTitle.text = "onboarding.title1".localize()
        labelTitle.font = .systemFont(ofSize: 22, weight: .bold)
        labelTitle.numberOfLines = 0
        labelTitle.textAlignment = .center
        labelTitle.lineBreakMode = .byWordWrapping

        return labelTitle
    }()

    private let contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.text = "onboarding.content1".localize()
        contentLabel.textColor = .white
        contentLabel.font = .systemFont(ofSize: 17, weight: .regular)
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .center
        contentLabel.lineBreakMode = .byWordWrapping

        return contentLabel
    }()

    private lazy var nextButton: UIButton = {
        let nextButton = UIButton()
        nextButton.backgroundColor = UIColor(red: 0.039, green: 0.518, blue: 1, alpha: 1)
        nextButton.layer.cornerRadius = 14
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.setTitle("onboarding.nextButton0".localize(), for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        nextButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
        return nextButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        setupViews()
        makeConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }

    private func setupViews() {
        view.addSubviews(bgView, nextButton)
        bgView.addSubviews(labelTitle, contentLabel, view1, view2)
        view1.addSubviews(person1, name1, comment1)
        view2.addSubviews(person2, name2, comment2)
    }

    private func makeConstraints() {
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view2.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(labelTitle.snp.top).offset(-60)
            make.top.equalTo(person2.snp.top).offset(-14)
        }

        comment2.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-14)
            make.leading.equalTo(person2.snp.trailing).offset(16)
            make.bottom.equalTo(view2.snp.bottom).offset(-14)
        }

        name2.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-14)
            make.leading.equalTo(person2.snp.trailing).offset(16)
            make.bottom.equalTo(comment2.snp.top).offset(-8)
        }

        person2.snp.makeConstraints { make in
            make.top.equalTo(name2.snp.top)
            make.leading.equalToSuperview().offset(14)
            make.height.width.equalTo(54)
        }

        view1.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view2.snp.top).offset(-14)
            make.top.equalTo(person1.snp.top).offset(-14)
        }

        comment1.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-14)
            make.leading.equalTo(person1.snp.trailing).offset(16)
            make.bottom.equalTo(view1.snp.bottom).offset(-14)
        }

        name1.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-14)
            make.leading.equalTo(person1.snp.trailing).offset(16)
            make.bottom.equalTo(comment1.snp.top).offset(-8)
        }

        person1.snp.makeConstraints { make in
            make.top.equalTo(name1.snp.top)
            make.leading.equalToSuperview().offset(14)
            make.height.width.equalTo(54)
        }

        labelTitle.snp.makeConstraints { make in
            make.bottom.equalTo(contentLabel.snp.top).offset(-12)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        contentLabel.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.top).offset(-37)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
    }
}

extension OnboardingControllerSecond {
    @objc private func nextVC() {
        let vc = OnboardingControllerLast()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
}
