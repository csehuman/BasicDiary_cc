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
    }
    
    @objc func tapStarButton(_ sender: UIBarButtonItem) {
        let isStar = diary?.isStar ?? false
        diary?.isStar = !isStar
        starButton?.image = (diary?.isStar ?? false) ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        guard let diary = diary else { return }
        DataManager.shared.starDiary(diary: diary)
    }
    
    @IBAction func tapEditButton(_ sender: UIButton) {
        
    }
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        guard let diary = diary else { return }
        DataManager.shared.deleteDiary(diary: diary)
        navigationController?.popViewController(animated: true)
    }
}
