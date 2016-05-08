# Wizardry
![wizard](Images/wizard.png)

A reusable way to allow users to perform a multipart task in your iOS app, written in Swift.

![sign up wizard demo](Images/signup_wizard.png)

The demo implements a wizard that allows users to sign up to use an app.

Classes in the framework make no assumption about, nor impose restrictions upon, your wizard's visual design.

Important functionality in the wizard framework has thorough unit test coverage.

## How to use it

Create a `UIViewController` subclass for every step in your wizard. See [UsernameStepViewController](/Demo/WizardryDemo/SignUpWizard/UsernameStepViewController.swift) for an example.

For every step in your wizard, create a type that adopts the `WizardStep` protocol. An instance of this type owns a wizard step view controller and collects & processes user input for that view controller. See [UsernameWizardStep](/Demo/WizardryDemo/SignUpWizard/UsernameWizardStep.swift) for an example.

> Note: It is possible to have the wizard step view controllers adopt the `WizardStep` protocol, if preferred.

Adopt the `WizardDataSource` protocol to determine the order in which a user will view your wizard steps. See [SignUpWizard](/Demo/WizardryDemo/SignUpWizard/SignUpWizardDataSource.swift) for an example.

Subclass `WizardViewController` and implement your custom UI design to navigate between wizard step views. You will need to override three methods:
```swift
func navigateToInitialWizardStep(wizardStep: WizardStep)    
func navigateToNextWizardStep(wizardStep: WizardStep, placement: WizardStepPlacement)
func navigateToPreviousWizardStep(wizardStep: WizardStep, placement: WizardStepPlacement)
```
See [SignUpWizardViewController](/Demo/WizardryDemo/SignUpWizard/SignUpWizardViewController.swift) in the demo project for more information.

Create your wizard view controller and configure it with your custom data source before presenting it to the user.
```swift
@IBAction func handleShowSignUpWizardButton(sender: UIButton) {
    let storyboard = UIStoryboard(name: "SignUpWizard", bundle: nil)
    let signUpWizardVC = storyboard.instantiateInitialViewController() as! SignUpWizardViewController
    let model = SignUpWizardModel()
    let dataSource = SignUpWizardDataSource(model: model)
    
    signUpWizardVC.configureWith(dataSource, completionHandler: { [weak self] (canceled: Bool) in
        print("Completed sign up wizard. canceled = \(canceled)")
        self?.dismissViewControllerAnimated(true, completion: nil)
        })

    presentViewController(signUpWizardVC, animated: true, completion: nil)
}
```
