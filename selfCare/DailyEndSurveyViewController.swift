//
//  DailyEndSurveyViewController.swift
//  selfCare
//
//  Created by Jie-Yun Cheng on 7/20/17.
//  Copyright © 2017 Jie-Yun Cheng. All rights reserved.
//

import UIKit

class DailyEndSurveyViewController: UIViewController {

    @IBOutlet weak var inputFeelingAfter: UISegmentedControl!
    @IBOutlet weak var inputTimeSpent: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps to dismiss the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DailyEndSurveyViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func inputTimeSpent(_textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let aSet = NSCharacterSet(charactersIn: "0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Save the day"{
            if !(inputTimeSpent.text?.isNumeric)! {
                let alertController = UIAlertController(title: "I see what you did there 😏", message: "Please input a reasonable integer for your time spent on self care.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler:{alert -> Void in})
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                print("User inputted a non-integer")
            } // check if user actually inputted an integer number
            else {
                let selfHelpDay = CoreDataHelper.newSelfHelpDay()
                selfHelpDay.feelingBefore = SingletonTemporarySelfHelpDay.shared.feelingBefore
                selfHelpDay.methodUsed = SingletonTemporarySelfHelpDay.shared.methodUsed
                selfHelpDay.timeSpent = inputTimeSpent.text ?? ""
                selfHelpDay.feelingAfter = String(inputFeelingAfter.selectedSegmentIndex + 1)
                //+1 is because segment index starts at 0, then convert int to string
                selfHelpDay.selfHelpDate = Date() as NSDate
                CoreDataHelper.saveSelfHelpDay()
                SingletonTemporarySelfHelpDay.shared.resetData() //just to be safe, though users already override the 2 variables in the beginning
            } // only save if timeSpent is a number
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
