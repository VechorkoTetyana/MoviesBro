import UIKit
import DesignSystem
import MoviesBroCore
import SnapKit

enum ProfileStrings: String {
    case title = "Profile"
    case save = "Save"
}

public final class ProfileEditViewController: UIViewController {

    weak var tableView: UITableView!
    weak var saveButtonContainer: UIView!
    
    var viewModel: ProfileEditViewModel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureTableView()
        setupHideKeyBoardGesture()
        subscribeToKeyboard()
        
        navigationItem.setMoviesBroTitle(ProfileStrings.title.rawValue)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
   private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
//      tableView.contentInsetAdjustmentBehavior = .never
       
        tableView.register(ProfileEditPictureCell.self, forCellReuseIdentifier: ProfileEditPictureCell.identifier)
        tableView.register(ProfileTextFieldCell.self, forCellReuseIdentifier: ProfileTextFieldCell.identifier)
        tableView.register(ButtonCell.self, forCellReuseIdentifier: ButtonCell.identifier)
    }
}

extension ProfileEditViewController {
    private func setupUI() {
        view.backgroundColor = .white
        setupTableView()
        setupsaveButton()
    }
 
    private func setupsaveButton() {
        let container = UIView()
        
        let label = UILabel()
        label.font = .cardDetailTitle22
        label.textColor = .black
        label.text = ProfileStrings.save.rawValue
        container.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        let button = UIButton()
        button.setImage(UIImage(resource: .matches), for: .normal)
        
        button.layer.figmaShadow(
            offset: CGPoint(x: 0, y: 10),
            blur: 55,
            color: .gray,
            opacity: 0.55)
        
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(didTapSaveBtn), for: .touchUpInside)
        
        container.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.width.equalTo(44)
            make.height.equalTo(44)
            
            make.left.equalTo(label.snp.right).offset(16)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        view.addSubview(container)
        
        container.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.right.equalToSuperview().offset(-35)
        }
        
        self.saveButtonContainer = container
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapSaveBtn))
//        container.addGestureRecognizer(tap)
        print("UITapGestureRecognizer added")
    }
    
    @objc
    private func didTapSaveBtn() {
        print("Save button tapped")
        Task { [weak self] in
            do {
                try await self?.viewModel.save()
                self?.navigationController?.popViewController(animated: true)
                
            } catch {
                self?.showError(error.localizedDescription)
            }
        }
    }
    
    private func setupTableView() {
        let tableView = UITableView()
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.tableView = tableView
        tableView.contentInset = UIEdgeInsets(top: 28, left: 0, bottom: 120, right: 0)
    }
}

extension ProfileEditViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.rows.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = viewModel.rows[indexPath.row]
        
        switch row {
        case .profilePicture:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileEditPictureCell.identifier, for: indexPath) as? ProfileEditPictureCell
            else { return UITableViewCell() }
            
            if let selectedImage = viewModel.selectedImage {
                cell.configure(with: selectedImage)
            } else if let url = viewModel.profilePictureUrl {
                cell.configure(with: url)
            }
            
            return cell
            
        case .textField(let type):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTextFieldCell.identifier, for: indexPath) as? ProfileTextFieldCell
            else { return UITableViewCell() }
                        
            cell.configure(with: viewModel.modelForTextFieldRow(type))
            cell.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            
            return cell
        }
    }
}

extension ProfileEditViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case .profilePicture = viewModel.rows[indexPath.row] else { return }
        
            didTapProfilePicture()
        }
    }

extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func didTapProfilePicture() {
        let alert = UIAlertController(title: "Select option", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { [weak self] _ in
            self?.showImagePicker(with: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
            self?.showImagePicker(with: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showImagePicker(with sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            viewModel.selectedImage = selectedImage
            
            tableView.reloadRows(at: [
                IndexPath(row: 0, section: 0)
            ], with: .automatic)
        }
        picker.dismiss(animated: true)
    }
}

extension ProfileEditViewController: UITextFieldDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = viewModel.rows[indexPath.row]

        switch row {

        case .profilePicture:
            return 164

        case .textField:
            return 96
        }
    }
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        guard
            let indexPath = tableView.indexPathForRow(
            at: textField.convert(
                textField.bounds.origin,
                to: tableView
            ))
        else { return }
        
        let row = viewModel.rows[indexPath.row]
        
        guard case let .textField(type) = row else { return }
        
        switch type {
        case .name:
            viewModel.fullName = textField.text ?? ""
        case .location:
            viewModel.location = textField.text ?? ""
        }
                
        let cell = tableView.cellForRow(at: indexPath) as? ProfileTextFieldCell
        cell?.configure(with: viewModel.modelForTextFieldRow(type))
    }
}

// MARK: Keyboard

extension ProfileEditViewController {
    private func setupHideKeyBoardGesture() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyBoard)
        )
        tap.cancelsTouchesInView = false
       
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyBoard() {
        view.endEditing(true)
    }
    
    private func subscribeToKeyboard() {
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
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
        
        let isKeyboardHidden = endFrame.origin.y >= UIScreen.main.bounds.size.height
        
        let bottomMargin = isKeyboardHidden ? 0 : -endFrame.height - 16
        
        tableView.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(bottomMargin)
        }
        
        saveButtonContainer.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(bottomMargin - 20 + (isKeyboardHidden ? 0 : view.safeAreaInsets.bottom ))
        }
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
}
