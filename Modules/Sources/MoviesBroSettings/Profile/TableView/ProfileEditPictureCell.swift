import UIKit
import SnapKit
import SDWebImage

class ProfileEditPictureCell: UITableViewCell {
    
    private weak var profileImageView: UIImageView!
    private weak var setNewAvatarBtn: UIButton!
    
    var didTap: (()->())?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    func configure(with image: UIImage) {
        profileImageView.image = image
    }
    
    func configure(with url: URL) {
        profileImageView.sd_setImage(with: url)
    }
    
    private func commonInit() {
        setupUI()
    }
}

extension ProfileEditPictureCell {
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        setupProfileImage()
        
    }
    
    private func setupProfileImage() {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 48
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(resource: .avatar)
        
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            make.size.equalTo(96)
        }
        
        self.profileImageView = imageView
    }
}
