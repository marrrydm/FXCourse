import AppsFlyerLib
import FirebaseAnalytics
import OneSignal
import UIKit

class OnboardingControllerLast: UIViewController {
    private let bgView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(named: "bg2")
        logoView.contentMode = .scaleToFill

        return logoView
    }()

    private let logoView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(named: "onbImg3")
        logoView.contentMode = .scaleAspectFit

        return logoView
    }()

    private let labelTitle: UILabel = {
        let labelTitle = UILabel()
        labelTitle.textColor = .white
        labelTitle.text = "onboarding.title2".localize()
        labelTitle.font = .systemFont(ofSize: 22, weight: .bold)
        labelTitle.numberOfLines = 0
        labelTitle.textAlignment = .center
        labelTitle.lineBreakMode = .byWordWrapping

        return labelTitle
    }()

    private let contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.text = "onboarding.content2".localize()
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

    private func setupViews() {
        view.addSubviews(bgView, nextButton)
        bgView.addSubviews(logoView, labelTitle, contentLabel)
    }

    private func makeConstraints() {
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        logoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(202)
            make.bottom.equalTo(labelTitle.snp.top).offset(-60)
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

extension OnboardingControllerLast {
    @objc private func nextVC() {
        AppsFlyerLib.shared().logEvent("onboarding_finish", withValues: nil)
        Analytics.logEvent("onboarding_finish", parameters: nil)

        OneSignal.promptForPushNotifications(userResponse: { accepted in
            let vc = TabBarController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        })
    }
}
