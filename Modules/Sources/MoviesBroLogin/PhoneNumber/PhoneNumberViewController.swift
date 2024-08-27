import Foundation
import UIKit
import DesignSystem
import MoviesBroAuthentication
import SnapKit
import Swinject
import PhoneNumberKit

enum PhoneNumberText: String {
    case title = "Can I get those digits?"
    case subtitle = "Enter your phone number below to create your free account."
    case continueButton = "Continue"
}

public class PhoneNumberViewController: UIViewController {
    
    private weak var stackView: UIStackView!
    private weak var textField: PhoneNumberTextField!
    private weak var continueBtn: UIButton!
    
    public var viewModel: PhoneNumberViewModel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureKeyboard()
        subscribeToTextChange()
        textFieldDidChange()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func subscribeToTextChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange), name: UITextField.textDidChangeNotification, object: textField)
    }
}

extension PhoneNumberViewController {
    
    private func setupUI() {
        view.backgroundColor = .white
        
        setupStackView()
        setupTitle()
        setupSubtitle()
        setupTextField()
        setupContinueButton()
    }
    
    private func setupStackView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 32
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(48)
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
        }
        
        self.stackView = stackView
    }
    
    private func setupTitle() {
        let label = UILabel()
        label.textColor = .black
        label.text = PhoneNumberText.title.rawValue
        label.font = .titleBig48
        label.numberOfLines = 0
        
        stackView.addArrangedSubview(label)
    }
    
    private func setupSubtitle() {
        let label = UILabel()
        label.textColor = .brown
        label.text = PhoneNumberText.subtitle.rawValue
        label.font = .subtitle16
        label.numberOfLines = 0
        
        stackView.addArrangedSubview(label)
    }
    
    private func setupTextField() {
        let textFieldBackgroundView = UIView()
        textFieldBackgroundView.backgroundColor = .white
        textFieldBackgroundView.layer.cornerRadius = 6
        textFieldBackgroundView.layer.masksToBounds = false
        
        stackView.addArrangedSubview(textFieldBackgroundView)
        
        textFieldBackgroundView.snp.makeConstraints{ make in
            make.width.equalToSuperview()
            make.height.equalTo(55)
        }
        
        view.layoutIfNeeded()
        
//        textFieldBackgroundView.layer.borderColor = .init(gray: CGFloat., alpha: 1)
        textFieldBackgroundView.layer.borderWidth = 1
        textFieldBackgroundView.layer.shadowColor = UIColor.black.withAlphaComponent(0.07).cgColor
        textFieldBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 7)
        textFieldBackgroundView.layer.shadowRadius = 64
        textFieldBackgroundView.layer.shadowPath = UIBezierPath(roundedRect: textFieldBackgroundView.bounds, cornerRadius: textFieldBackgroundView.layer.cornerRadius).cgPath
        textFieldBackgroundView.layer.shadowOpacity = 1
        
        let textField = PhoneNumberTextField(
            insets: UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8),
            clearButtonPadding: 0)
        
        //        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.withFlag = true
        textField.font = .cardDetailTitle22
        textField.textColor = .black
        textField.withExamplePlaceholder = true
        textField.attributedPlaceholder = NSAttributedString(string: "Enter phone number")
        textFieldBackgroundView.addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        self.textField = textField
    }
    
    private func setupContinueButton() {
        let button = UIButton()
        button.setTitle(PhoneNumberText.continueButton.rawValue, for: .normal)
        button.backgroundColor = UIColor.darkRed
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        
        button.isEnabled = false
        button.alpha = 0.5
        
        button.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        
        view.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.height.equalTo(58)
            make.width.equalTo(306)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
        }
        
        view.layoutIfNeeded()
        button.styleMoviesBro()

         self.continueBtn = button
            
    }
  /*
    @objc func didTapContinueBtn() {
        
        viewModel.requestOTP(with: <#T##String#>)
        
        let otpVC = OTPViewController()
        navigationController?.pushViewController(otpVC, animated: true)
    }*/
}

extension PhoneNumberViewController {

private func configureKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

@objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
    
    let animationCurveRawNumber = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSNumber
    let animationCurveRaw = animationCurveRawNumber?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
    let animationCurve = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        let isKeyboardHidden = endFrame.origin.y <= UIScreen.main.bounds.size.height
        
        // if keyboard is hidden
    
    let topMargin = isKeyboardHidden ? -40 : -endFrame.height + view.safeAreaInsets.bottom - 16
        
    continueBtn.snp.updateConstraints { make in
        make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(topMargin)
    }
    
    UIView.animate(withDuration: duration, delay: 0, options: animationCurve) {
            self.view.layoutIfNeeded()
        }
    }
}

extension PhoneNumberViewController {
    
    @objc func didTapContinue() {
                
        guard
            textField.isValidNumber,
            let phoneNumber = textField.text
        else { return }
        
        Task { [weak self] in
            do {
                try await self?.viewModel.requestOTP(with: phoneNumber)
            } catch {
                self?.showError(error.localizedDescription)
            }
        }
    }
    
/*    private func presentOTP() {
        let viewController = OTPViewController()
        viewController.viewModel = OTPViewModel(container: viewModel.container)
        navigationController?.pushViewController(viewController, animated: true)
    }
 */
}

extension PhoneNumberViewController {
    @objc func textFieldDidChange() {
        print("Text Field Did Change!")
        let isPhoneNumberValid = textField.isValidNumber
        continueBtn.isEnabled = isPhoneNumberValid

//        continueBtn.isEnabled = textField.isValidNumber
        continueBtn.alpha = isPhoneNumberValid ? 1.0 : 0.25
    }
}

/*
extension UIViewController {
    func showError(_ error: String) {
           let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Ok", style: .default))
           self.present(alert, animated: true)
       }
}
*/
