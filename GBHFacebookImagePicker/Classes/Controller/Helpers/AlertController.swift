//
//  AlertController.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 21/11/2018.
//

import Foundation

final class AlertController {
    class func showPermissionAlert(fromController controller: UIViewController,
                                   allowCompletionHandler: @escaping () -> Void,
                                   closeCompletionaHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: FacebookImagePicker.pickerConfig.textConfig.localizedOups,
                                                message: FacebookImagePicker.pickerConfig.textConfig.localizedAllowPhotoPermission,
                                                preferredStyle: UIAlertController.Style.alert)
        
        // Done & Cancel button
        let autorizeAction = UIAlertAction(title: FacebookImagePicker.pickerConfig.textConfig.localizedAllow,
                                           style: UIAlertAction.Style.default,
                                           handler: { _ -> Void in
                                            allowCompletionHandler()
        })
        
        // Cancel action
        let cancelAction = UIAlertAction(title: FacebookImagePicker.pickerConfig.textConfig.localizedClose,
                                         style: UIAlertAction.Style.cancel,
                                         handler: { (_: UIAlertAction!) -> Void in
                                            closeCompletionaHandler()
        })
        
        // Add button & show
        alertController.addAction(autorizeAction)
        alertController.addAction(cancelAction)
        controller.present(alertController, animated: true, completion: nil)
    }
}
