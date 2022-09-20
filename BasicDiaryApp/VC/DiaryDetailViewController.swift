//
//  DiaryDetailViewController.swift
//  BasicDiaryApp
//
//  Created by Paul Lee on 2022/09/19.
//

import UIKit

class DiaryDetailViewController: UIViewController {
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var dateTextLabel: UILabel!
    @IBOutlet weak var contentsTextView: UITextView!
    
    var starButton: UIBarButtonItem?
    
    var diary: Diary?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let diary = diary else { return }
        titleTextLabel.text = diary.title
        contentsTextView.text = diary.contents
        dateTextLabel.text = diary.createdDate.longDateString
        
        starButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(tapStarButton(_:)))
        starButton?.image = diary.isStar ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        starButton?.tintColor = .orange
        navigationItem.rightBarButtonItem = starButton
        
        var token = NotificationCenter.default.addObserver(forName: NSNotification.Name.DiaryEdited, object: nil, queue: .main) { [weak self] noti in
            guard let newDiary = noti.object as? Diary else { return }
            if self?.diary?.uuidString == newDiary.uuidString {
                self?.diary = newDiary
                self?.titleTextLabel.text = newDiary.title
                self?.contentsTextView.text = newDiary.contents
                self?.dateTextLabel.text = newDiary.createdDate.longDateString
                self?.starButton?.image = newDiary.isStar ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
            }
        }
        tokens.append(token)
        
        token = NotificationCenter.default.addObserver(forName: NSNotification.Name.DiaryDeleted, object: nil, queue: .main, using: { [weak self] noti in
            self?.isDeletedDiary = true
        })
    }
    
    deinit {
        for token in tokens {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    @objc func tapStarButton(_ sender: UIBarButtonItem) {
        let isStar = diary?.isStar ?? false
        diary?.isStar = !isStar
        starButton?.image = (diary?.isStar ?? false) ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        guard let diary = diary else { return }
        DataManager.shared.starDiary(diary: diary)
    }
    
    @IBAction func tapEditButton(_ sender: UIButton) {
        guard let diary = diary else { return }
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "DiaryComposeViewController") as? DiaryComposeViewController else { return }
        vc.inEditingMode = true
        vc.diaryToEdit = diary
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        guard let diary = diary else { return }
        DataManager.shared.deleteDiary(diary: diary)
        navigationController?.popViewController(animated: true)
    }
}
