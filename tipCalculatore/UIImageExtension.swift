//
//  UIImageExtension.swift
//  tipCalculatore
//
//  Created by Atul Dhiman on 15/01/24.
//

import Foundation
import UIKit
import ImageIO

// MARK: - This Extension will be used to Play and gif extended UI Image...

extension UIImage {
    
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL = URL(string: gifUrl)
        else {
            print("image named \"\(gifUrl)\" doesn't exist")
            return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
            print("SwiftGif: This image named \"\(name)\" does not exist")
            return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a < b {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        
        return animation
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


extension UITextField {
    func isValid(with word: String) -> Bool {
        guard let text = self.text,
              !text.isEmpty else {
            print("Please fill the field.")
            return false
        }
        
        guard text.contains(word) else {
            print("Wrong word. Please check again.")
            return false
        }
        
        return true
    }
    
    // Function to validate the name
    func isValidName(_ name: String) -> Bool {
        // Customize the validation criteria as needed
        let nameRegex = "^[a-zA-Z]+$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return nameTest.evaluate(with: name)
    }
    
    // Function to validate the name
    func isValidNameCheckSpace(_ name: String) -> Bool {
        // Customize the validation criteria as needed
        let nameRegex = "^\\S"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return nameTest.evaluate(with: name)
    }
    func isValidInput(regex: String) -> Bool {
        do {
            let expression = try NSRegularExpression(pattern: regex)
            let range = NSRange(location: 0, length: self.text?.utf16.count ?? 0)
            return expression.firstMatch(in: self.text ?? "", options: [], range: range) != nil
        } catch {
            return false
        }
    }
    
    
    

    func isValidMailInput(input: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: input)
    }
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        // Define the regular expression patterns
        let patternWithSpace = "^(\\d{5} ?\\d{5})$"
        let patternWithoutSpace = "^(\\d{10,10})$"
        
        // Create regular expression objects
        let regexWithSpace = try? NSRegularExpression(pattern: patternWithSpace, options: .caseInsensitive)
        let regexWithoutSpace = try? NSRegularExpression(pattern: patternWithoutSpace, options: .caseInsensitive)
        
        // Check if it matches either pattern (with or without space)
        return (regexWithSpace?.firstMatch(in: phoneNumber, options: [], range: NSRange(location: 0, length: phoneNumber.utf16.count)) != nil) ||
        (regexWithoutSpace?.firstMatch(in: phoneNumber, options: [], range: NSRange(location: 0, length: phoneNumber.utf16.count)) != nil)
    }
    
    func shouldChangeCustomOtp(textField:UITextField, string: String) ->Bool {
        
        //Check if textField has two chacraters
        if ((textField.text?.count)! == 1  && string.count > 0) {
            let nextTag = textField.tag + 1;
            // get next responder
            var nextResponder = textField.superview?.viewWithTag(nextTag);
            if (nextResponder == nil) {
                nextResponder = textField.superview?.viewWithTag(1);
            }
            textField.text = textField.text! + string;
            //write here your last textfield tag
            if textField.tag == 4 {
                //Dissmiss keyboard on last entry
                textField.resignFirstResponder()
            }
            else {
                ///Appear keyboard
                nextResponder?.becomeFirstResponder();
            }
            return false;
        } else if ((textField.text?.count)! == 1  && string.count == 0) {// on deleteing value from Textfield
            
            let previousTag = textField.tag - 1;
            // get prev responder
            var previousResponder = textField.superview?.viewWithTag(previousTag);
            if (previousResponder == nil) {
                previousResponder = textField.superview?.viewWithTag(1);
            }
            textField.text = "";
            previousResponder?.becomeFirstResponder();
            return false
        }
        return true
        
    }
    
    
    
    
    
}

extension UITextView {
    func addPlaceholder(_ placeholder: String) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.textAlignment = .left
        placeholderLabel.font = self.font
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin = CGPoint(x: 5, y: 8) // Adjust the position as needed
        
        placeholderLabel.isHidden = !self.text.isEmpty
        self.addSubview(placeholderLabel)
        
        NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: self, queue: .main) { [weak self] _ in
            placeholderLabel.isHidden = !(self?.text.isEmpty ?? true)
        }
    }
    func isValidInput(regex: String) -> Bool {
        do {
            let expression = try NSRegularExpression(pattern: regex)
            let range = NSRange(location: 0, length: self.text?.utf16.count ?? 0)
            return expression.firstMatch(in: self.text ?? "", options: [], range: range) != nil
        } catch {
            return false
        }
    }
    func isValidName(_ name: String) -> Bool {
        // Customize the validation criteria as needed
        let nameRegex = "^[a-zA-Z]+$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return nameTest.evaluate(with: name)
    }
}

extension UIImagePickerController {
    
    static func createPickerWith(sourceType: UIImagePickerController.SourceType,
                                 delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = delegate
        return picker
    }
    
    static func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }

}
extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func didTapImage(){
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
                let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
                    self.openImagePicker(sourceType: .photoLibrary)
                }
                let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                    self.openImagePicker(sourceType: .camera)
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(photoLibraryAction)
                alertController.addAction(cameraAction)
                alertController.addAction(cancelAction)
                present(alertController, animated: true, completion: nil)
    }
    
    func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController.createPickerWith(sourceType: sourceType, delegate: self)
            present(picker, animated: true, completion: nil)
    }
}

extension UIViewController {
    
    
    var topViewController: UIViewController? {
        if let presentedViewController = presentedViewController {
            return presentedViewController.topViewController
        }
        
        if let navigationViewController = self as? UINavigationController {
            return navigationViewController.visibleViewController?.topViewController
        }
        
        if let tabBarController = self as? UITabBarController {
            if let selectedViewController = tabBarController.selectedViewController {
                return selectedViewController.topViewController
            }
        }
        
        return self
    }

    /// This Method is used for showing the  Alert with Action Button
    func showActionAlert(title: String, info: String, handler:((_ action: UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: info, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action)-> Void in
            if let handler = handler{
                handler(action)
            }
        }
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension UITableViewCell {
}
