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
    
    func configure(with viewModel: SettingsViewModel.Header) {
        profileImageView.sd_setImage(with: viewModel.imageUrl)
        nameLbl.text = viewModel.name
        descriptionLbl.text = viewModel.description
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
        setupIndicator()
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
        imageView.image = UIImage(resource: .avatar)
        imageView.contentMode = .scaleAspectFit
        
        imageView.layer.cornerRadius = 28
        imageView.layer.masksToBounds = true
        
        stackView.addArrangedSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(56)
            make.height.equalTo(56)
        }
        
        self.profileImageView = imageView
    }
    
    private func setupLabels() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        
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
    
    private func setupIndicator() {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .indicator
        
        stackView.addArrangedSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
    }
}