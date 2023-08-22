import UIKit

class NewsCell: UICollectionViewCell {
    static let id = "Cell"
    private let titleLabel: UILabel = {
        let pairLabel = UILabel()
        pairLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        pairLabel.numberOfLines = 0
        pairLabel.lineBreakMode = .byWordWrapping
        pairLabel.textAlignment = .left
        pairLabel.textColor = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1)
        pairLabel.translatesAutoresizingMaskIntoConstraints = false

        return pairLabel
    }()

    private let timeLbl: UILabel = {
        let timeLbl = UILabel()
        timeLbl.font = .systemFont(ofSize: 12, weight: .regular)
        timeLbl.textAlignment = .left
        timeLbl.textColor = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1)
        timeLbl.translatesAutoresizingMaskIntoConstraints = false

        return timeLbl
    }()

    private let contentLabel: UILabel = {
        let buySellLabl = UILabel()
        buySellLabl.numberOfLines = 0
        buySellLabl.lineBreakMode = .byWordWrapping
        buySellLabl.font = .systemFont(ofSize: 15, weight: .regular)
        buySellLabl.textAlignment = .left
        buySellLabl.textColor = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1)
        buySellLabl.translatesAutoresizingMaskIntoConstraints = false

        return buySellLabl
    }()

    private let img: UIImageView = {
        let pairImg = UIImageView()
        pairImg.contentMode = .scaleAspectFit
        pairImg.translatesAutoresizingMaskIntoConstraints = false

        return pairImg
    }()

    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        makeConstraints()
        self.contentView.backgroundColor = .white
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }

    func setup(date: NewsModel) {
        titleLabel.text = date.name
        contentLabel.text = date.comment
        let time = date.date?.suffix(8)
        timeLbl.text = "\(time!.prefix(5))"
        img.image = UIImage(named: "logo")
    }

    private func setupViews() {
        contentView.addSubviews(titleLabel, img, timeLbl, contentLabel)
    }

    private func makeConstraints() {
        img.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.height.width.equalTo(40)
        }

        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(img.snp.centerY).offset(-2)
            make.leading.equalTo(img.snp.trailing).offset(16)
            make.trailing.equalToSuperview()
        }

        timeLbl.snp.makeConstraints { make in
            make.top.equalTo(img.snp.centerY).offset(2)
            make.leading.equalTo(img.snp.trailing).offset(16)
            make.trailing.equalToSuperview()
        }

        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(img.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        if let lastSubview = contentView.subviews.last {
            contentView.bottomAnchor.constraint(equalTo: lastSubview.bottomAnchor, constant: 5).isActive = true
        }
    }
}
