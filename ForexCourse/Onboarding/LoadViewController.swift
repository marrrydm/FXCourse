import SnapKit
import UIKit

class LoadViewController: UIViewController {
    private let bgView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(named: "bg")
        logoView.contentMode = .scaleToFill

        return logoView
    }()

    private let logoView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(named: "logo")
        logoView.contentMode = .scaleAspectFit

        return logoView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupViews()
        makeConstraints()
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(nextVC), userInfo: nil, repeats: false)

        let random = Int.random(in: 100000...999999)
        if UserDefaults.standard.string(forKey: "nickname") == "" {
            UserDefaults.standard.set("User_\(random)", forKey: "nickname")
        }
        if UserDefaults.standard.object(forKey: "arrLessons") == nil {
            UserDefaults.standard.set([0,1,2,3,4,5,6,7,8,9], forKey: "arrLessons")
        }

        if UserDefaults.standard.object(forKey: "arrLessons2") == nil {
            UserDefaults.standard.set([10, 11, 12], forKey: "arrLessons2")
        }

        if UserDefaults.standard.object(forKey: "arrLessons3") == nil {
            UserDefaults.standard.set([13, 14, 15], forKey: "arrLessons3")
        }

        if UserDefaults.standard.string(forKey: "percent") == "0" || UserDefaults.standard.string(forKey: "percent") == nil {
            UserDefaults.standard.set("0", forKey: "percent")
        }

        if UserDefaults.standard.string(forKey: "percent2") == "0" || UserDefaults.standard.string(forKey: "percent2") == nil {
            UserDefaults.standard.set("0", forKey: "percent2")
        }

        if UserDefaults.standard.string(forKey: "percent3") == "0" || UserDefaults.standard.string(forKey: "percent3") == nil {
            UserDefaults.standard.set("0", forKey: "percent3")
        }
    }

    private func setupViews() {
        view.addSubviews(bgView)
        bgView.addSubview(logoView)
    }

    private func makeConstraints() {
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        logoView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.width.equalTo(81)
        }
    }
}

extension LoadViewController {
    @objc private func nextVC() {
        if (UserDefaults.standard.string(forKey: "showedOnboarding") != nil) == true {
            let vc = TabBarController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        } else {
            UserDefaults.standard.set(true, forKey: "showedOnboarding")
            let vc = OnboardingController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
        }
    }
}
