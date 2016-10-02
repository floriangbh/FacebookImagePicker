//
//  GBHAssetManager.swift
//  Pods
//
//  Created by Florian Gabach on 02/10/2016.
//
//

import Foundation
import UIKit

public class GBHAssetManager {
    
    public static func getImage(name: String) -> UIImage? {
//        var bundle = Bundle(for: GBHAssetManager.self)
//        print(bundle)
//        if let filepath = bundle.path(forResource: name, ofType: "png") {
//            do {
//                let contents = try String(contentsOfFile: filepath)
//                print(contents)
//                return UIImage(named: contents, in: bundle, compatibleWith: nil) ?? nil
//            } catch {
//                // contents could not be loaded
//            }
//        }
        
        
        var bundle = Bundle(for: GBHAssetManager.self)
        if let bundlePath = bundle.resourcePath?.appending("/GBHFacebookImagePicker.bundle"), let ressourceBundle = Bundle(path: bundlePath) {
            bundle = ressourceBundle
        }

        return UIImage(named: name, in: bundle, compatibleWith: nil) ?? UIImage()
    }
}
