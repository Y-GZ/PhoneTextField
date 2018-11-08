//
//  PhoneTextField.swift
//  PhoneTextField
//
//  Created by YGZ on 2018/11/8.
//  Copyright © 2018 YGZ. All rights reserved.
//

import UIKit

extension String {
    
    func reformatTelephone() -> String {
        var replaceStr = self
        if self.contains("-") {
            replaceStr = replaceStr.replacingOccurrences(of: "-", with: "")
        }
        if self.contains(" ") {
            replaceStr = replaceStr.replacingOccurrences(of: " ", with: "")
        }
        if self.contains("(") {
            replaceStr = replaceStr.replacingOccurrences(of: "(", with: "")
        }
        if self.contains(")") {
            replaceStr = replaceStr.replacingOccurrences(of: ")", with: "")
        }
        if self.contains("+86") {
            replaceStr = replaceStr.replacingOccurrences(of: "+86", with: "")
        }
        replaceStr = replaceStr.replacingOccurrences(of: "[^\\d]", with: "", options: .regularExpression, range: replaceStr.startIndex..<replaceStr.endIndex)
        return replaceStr
    }
    
}

class PhoneTextField: UITextField, UITextFieldDelegate {
    
    var deleteBlock: (()-> Void)?
    var multiPasteBlock: (()-> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var shouldAdd = true
        var isDelete = false
        var str = ""
        var location = range.location
        if let text = textField.text, text.contains("*") {
            if string != "" {
                if text.count > 10 {
                    shouldAdd = false
                }
            }
        } else {
            if string.count > 1 {
                shouldAdd = false
                str = string.reformatTelephone()
                str = str.replacingOccurrences(of: "－", with: "")
                if str.count > 3 {
                    str.insert(" ", at: str.index(str.startIndex, offsetBy: 3))
                }
                if str.count > 8 {
                    str.insert(" ", at: str.index(str.startIndex, offsetBy: 8))
                }
                if str.count > 13 {
                    str.insert(" ", at: str.index(str.startIndex, offsetBy: 13))
                }
                textField.text = str
                multiPasteBlock?()
            } else {
                if string == " " {
                    return false
                } else if string == "" {
                    shouldAdd = false
                    isDelete = true
                    var subStr: String?
                    if range.location == 3 || range.location == 8 {
                        subStr = textField.text?.replacingCharacters(in: textField.text!.index(textField.text!.startIndex, offsetBy: range.location - 1)..<textField.text!.index(textField.text!.startIndex, offsetBy: range.location + 1), with: "")
                        location -= 1
                    } else {
                        subStr = textField.text?.replacingCharacters(in: textField.text!.index(textField.text!.startIndex, offsetBy: range.location)..<textField.text!.index(textField.text!.startIndex, offsetBy: range.location + 1), with: "")
                    }
                    str = subStr?.replacingOccurrences(of: " ", with: "") ?? ""
                } else {
                    str = textField.text?.replacingOccurrences(of: " ", with: "") ?? ""
                    if str.count > 10 {
                        return false
                    } else if str.count == 3 {
                        if range.location == 3 {
                            str += " "
                            location += 1
                        } else {
                            str.insert(" ", at: str.index(str.startIndex, offsetBy: 2))
                        }
                    } else if str.count == 7 && range.location == 8 {
                        str += " "
                        location += 1
                    }
                }
                if str.count >= 4 {
                    if str[str.index(str.startIndex, offsetBy: 3)] != " " {
                        if string == "" {
                            str.insert(" ", at: str.index(str.startIndex, offsetBy: 3))
                        } else {
                            if range.location < 3 {
                                str.insert(" ", at: str.index(str.startIndex, offsetBy: 2))
                            } else {
                                str.insert(" ", at: str.index(str.startIndex, offsetBy: 3))
                                if range.location == 3 {
                                    location += 1
                                }
                            }
                        }
                    }
                }
                if str.count == 8 {
                    if string != "" {
                        str.insert(" ", at: str.index(str.startIndex, offsetBy: 7))
                    }
                }
                if str.count >= 9 {
                    if str[str.index(str.startIndex, offsetBy: 8)] != " " {
                        if string == "" {
                            str.insert(" ", at: str.index(str.startIndex, offsetBy: 8))
                        } else {
                            if range.location < 8 {
                                str.insert(" ", at: str.index(str.startIndex, offsetBy: 7))
                            } else {
                                str.insert(" ", at: str.index(str.startIndex, offsetBy: 8))
                                if range.location == 8 {
                                    location += 1
                                }
                            }
                        }
                    }
                }
                textField.text = str
                if let position = textField.position(from: textField.beginningOfDocument, offset: location) {
                    textField.selectedTextRange = textField.textRange(from: position, to: position)
                }
                if isDelete {
                    deleteBlock?()
                }
            }
        }
        return shouldAdd
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
}
