//
//  RegisterForm.swift
//  Budj.It
//
//  Created by Apollo Rowe on 7/24/25.
//

import FormValidator
import UIKit

class RegisterForm: ObservableObject {
    @Published
    var manager = FormManager(validationType: .immediate)
    
    @FormField(validator: EmailValidator(message: "Valid Email Requried!"))
    var email: String = ""
    lazy var emailValidation = _email.validation(
        manager: manager
    )
    
    //i dont like how they do their password validation -> i will do seperately
}
