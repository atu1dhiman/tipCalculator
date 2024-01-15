//
//  ViewController.swift
//  tipCalculatore
//
//  Created by Atul Dhiman on 15/01/24.
//

import UIKit

class ViewController: UIViewController {

    
    
    
    @IBOutlet weak var gitImg: UIImageView!
    @IBOutlet weak var billAmtTextfield: UITextField!
    @IBOutlet weak var tipAmtTextField: UITextField!
    @IBOutlet weak var calculatorBT: UIButton!
    @IBOutlet weak var tipAmtLbl: UILabel!
    @IBOutlet weak var totalAmtLbl: UILabel!
    @IBOutlet weak var errorStrLbl: UILabel!
    @IBOutlet weak var secondErrorLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        UILoad()
    }
    @IBAction func calculatorAction(_ sender: Any) {
        checkValid()
    }
}

extension ViewController {
    private func UILoad() {
        let StatusGif = UIImage.gifImageWithName("tipBanner")
        self.gitImg.image = StatusGif
        tipAmtLbl.isHidden = true
        totalAmtLbl.isHidden = true
        errorStrLbl.isHidden = true
        secondErrorLbl.isHidden = true
        calculatorBT.layer.cornerRadius = 10
        
    }
    
    private func calclateTip() {
        tipAmtLbl.isHidden = false
        totalAmtLbl.isHidden = false
        let tipPercentage = Double(tipAmtTextField.text ?? "") ?? 0.0
        let billAmt = Double(billAmtTextfield.text ?? "") ?? 0.0
        let tipAmt = billAmt * (tipPercentage/100.0)
        
        self.tipAmtLbl.text = "Total Tip Amount : \(String(format: "%.2f", tipAmt))"
        let totalAmt = billAmt + tipAmt
        self.totalAmtLbl.text = "Total Bill Amount After Tip : \(String(format: "%.2f", totalAmt))"
        
        tipAmtTextField.text = ""
        billAmtTextfield.text = ""
    }
    private func checkValid() {
        if let cost = Double(billAmtTextfield.text ?? "") {
            if cost <= 0 {
                errorStrLbl.isHidden = false
                secondErrorLbl.isHidden = true
            }else {
                calclateTip()
                errorStrLbl.isHidden = true
                secondErrorLbl.isHidden = true
            }
        }
        if let tip = Double(tipAmtTextField.text ?? "") {
            if tip <= 0 {
                secondErrorLbl.isHidden = false
            }else{
                calclateTip()
                errorStrLbl.isHidden = true
                secondErrorLbl.isHidden = true
            }
        }
    }
}


