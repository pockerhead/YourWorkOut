//
//  ExerciseCell.swift
//  YourWorkout
//
//  Created by Артём Балашов on 25.02.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit

class ExerciseCell: UITableViewCell {
    
    @IBOutlet weak var openButton: MyButton!
    @IBOutlet weak var addAproachButton: MyMDCRaisedButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var indexLabel: UILabel!
    public var didEditExercise : ((Exercise) -> ())?
    public var didEditApproach : ((Exercise) -> ())?

    @IBOutlet weak var viewBackground: UIView!
    

    var index: Int = 0
    var exercise : Exercise?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

       
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func initUI(){
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.isScrollEnabled = false
        let approachNib = UINib(nibName: "ApproachCell", bundle: nil)
        
        self.tableView.register(approachNib, forCellReuseIdentifier: "ApproachCell")
        self.addAproachButton.setBackgroundColor(NewWaveColors.blueColor, for: .normal)
        self.addAproachButton.setTitleColor(UIColor.white, for: .normal)
        self.addAproachButton.sizeToFit()
        
        self.tableView.reloadData()
        
        self.addAproachButton.didTouchUpInside = { button in
            let approach = Approach.init(repeats: 0, weigth: 0)
            if let exercise = self.exercise{
                exercise.approaches.append(approach)
                self.tableView.performBatchUpdates({
                    let indexPath = IndexPath(row: exercise.approaches.count - 1, section: 0)
                    self.tableView.insertRows(at:[indexPath], with: .fade)
                }, completion: { compl in
                    self.didEditExercise?(exercise)
                })
            }
            
        }
    }
    
}

extension ExerciseCell: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "ApproachCell") as? ApproachCell {
            return cell.frame.size.height
        }
        return 40
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exercise?.approaches.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "ApproachCell") as? ApproachCell {
            if let exercise = self.exercise{
                if indexPath.row < exercise.approaches.count{
                    let approachItem = exercise.approaches[indexPath.row]
                    cell.selectionStyle = .none
                    cell.weightTextField.text = "\(approachItem.weigth)"
                    cell.repeatsTextfield.text = "\(approachItem.repeats)"
                    cell.approach = approachItem
                }
            }
            cell.repeatsDidChanged = { approach in
                if let exercise = self.exercise{
                    exercise.approaches[indexPath.row] = approach
                    self.didEditApproach?(exercise)
                }
            }
            cell.weightDidChanged = { approach in
                if let exercise = self.exercise{
                    exercise.approaches[indexPath.row] = approach
                    self.didEditApproach?(exercise)
                }
            }
            return cell

            
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
            return UITableViewCellEditingStyle.delete

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
       return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            DispatchQueue.main.async {
                if let exercise = self.exercise{
                    exercise.approaches.remove(at: indexPath.row)
                    
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.tableView.reloadSections(IndexSet.init(integer: indexPath.section), with: .automatic)
                    self.tableView.endUpdates()
                    
                    self.didEditExercise?(exercise)
                }
                
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let button = UITableViewRowAction(style: .default, title: "Удалить") { (action, indexPath) in
            DispatchQueue.main.async {
                
                if let exercise = self.exercise{
                    exercise.approaches.remove(at: indexPath.row)
                    
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.tableView.reloadSections(IndexSet.init(integer: indexPath.section), with: .automatic)
                    self.tableView.endUpdates()
                    
                    self.didEditExercise?(exercise)
                }
                
                
            }
        }
        button.backgroundColor = NewWaveColors.orangeColor
        return [button]
    }
}
