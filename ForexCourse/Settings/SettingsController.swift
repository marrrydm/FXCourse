import AVFoundation
import Photos
import UIKit

class SettingsController: UIViewController {
    private let titleLabel: UILabel = {
        let labelTitle = UILabel()
        labelTitle.textColor = .black
        labelTitle.text = "Edit Profile".localize()
        labelTitle.font = .systemFont(ofSize: 17, weight: .semibold)
        labelTitle.textAlignment = .center

        return labelTitle
    }()

    private lazy var btnEdit: UIButton = {
        var btn = UIButton()
        btn.backgroundColor = .clear
        btn.setTitle("Edit".localize(), for: .normal)
        btn.setTitleColor(UIColor(red: 0.25, green: 0.61, blue: 1, alpha: 1), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        btn.addTarget(self, action: #selector(changeInfo), for: .touchUpInside)

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

    private var img: UIImageView = {
        var img = UIImageView()
        img.image = UIImage(named: "imgProfile")
        img.contentMode = .scaleToFill
        img.clipsToBounds = true

        return img
    }()

    private lazy var changeBtn: UIButton = {
        var btn = UIButton()
        btn.backgroundColor = .clear
        btn.setTitle("Change Profile Photo".localize(), for: .normal)
        btn.setTitleColor(UIColor(red: 0.25, green: 0.61, blue: 1, alpha: 1), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        btn.addTarget(self, action: #selector(changePhoto), for: .touchUpInside)

        return btn
    }()

    private let line: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(red: 0.24, green: 0.24, blue: 0.26, alpha: 1)

        return line
    }()

    private let nicknameTextField: TextField = {
        let nicknameTextField = TextField()
        nicknameTextField.backgroundColor = .clear
        nicknameTextField.layer.borderWidth = 0.5
        nicknameTextField.layer.borderColor = UIColor(red: 0.24, green: 0.24, blue: 0.26, alpha: 1).cgColor
        nicknameTextField.placeholder = "Nickname".localize()
        nicknameTextField.layer.cornerRadius = 5
        nicknameTextField.textColor = UIColor(red: 0.24, green: 0.24, blue: 0.26, alpha: 1)
        nicknameTextField.font = .systemFont(ofSize: 14, weight: .regular)
        nicknameTextField.textAlignment = .left
        nicknameTextField.contentHorizontalAlignment = .left
        nicknameTextField.isUserInteractionEnabled = false
        return nicknameTextField
    }()

    private let descriptionTextField: TextField = {
        let nicknameTextField = TextField()
        nicknameTextField.backgroundColor = .clear
        nicknameTextField.layer.borderWidth = 0.5
        nicknameTextField.layer.borderColor = UIColor(red: 0.24, green: 0.24, blue: 0.26, alpha: 1).cgColor
        nicknameTextField.placeholder = "Description".localize()
        nicknameTextField.layer.cornerRadius = 5
        nicknameTextField.textColor = UIColor(red: 0.24, green: 0.24, blue: 0.26, alpha: 1)
        nicknameTextField.font = .systemFont(ofSize: 14, weight: .regular)
        nicknameTextField.textAlignment = .left
        nicknameTextField.isUserInteractionEnabled = false
        nicknameTextField.contentHorizontalAlignment = .left
        return nicknameTextField
    }()

    private var isChange = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let data = UserDefaults.standard.data(forKey: "img") else { return }
        let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
        img.image = UIImage(data: decoded)

        img.layer.cornerRadius = img.frame.size.width / 2
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        img.layer.cornerRadius = img.frame.size.width / 2
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubviews(titleLabel, btnEdit, btnCancel, img, changeBtn, line, nicknameTextField, descriptionTextField)
        btnCancel.isHidden = true

        addDoneButtonOnKeyboardTextField()

        if let loadedString = UserDefaults.standard.string(forKey: "nickname") {
            nicknameTextField.text = loadedString
        } else {
            let random = Int.random(in: 100000...999999)
            UserDefaults.standard.set("User_\(random)", forKey: "nickname")
            nicknameTextField.text = "User_\(random)"
        }

        if let loadedString = UserDefaults.standard.string(forKey: "description") {
            descriptionTextField.text = loadedString
        }

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

        img.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(26)
            make.height.width.equalTo(96)
            make.centerX.equalToSuperview()
        }

        changeBtn.snp.makeConstraints { make in
            make.top.equalTo(img.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        line.snp.makeConstraints { make in
            make.top.equalTo(changeBtn.snp.bottom).offset(14)
            make.height.equalTo(0.33)
            make.leading.trailing.equalToSuperview()
        }

        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(14)
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        descriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(12)
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        img.layer.cornerRadius = img.frame.size.width / 2
    }
}

extension SettingsController {
    @objc private func changeInfo() {
        isChange = !isChange
        switch isChange {
        case true:
            btnCancel.isHidden = false
            btnEdit.setTitle("Done".localize(), for: .normal)
            nicknameTextField.isUserInteractionEnabled = true
            descriptionTextField.isUserInteractionEnabled = true

            UserDefaults.standard.set(nicknameTextField.text, forKey: "nickname")
            UserDefaults.standard.set(descriptionTextField.text, forKey: "description")
        case false:
            btnCancel.isHidden = true
            btnEdit.setTitle("Edit".localize(), for: .normal)
            nicknameTextField.isUserInteractionEnabled = false
            descriptionTextField.isUserInteractionEnabled = false

            UserDefaults.standard.set(nicknameTextField.text, forKey: "nickname")
            UserDefaults.standard.set(descriptionTextField.text, forKey: "description")
        }
    }

    func addDoneButtonOnKeyboardTextField() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done".localize(), style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        nicknameTextField.inputAccessoryView = doneToolbar
        descriptionTextField.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction() {
        UserDefaults.standard.set(nicknameTextField.text, forKey: "nickname")
        UserDefaults.standard.set(descriptionTextField.text, forKey: "description")
        nicknameTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
    }

    @objc private func cancelAction() {
        changeInfo()
    }

    @objc private func changePhoto() {
        PHPhotoLibrary.execute(controller: self, onAccessHasBeenGranted: {
            DispatchQueue.main.async {
                let provider = CameraProvider(delegate: self)
                let picker = try! provider.getImagePicker(source: .photoLibrary)
                self.present(picker, animated: true)
            }
        })
    }
}

extension SettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = (info[UIImagePickerController.InfoKey.editedImage] as? UIImage ??
            info[UIImagePickerController.InfoKey.originalImage] as? UIImage)

        picker.dismiss(animated: true, completion: nil)
        img.image = image
        img.layer.cornerRadius = img.frame.size.width / 2

        guard let data = image?.jpegData(compressionQuality: 0.5) else { return }
            let encoded = try! PropertyListEncoder().encode(data)
            UserDefaults.standard.set(encoded, forKey: "img")
    }
}
