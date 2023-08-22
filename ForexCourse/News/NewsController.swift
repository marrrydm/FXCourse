import UIKit

class NewsViewController: UIViewController {
    private let labelTitle: UILabel = {
        let labelTitle = UILabel()
        labelTitle.textColor = .black
        labelTitle.text = "Newsline".localize()
        labelTitle.font = .systemFont(ofSize: 34, weight: .bold)
        labelTitle.numberOfLines = 0
        labelTitle.textAlignment = .left
        labelTitle.lineBreakMode = .byWordWrapping

        return labelTitle
    }()

    private lazy var view1: UIView = {
        let viewTest = UIView()
        viewTest.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1)
        viewTest.layer.cornerRadius = 14
        viewTest.contentMode = .center
        viewTest.isUserInteractionEnabled = true
        viewTest.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(newPost)))

        return viewTest
    }()

    private let postLbl1: UILabel = {
        let labelTitle = UILabel()
        labelTitle.textColor = .black
        labelTitle.font = .systemFont(ofSize: 13, weight: .regular)
        labelTitle.textAlignment = .left
        labelTitle.lineBreakMode = .byWordWrapping
        labelTitle.numberOfLines = 0
        labelTitle.text = "New post".localize()

        return labelTitle
    }()

    private var postImg: UIImageView = {
        var personImg = UIImageView()
        personImg.contentMode = .scaleAspectFit
        personImg.isUserInteractionEnabled = true
        personImg.image = UIImage(named: "postImg")

        return personImg
    }()

    private var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.size.width
        layout.estimatedItemSize = CGSize(width: width, height: 10)
        return layout
    }()


    private lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.id)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false

        return collectionView
    }()

    private var activityIndicator: UIActivityIndicatorView = {
        var activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.startAnimating()
        return activityIndicator
    }()

    private var newsCells = [NewsModel]()
    private var newsCells2 = [NewsModel]()
    private var topics = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getNews()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        setupViews()
        makeConstraints()

        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now()) { [self] in
            getNews()
        }
    }
    
    private func setupViews() {
        view.addSubviews(labelTitle, collectionView, activityIndicator, view1)
        view1.addSubviews(postLbl1, postImg)
    }

    private func makeConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view1.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-5)
        }

        labelTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.leading.trailing.equalToSuperview().inset(17)
        }

        view1.snp.makeConstraints { make in
            make.top.equalTo(labelTitle.snp.bottom).offset(15)
            make.trailing.leading.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }

        postLbl1.snp.makeConstraints { make in
            make.centerY.equalTo(postImg.snp.centerY)
            make.leading.equalTo(postImg.snp.trailing).offset(8)
        }

        postImg.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-32)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(28)
        }

        activityIndicator.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
    }
}

extension NewsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsCells2.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        layout.estimatedItemSize = CGSize(width: view.bounds.size.width, height: 10)
        super.traitCollectionDidChange(previousTraitCollection)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        layout.estimatedItemSize = CGSize(width: view.bounds.size.width, height: 10)
        layout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.id, for: indexPath) as! NewsCell
        cell.setup(date: newsCells2[indexPath.row])
        return cell
    }
}

extension NewsViewController {
    @objc private func newPost() {
        let vc = PostController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
}

extension NewsViewController {
    private func getNews() {
        let url = "http://terms.fx-courses.com/post/comment/list"
        if let url = URL(string: url) {
            URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                guard let data = data else { return }
                do {
                    let data_new = try JSONDecoder().decode([NewsModel].self, from: data)
                    self?.newsCells = data_new
                    self?.newsCells2 = [NewsModel]((self?.newsCells.reversed())!)
                    DispatchQueue.main.async { [self] in
                        self?.activityIndicator.stopAnimating()
                        self?.collectionView.reloadData()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }.resume()
        }
    }
}
