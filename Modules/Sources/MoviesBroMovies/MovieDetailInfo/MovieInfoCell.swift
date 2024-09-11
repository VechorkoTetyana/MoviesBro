import UIKit

class MovieInfoCell: UITableViewCell {

    private let movieImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 18 // Assuming a 96x96 image size
        return iv
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style, 
            reuseIdentifier: reuseIdentifier
        )
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .white
        contentView.backgroundColor = .white
        
        contentView.addSubview(movieImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)

        movieImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(400)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(movieImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }

    func configure(with movie: Movie) {
        movieImageView.image = .avatar
        nameLabel.text = movie.title
        let baseURL = "https://image.tmdb.org/t/p/w500"
        
        guard let path = movie.posterPath else { return }
        
        let urlString = baseURL + path
        if let url = URL(string: urlString) {
            print("Image URL: \(url)")
            movieImageView.sd_setImage(with: url)
        } else {
            print("Invalid URL")
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        movieImageView.sd_cancelCurrentImageLoad()
    }
}
