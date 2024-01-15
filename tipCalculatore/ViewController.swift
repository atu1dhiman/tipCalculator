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
    @IBOutlet weak var splitBT: UIButton!
    @IBOutlet weak var secondErrorLbl: UILabel!
    @IBOutlet weak var splitTxt: UITextField!
    @IBOutlet weak var splitLlb: UILabel!
    @IBOutlet weak var topLayer: NSLayoutConstraint!
    @IBOutlet weak var spiltAction: UIButton!
    
    var flag = true
    override func viewDidLoad() {
        super.viewDidLoad()
        UILoad()
    }
    
    
    @IBAction func splitAction(_ sender: Any) {
        if flag {
            splitBT.setTitle("No", for: .normal)
            splitBT.backgroundColor = .red
            splitTxt.isHidden = true
            flag = false
            splitLlb.isHidden = true
            topLayer.constant = -40
        }else{
            splitBT.setTitle("Yes", for: .normal)
            splitBT.backgroundColor = .green
            splitTxt.isHidden = false
            splitLlb.isHidden = false
            flag = true
            topLayer.constant = 10
        }
       
        
    }
    
    @IBAction func calculatorAction(_ sender: Any) {
        checkValid()
        tipAmtTextField.text = ""
        billAmtTextfield.text = ""
        splitTxt.text = ""
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
        splitBT.layer.cornerRadius = 10
        billAmtTextfield.addTarget(self,
                                 action: #selector(self.textFieldDidChange(_:)),
                                 for: UIControl.Event.editingChanged)
        tipAmtTextField.addTarget(self,
                                 action: #selector(self.textFieldDidChange(_:)),
                                 for: UIControl.Event.editingChanged)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField)  {
        //Here we will write some code, bear with me!
        guard let bill = billAmtTextfield.text else { return}
        guard let tip = tipAmtTextField.text else { return}
        guard let split = splitTxt.text else { return}
        
        if flag{
            if !bill.isEmpty && !tip.isEmpty && !split.isEmpty {
                calclateTip()
            }
        }else{
            if !bill.isEmpty && !tip.isEmpty {
                calclateTip()
            }
        }
        
        
    }
    private func calclateTip() {
        tipAmtLbl.isHidden = false
        totalAmtLbl.isHidden = false
        let tipPercentage = Double(tipAmtTextField.text ?? "") ?? 0.0
        let billAmt = Double(billAmtTextfield.text ?? "") ?? 0.0
        let tipAmt = billAmt * (tipPercentage/100.0)
        
        self.tipAmtLbl.text = "Total Tip Amount : \(String(format: "%.1f", tipAmt))"
        if flag {
            let split = Int(splitTxt.text ?? "") ?? 0
            let tot = (billAmt + tipAmt).rounded()
            let totalAmt = Int(tot)/split
            self.totalAmtLbl.text = "Total Bill Amount After Tip : \(String(format: "%.1f", tot))"
            self.splitLlb.text = "Per Person After Split  : \(totalAmt)"
           
        }else{
            splitLlb.isHidden = true
            let totalAmt = (billAmt + tipAmt).rounded()
            self.totalAmtLbl.text = "Total Bill Amount After Tip : \(String(format: "%.1f", totalAmt))"
        }
        
       

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


