import UIKit

class CoursesCell: UITableViewCell {
    static let id = "Cell"

    private let buttonSelected: UIView = {
        let view = UIView()
        return view
    }()

    var titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.textColor = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1)
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping

        return titleLabel
    }()

    var img: UIImageView = {
        var img = UIImageView()
        img.image = UIImage(named: "img1")
        img.contentMode = .scaleAspectFit
        return img
    }()

    var percentLbl: PaddingLabel = {
        var percentLbl = PaddingLabel()
        percentLbl.textColor = .white
        percentLbl.backgroundColor = UIColor(red: 1, green: 0.62, blue: 0.04, alpha: 1)
        percentLbl.font = .systemFont(ofSize: 15, weight: .medium)
        percentLbl.textAlignment = .left
        percentLbl.layer.cornerRadius = 8
        percentLbl.clipsToBounds = true

        return percentLbl
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configureUI()
        self.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        contentView.frame = contentView.frame.inset(by: margins)
        contentView.layer.cornerRadius = 14
    }

    func setup(data: CoursesModel, selected: Bool) {
        titleLabel.text = data.title
        img.image = data.img
        if UserDefaults.standard.string(forKey: "percent") != "0" {
            guard let loadedInt = UserDefaults.standard.string(forKey: "percent") else { return }
            percentLbl.text = "passed".localize() + " \(loadedInt)% "
        } else {
            percentLbl.text = "passed".localize() + " 0%"
        }
        percentLbl.isHidden = false
    }

    func setupMore(data: CoursesModel, selected: Bool) {
        titleLabel.text = data.title
        img.image = data.img
        percentLbl.isHidden = true
    }

    private func configureUI() {
        buttonSelected.isHidden = true
        contentView.addSubviews(buttonSelected, img, titleLabel, percentLbl)

        buttonSelected.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        img.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(14)
            make.leading.equalToSuperview().offset(14)
            make.height.width.equalTo(88)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(img.snp.top).offset(8)
            make.leading.equalTo(img.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(10)
        }

        percentLbl.snp.makeConstraints { make in
            make.top.equalTo(img.snp.centerY).offset(6)
            make.leading.equalTo(img.snp.trailing).offset(16)
        }
    }
}
