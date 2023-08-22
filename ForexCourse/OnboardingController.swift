import SnapKit
import UIKit

class OnboardingController: UIViewController {
    private let logoView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(named: "onbImg")
        logoView.contentMode = .scaleAspectFit

        return logoView
    }()

    private let labelTitle: UILabel = {
        let labelTitle = UILabel()
        labelTitle.textColor = UIColor(red: 0.11, green: 0.11, blue: 0.118, alpha: 1)
        labelTitle.text = "onboarding.title0".localize()
        labelTitle.font = .systemFont(ofSize: 22, weight: .bold)
        labelTitle.numberOfLines = 0
        labelTitle.textAlignment = .center
        labelTitle.lineBreakMode = .byWordWrapping

        return labelTitle
    }()

    private let contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.text = "onboarding.content0".localize()
        contentLabel.textColor = UIColor(red: 0.11, green: 0.11, blue: 0.118, alpha: 1)
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
        view.backgroundColor = .white

        setupViews()
        makeConstraints()
    }

    private func setupViews() {
        view.addSubviews(logoView, labelTitle, contentLabel, nextButton)
    }

    private func makeConstraints() {
        logoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(202)
            make.bottom.equalTo(labelTitle.snp.top).offset(-52)
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

extension OnboardingController {
    @objc private func nextVC() {
        let vc = TabBarController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}
