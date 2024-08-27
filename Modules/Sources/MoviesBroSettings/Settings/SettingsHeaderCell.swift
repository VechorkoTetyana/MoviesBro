import DesignSystem
import SnapKit
import MoviesBroCore
import SDWebImage

class SettingsHeaderCell: UITableViewCell {
    
    private weak var containerView: UIView!
    private weak var stackView: UIStackView!
    private weak var profileImageView: UIImageView!
    private weak var nameLbl: UILabel!
    private weak var descriptionLbl: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    func configure(with header: Header) {
//      profileImageView.image = header.image
        if let url = header.imageUrl {
            profileImageView.sd_setImage(with: url)
        }
        nameLbl.text = header.name
        descriptionLbl.text = header.location
    }
    
    private func commonInit() {
        setupUI()
    }
}

extension SettingsHeaderCell {
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        setupContainer()
        setupStackView()
        setupImageView()
        setupLabels()
    }
    
    private func setupContainer() {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        
        contentView.addSubview(view)
        self.containerView = view
        
        view.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    private func setupStackView() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12
        
        containerView.addSubview(stackView)
        
        self.stackView = stackView
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-8)
        }
    }
    
    private func setupImageView() {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true

        imageView.image = UIImage(resource: .avatar)
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(74)
            make.left.equalToSuperview().offset(32)
            make.top.equalToSuperview().offset(14)
            make.bottom.equalToSuperview().offset(-20)

  //          make.width.equalTo(56)
  //          make.height.equalTo(56)
        }
        
        self.profileImageView = imageView
    }
    
    private func setupLabels() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(24)
            make.bottom.equalToSuperview().offset(-24)
            make.right.equalToSuperview().offset(-32)
        }
        
        let nameLbl = setupNameLbl()
        stackView.addArrangedSubview(nameLbl)
        self.nameLbl = nameLbl
        
        let descriptionLbl = setupDescriptionLbl()
        stackView.addArrangedSubview(descriptionLbl)
        self.descriptionLbl = descriptionLbl

        self.stackView.addArrangedSubview(stackView)
    }
    
    private func setupNameLbl() -> UILabel {
        let nameLbl = UILabel()
        nameLbl.font = .titleMed26
        nameLbl.textColor = .black
        return nameLbl
    }
    
    private func setupDescriptionLbl() -> UILabel {
        let descriptionLbl = UILabel()
        descriptionLbl.font = .subtitle16
        descriptionLbl.textColor = .gray
        return descriptionLbl
    }
    
   /* private func setupIndicator() {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(resource: .indicator)
        
        stackView.addArrangedSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
    }*/
}
