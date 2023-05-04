//
//  ViewController.swift
//  InTheBox
//
//  Created by G on 2023-04-03.
//

import UIKit

final class PlannerViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet private weak var greetingTitle: UILabel!
    @IBOutlet private weak var editAppereanceButton: UIButton!
    @IBOutlet private weak var settingsButton: UIButton!
    @IBOutlet private weak var previousDayButton: UIButton!
    @IBOutlet private weak var nextDayButton: UIButton!
    @IBOutlet private weak var addToDoItemButton: UIButton!
    @IBOutlet private weak var addReminderButton: UIButton!
    @IBOutlet private weak var editJournalEntryButton: UIButton!
    @IBOutlet private weak var journalEntryTextView: UITextView!
    @IBOutlet private weak var greetingImage: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var toDoListStackView: UIStackView!
    
    @IBOutlet weak var reminderStackView: UIStackView!
    private var isJournalEditing: Bool = false
    private var currentDate: Date = Date.now
    private var viewModel: PlannerViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PlannerViewModel()
        setupButtonActions()
        setupGreetingTitle()
        setupDateText()
        setupJournalEntryView()
    }
    
    func setupButtonActions() {
        editAppereanceButton.addTarget(self, action: #selector(editAppereanceButtonTapped), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        previousDayButton.addTarget(self, action: #selector(previousDayButtonTapped), for: .touchUpInside)
        nextDayButton.addTarget(self, action: #selector(nextDayButtonTapped), for: .touchUpInside)
        addToDoItemButton.addTarget(self, action: #selector(addToDoItemButtonTapped), for: .touchUpInside)
        addReminderButton.addTarget(self, action: #selector(addReminderButtonTapped), for: .touchUpInside)
        editJournalEntryButton.addTarget(self, action: #selector(editJournalEntryButtonTapped), for: .touchUpInside)
    }
    
    func setupGreetingTitle() {
        viewModel.setupGreetingTitle()
    }
    
    func setupDateText() {
        viewModel.setCurrentDate(with: Date.now)
    }
    
    func setupJournalEntryView() {
        journalEntryTextView.layer.cornerRadius = 10.0
        journalEntryTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        journalEntryTextView.font = UIFont(name: "SFProRounded-Regular", size: 17)
    }
}

//Objc methods
extension PlannerViewController {
    @objc func checkToDo(button: UIButton) {
        let imgSquare = UIImage(systemName: "square")
        let imgCheckedSquare = UIImage(systemName: "checkmark.square.fill")
        let buttonImage = button.currentImage == imgSquare ? imgCheckedSquare : imgSquare
        button.setImage(buttonImage, for: .normal)
    }
    
    @objc func editAppereanceButtonTapped() {
        
    }
    
    @objc func settingsButtonTapped() {
        
    }
    
    @objc func previousDayButtonTapped() {
        let currentDate = viewModel.currentDate
        viewModel.setCurrentDate(with: currentDate.dayBefore)
        //Retrieve yesterday's data
    }
    
    @objc func nextDayButtonTapped() {
        let currentDate = viewModel.currentDate
        viewModel.setCurrentDate(with: currentDate.dayAfter)
        //Retrieve next day's data
    }
    
    @objc func addToDoItemButtonTapped() {
        let popUpWindow: PopUpWithTextField!
        popUpWindow = PopUpWithTextField(title: "What do you want to do today?", buttonText: "Add To-Do", buttonAction: { [weak self] text in
            guard let self = self else { return }
            
            //Should be done with view model so it can record to the permanent data source
            self.createToDo(with: text)
        })
        self.present(popUpWindow, animated: true, completion: nil)
    }
    
    @objc func addReminderButtonTapped() {
        let popUpWindow = PopUpWithIconSelectionAndTextField(buttonAction: { [weak self] icon, text in
            guard let self = self else { return }
            //Should be done with view model so it can record to the permanent data source
            self.createReminder(with: icon, with: text)
        })
        self.present(popUpWindow, animated: true, completion: nil)
    }
    
    @objc func editJournalEntryButtonTapped() {
        journalEntryTextView.isScrollEnabled = true
        if journalEntryTextView.isFirstResponder {
            if scrollView.contentSize.height > scrollView.frame.size.height {
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
            journalEntryTextView.scrollRangeToVisible(NSRange(location: 0,length: 0))
            editJournalEntryButton.setImage(UIImage(systemName: "pencil"), for: .normal)
            journalEntryTextView.isEditable = false
            journalEntryTextView.layer.borderWidth = 0.0
            journalEntryTextView.resignFirstResponder()

        } else {
            if scrollView.contentSize.height > scrollView.frame.size.height {
                scrollView.setContentOffset(CGPoint(x: 0, y: toDoListStackView.frame.height + reminderStackView.frame.height), animated: true)
            }
            journalEntryTextView.scrollRangeToVisible(journalEntryTextView.selectedRange)
            editJournalEntryButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            journalEntryTextView.isEditable = true
            journalEntryTextView.layer.borderWidth = 2.0
            journalEntryTextView.layer.borderColor = UIColor.gray.cgColor

            journalEntryTextView.becomeFirstResponder()
        }
    }
    
    @objc func openToDoOptions() {
        
    }
}

//Helpers
extension PlannerViewController {
    func createToDo(with text: String) {
        let button = UIButton()
        button.tintColor = .black
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.addTarget(self, action: #selector(checkToDo), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        let textLabel = UILabel()
        textLabel.text  = text
        textLabel.textAlignment = .left
        textLabel.font = UIFont(name: "SFProRounded-Regular", size: 17)
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        
        let optionButton = UIButton()
        optionButton.tintColor = .gray
        optionButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        optionButton.addTarget(self, action: #selector(openToDoOptions), for: .touchUpInside)
        optionButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        optionButton.showsMenuAsPrimaryAction = true
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.addArrangedSubview(button)
        stackView.addArrangedSubview(textLabel)
        stackView.addArrangedSubview(optionButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let delete = UIAction(title: "Delete",
          image: UIImage(systemName: "trash.fill")) { sender in
            stackView.removeFromSuperview()
        }
        
        let edit = UIAction(title: "Edit",
          image: UIImage(systemName: "pencil")) { sender in
            self.editToDo(label: textLabel)
        }
   
        optionButton.menu = UIMenu(title: "", children: [edit, delete])
        
        self.toDoListStackView.addArrangedSubview(stackView)
    }
    
    func editToDo(label: UILabel) {
        let popUpWindow: PopUpWithTextField!
        popUpWindow = PopUpWithTextField(title: "Edit To-Do", buttonText: "Update To-Do", placeholderText: label.text, buttonAction: { text in
            
            //Should be done with view model so it can record to the permanent data source
            label.text = text
        })
        self.present(popUpWindow, animated: true, completion: nil)
    }
    
    func editReminder(iconButton: UIButton, label: UILabel) {
        let popUpWindow = PopUpWithIconSelectionAndTextField(placeholderIcon: iconButton.image(for: .normal), placeholderText: label.text, buttonAction: { icon, text in
            //Should be done with view model so it can record to the permanent data source
            iconButton.setImage(icon, for: .normal)
            label.text = text
        })
        self.present(popUpWindow, animated: true, completion: nil)
    }
    
    func createReminder(with image: UIImage, with text: String) {
        let button = UIButton()
        button.tintColor = .black
        button.setImage(image, for: .normal)
        button.isUserInteractionEnabled = false
        
        let textLabel = UILabel()
        textLabel.text  = text
        textLabel.textAlignment = .left
        textLabel.font = UIFont(name: "SFProRounded-Regular", size: 17)
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        
        let optionButton = UIButton()
        optionButton.tintColor = .gray
        optionButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        optionButton.addTarget(self, action: #selector(openToDoOptions), for: .touchUpInside)
        optionButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        optionButton.showsMenuAsPrimaryAction = true
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = 10
        stackView.addArrangedSubview(button)
        stackView.addArrangedSubview(textLabel)
        stackView.addArrangedSubview(optionButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let delete = UIAction(title: "Delete",
          image: UIImage(systemName: "trash.fill")) { sender in
            stackView.removeFromSuperview()
        }
        
        let edit = UIAction(title: "Edit",
          image: UIImage(systemName: "pencil")) { sender in
            self.editReminder(iconButton: button, label: textLabel)
        }
   
        optionButton.menu = UIMenu(title: "", children: [edit, delete])
        
        self.reminderStackView.addArrangedSubview(stackView)
    }
}

extension PlannerViewController: PlannerViewModelDelegate {
    func handleViewModelOutput(_ output: PlannerViewModelOutput) {
        switch output {
        case .setupGreetingTitle(let title, let image):
            greetingTitle.text = title
            greetingImage.image = image
        case .setupDateLabel(let date):
            dateLabel.text = date
        }
    }
}

