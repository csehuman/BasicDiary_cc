//
//  DiaryComposeViewController.swift
//  BasicDiaryApp
//
//  Created by Paul Lee on 2022/09/19.
//

import UIKit

class DiaryComposeViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var inEditingMode: Bool = false
    var diaryToEdit: Diary?
    
    var diaryDate: Date?
    var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTitleTextField()
        setUpContentsView()
        setUpDateTextField()
        
        addButton.isEnabled = false
    }
    
    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text else { return }
        guard let contents = contentsTextView.text else { return }
        guard let date = diaryDate else { return }
        
        if inEditingMode {
            guard let diaryToEdit = diaryToEdit else { return }
            let editedDiary = Diary(uuidString: diaryToEdit.uuidString, title: title, contents: contents, createdDate: date, isStar: diaryToEdit.isStar)
            DataManager.shared.updateDiary(diary: editedDiary, uuidString: diaryToEdit.uuidString)
        } else {
            let uuidString = UUID().uuidString
            let newDiary = Diary(uuidString: uuidString, title: title, contents: contents, createdDate: date, isStar: false)
            DataManager.shared.addDiary(diary: newDiary)
        }

        navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension DiaryComposeViewController {
    private func setUpTitleTextField() {
        titleTextField.addTarget(self, action: #selector(validateField), for: .editingChanged)
    }
    
    private func setUpContentsView() {
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        contentsTextView.layer.borderColor = borderColor.cgColor
        contentsTextView.layer.borderWidth = 0.5
        contentsTextView.layer.cornerRadius = 5.0
        contentsTextView.delegate = self
    }
    
    private func setUpDateTextField() {
        diaryDate = Date()
        dateTextField.text = diaryDate?.longDateString
        dateTextField.delegate = self
        
        datePicker.datePickerMode = .date
        datePicker.date = Date()
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(datePickerDidChange(_:)), for: .valueChanged)
        
        dateTextField.inputView = datePicker
    }
    
    @objc func datePickerDidChange(_ datePicker: UIDatePicker) {
        diaryDate = datePicker.date
        dateTextField.text = diaryDate?.longDateString
        validateField()
    }
    
    @objc private func validateField() {
        addButton.isEnabled = !(titleTextField.text?.isEmpty ?? true) && !(dateTextField.text?.isEmpty ?? true) && !contentsTextView.text.isEmpty
    }
}

extension DiaryComposeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

extension DiaryComposeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        validateField()
    }
}
