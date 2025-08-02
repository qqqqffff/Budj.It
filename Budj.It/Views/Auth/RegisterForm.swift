//
//  RegisterForm.swift
//  Budj.It
//
//  Created by Apollo Rowe on 7/24/25.
//

import FormValidator
import UIKit

class AuthForm: ObservableObject {
    @Published
    var emailManager = FormManager(validationType: .immediate)
    @Published
    var nameManager = FormManager(validationType: .immediate)
    
    @Published var password = ""
    
    @FormField(validator: EmailValidator(message: "Valid Email Requried!"))
    var email: String = ""
    lazy var emailValidation = _email.validation(
        manager: emailManager
    )
    
    @FormField(validator: {
        let validators: [any StringValidator] = [
            CountValidator(count: 2, type: .greaterThanOrEquals, message: "First Name Must be at Least 2 Characters"),
            PatternValidator(pattern: try! NSRegularExpression(pattern: "^[a-zA-Z\\s'-]*", options: .caseInsensitive), message: "Only Alphabetical Characters"),
            CountValidator(count: 32, type: .lessThanOrEquals, message: "First Name Must be at Most 32 Characters"),
        ]
        
        return CompositeValidator(
            validators: validators,
            type: .all,
            strategy: .all
        )
    })
    var firstName = ""
    lazy var firstNameValidation = _firstName.validation(manager: nameManager)
    
    @FormField(validator: {
        let validators: [any StringValidator] = [
            CountValidator(count: 2, type: .greaterThanOrEquals, message: "Last Name Must be at Least 2 Characters"),
            PatternValidator(pattern: try! NSRegularExpression(pattern: "^[a-zA-Z'-]*", options: .caseInsensitive), message: "Last Name Can Only Alphabetical Characters"),
            CountValidator(count: 32, type: .lessThanOrEquals, message: "Last Name Must be at Most 32 Characters"),
        ]
        
        return CompositeValidator(
            validators: validators,
            type: .all,
            strategy: .all
        )
    })
    var lastName = ""
    lazy var lastNameValidation = _firstName.validation(manager: nameManager)
    
    //i dont like how they do their password validation -> i will do seperately
}
