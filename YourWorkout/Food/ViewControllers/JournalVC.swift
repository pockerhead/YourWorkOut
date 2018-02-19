//
//  JournalVC.swift
//  YourWorkout
//
//  Created by Артём Балашов on 16.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit
import CVCalendar

class JournalVC: UIViewController {

    @IBOutlet weak var calendarMenuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    
    var selectedDate = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.title = getMonthName()
        self.tabBarController?.tabBar.isHidden = false

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calendarMenuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL YYYY"
        let strMonth = dateFormatter.string(from: selectedDate)
        return strMonth.capitalized
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailsVC = segue.destination as! FoodTodayVC
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = formatter.string(from: selectedDate)
        detailsVC.navItemTitle = formattedDate
        detailsVC.date = selectedDate
    }
    

}
extension JournalVC: CVCalendarViewDelegate{
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    func firstWeekday() -> Weekday {
        return .monday
    }
    func presentedDateUpdated(_ date: CVDate) {
        selectedDate = date.convertedDate()!
        self.navigationItem.title = getMonthName()

    }
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool) {
        self.performSegue(withIdentifier: "toDayDetails", sender: self)

    }
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        return false
    }
    func shouldScrollOnOutDayViewSelection() -> Bool {
        return false
    }

    func latestSelectableDate() -> Date {
        return Date()
    }
    
}
extension JournalVC:CVCalendarMenuViewDelegate{
    func dayOfWeekTextColor(by weekday: Weekday) -> UIColor {
        switch weekday{
        case .sunday: fallthrough
        case .saturday: return UIColor.red
            
        default: return UIColor.black
            
        }
    }
}
