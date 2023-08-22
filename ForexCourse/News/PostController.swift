import UIKit

class PostController: UIViewController {
    private let titleLabel: UILabel = {
        let labelTitle = UILabel()
        labelTitle.textColor = .black
        labelTitle.text = "New post".localize()
        labelTitle.font = .systemFont(ofSize: 17, weight: .semibold)
        labelTitle.textAlignment = .center

        return labelTitle
    }()

    private lazy var btnEdit: UIButton = {
        var btn = UIButton()
        btn.backgroundColor = .clear
        btn.setTitle("Done".localize(), for: .normal)
        btn.setTitleColor(UIColor(red: 0.25, green: 0.61, blue: 1, alpha: 1), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        btn.addTarget(self, action: #selector(newPost), for: .touchUpInside)

        return btn
    }()

    private lazy var btnCancel: UIButton = {
        var btn = UIButton()
        btn.backgroundColor = .clear
        btn.setTitle("Cancel".localize(), for: .normal)
        btn.setTitleColor(UIColor(red: 0.25, green: 0.61, blue: 1, alpha: 1), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        btn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)

        return btn
    }()

    private let descriptionTextField: TextField = {
        let nicknameTextField = TextField()
        nicknameTextField.backgroundColor = .clear
        nicknameTextField.placeholder = "Write your news...".localize()
        nicknameTextField.addDoneButtonOnKeyboard()
        nicknameTextField.textColor = UIColor(red: 0.24, green: 0.24, blue: 0.26, alpha: 1)
        nicknameTextField.font = .systemFont(ofSize: 17, weight: .regular)
        nicknameTextField.textAlignment = .left
        return nicknameTextField
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        view.addSubviews(titleLabel, btnEdit, btnCancel, descriptionTextField)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        btnEdit.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        btnCancel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }

        descriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}

extension PostController {
    private func postURL(name: String, comment: String) {
        let headers = [
          "accept": "*/*",
          "content-type": "application/json"
        ]
        let parameters = [
          "included_segments": ["OneSignalId"],
          "contents": [
            "name": name,
            "comment": comment
          ],
          "name": name,
          "comment": comment
        ] as [String : Any]

        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])

        var request = URLRequest(url: URL(string: "http://terms.fx-courses.com/post/comment")! as URL,
                                          cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
              print(error?.localizedDescription ?? "")
          }
        })
        dataTask.resume()
    }

    @objc private func cancelAction() {
        dismiss(animated: false)
    }

    @objc private func newPost() {
        if descriptionTextField.text != "" {
            var name = ""
            if let loadedString = UserDefaults.standard.string(forKey: "nickname") {
                name = loadedString
            }
            postURL(name: name, comment: descriptionTextField.text ?? "")
        }
        dismiss(animated: false)
    }
}
