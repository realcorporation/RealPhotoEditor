//
//  PhotoEditor+Font.swift
//
//
//  Created by Mohamed Hamed on 6/16/17.
//
//

import Foundation
import UIKit

extension PhotoEditorViewController {
    
    //Resources don't load in main bundle we have to register the font
    func registerFont(){
        let bundle = Bundle(for: PhotoEditorViewController.self)
        let urls = ["icomoon", "BarlowCondensed-Regular", "BarlowCondensed-Italic"]
        
        for ttfName in urls {
            if let url =  bundle.url(forResource: ttfName, withExtension: "ttf") {
                registerFont(url: url)
            }
        }
    }
    
    func registerFont(url: URL){
        guard let fontDataProvider = CGDataProvider(url: url as CFURL) else {
            return
        }
        
        var error: Unmanaged<CFError>?
        guard let font = CGFont(fontDataProvider), CTFontManagerRegisterGraphicsFont(font, &error) else {
            return
        }
    }
}
