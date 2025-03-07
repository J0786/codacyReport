//
//  SingleDigitField.swift
//  OTP Sample
//
//  Created by lsd on 20/07/20.
//

import UIKit

class SingleDigitField: UITextField {
    var pressedDelete = false
    override func willMove(toSuperview newSuperview: UIView?) {
        keyboardType = .numberPad
        textAlignment = .center
        backgroundColor = .white
        isSecureTextEntry = false
        isUserInteractionEnabled = false
    }
    override func caretRect(for position: UITextPosition) -> CGRect { .zero }
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] { [] }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool { false }
    override func deleteBackward() {
        pressedDelete = true
        sendActions(for: .editingChanged)
    }
}
