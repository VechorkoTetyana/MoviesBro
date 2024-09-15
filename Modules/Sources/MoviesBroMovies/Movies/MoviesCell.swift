import UIKit
import DesignSystem
import SnapKit
import SDWebImage
import MoviesBroCore

class MoviesCell: UITableViewCell {
        
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(profileImageView)
        containerView.addSubview(nameLabel)
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        }
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(40)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with movie: Movie) {
        profileImageView.image = .avatar
        let baseURL = "https://image.tmdb.org/t/p/w500"

        guard let path = movie.posterPath else { return }
        
        let urlString = baseURL + path
        
        if let url = URL(string: urlString) {
            profileImageView.sd_setImage(with: url, placeholderImage: .avatar)
        } else {
                profileImageView.image = .avatar
        }
        
        nameLabel.text = movie.title
        
        func prepareForReuse() {
            super.prepareForReuse()
            
            profileImageView.sd_cancelCurrentImageLoad()
        }
    }
}
