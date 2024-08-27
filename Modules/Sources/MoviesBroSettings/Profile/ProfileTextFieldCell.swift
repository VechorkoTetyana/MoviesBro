import UIKit
import DesignSystem
import SnapKit

public final class ProfileTextFieldCell: UITableViewCell {
    
    struct Model {
        let icon: UIImage
        let placeholderText: String
        let text: String?
        let isValid: Bool

        init(
            icon: UIImage,
            placeholderText: String,
            text: String?,
            isValid: Bool
        ) {
            self.icon = icon
            self.placeholderText = placeholderText
            self.text = text
            self.isValid = isValid
        }
    }

    var textField: UITextField!
    private var iconImageView: UIImageView!
    private var checkMarkImageView: UIImageView!
    private var containerView: UIView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    private func commonInit() {
        setupUI()
    }
    
    func configure(with model: Model) {
        textField.placeholder = model.placeholderText
        textField.text = model.text
        iconImageView.image = model.icon
        configureCheckMark(for: model)
    }
    
    private func configureCheckMark(for model: Model) {
//        checkMarkImageView.image = checkMarkImage(for: model)
        
        if model.isValid {
            setConfigureCheckMarkShadowEnabled()
        } else {
            checkMarkImageView.layer.shadowOpacity = 0
        }
    }
    
    private func setConfigureCheckMarkShadowEnabled() {
        checkMarkImageView.layer.figmaShadow(
            offset: CGPoint(x: 0, y: 10),
            blur: 35,
            color: .gray,
            opacity: 0.65
        )
    }
}

extension ProfileTextFieldCell {
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        selectionStyle = .none
        
        layer.masksToBounds = false
        clipsToBounds = false
        contentView.layer.masksToBounds = false
        contentView.clipsToBounds = false
        
        setupContainer()
        setupIcon()
        setupCheckMark()
        setupTextField()
    }
    
    private func setupContainer() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 15
        containerView.layer.masksToBounds = false
        
        containerView.layer.figmaShadow(
            offset: CGPoint(x: 0, y: 4),
            blur: 75,
            color: .gray,
            opacity: 0.20
        )
                
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.height.equalTo(61)
            make.top.equalToSuperview().offset(24)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(35)
            make.right.equalToSuperview().offset(-35)

        }
        self.containerView = containerView
    }
    
    private func setupIcon() {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        containerView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        iconImageView = imageView
    }
    
    private func setupTextField() {
        let textField = UITextField()
        textField.textColor = .black
        textField.font = .subtitle18
        
        containerView.addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(13)
            make.centerY.equalToSuperview()
            make.right.equalTo(checkMarkImageView.snp.left).offset(-18)
        }
        self.textField = textField
    }
    
    private func setupCheckMark() {
        let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 12
            imageView.layer.masksToBounds = true
            imageView.backgroundColor = .darkRed
            
            let checkImageView = UIImageView(image: UIImage.galka)
            checkImageView.contentMode = .center
            
            imageView.addSubview(checkImageView)
            containerView.addSubview(imageView)
            
            imageView.snp.makeConstraints { make in
                make.size.equalTo(24)
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-19)
            }
            
            checkImageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }

            self.checkMarkImageView = imageView
    }
}
