//
//  PhotoEditor+UITextView.swift
//  Pods
//
//  Created by Mohamed Hamed on 6/16/17.
//
//

import Foundation
import UIKit

extension PhotoEditorViewController: UITextViewDelegate {
    
    public func textViewDidChange(_ textView: UITextView) {
        let rotation = atan2(textView.transform.b, textView.transform.a)
        if rotation == 0 {
            let oldFrame = textView.frame
            var sizeToFit = textView.sizeThatFits(CGSize(width: oldFrame.width, height:CGFloat.greatestFiniteMagnitude))
            
            
            if sizeToFit.height > maxTextViewHeight {
                var sizeToFit2 = textView.sizeThatFits(CGSize(width: oldFrame.width, height:CGFloat.greatestFiniteMagnitude))
                sizeToFit.height = maxTextViewHeight
                
                if let font = textView.font {
//                    let lineHeight = font.capHeight + font.lineHeight
                    let lineHeight = font.lineHeight
                    
                    let preLineNumber = sizeToFit2.height / lineHeight
                    
                    print("1=\(font.descender);2=\(font.ascender);3=\(font.pointSize);4=\(font.capHeight);5=\(font.xHeight);6=\(font.lineHeight);")
                    print("lineNumber=\(preLineNumber).currentFontSize=\(currentFontSize);sizeToFit.height=\(sizeToFit.height);lineHeight=\(lineHeight)")
                    print("sizeToFit2=\(sizeToFit2.height)")
                    currentFontSize = preLineNumber
                    textView.font = UIFont(name: currentFontName, size: preLineNumber)
                }

            } else {
//                currentFontSize = 30
                
//                if let font = textView.font {
//                    let lineHeight = font.xHeight
//
//                    let preLineNumber = sizeToFit.height / lineHeight
//                    print("lineNumber=\(preLineNumber)")
//                    currentFontSize = preLineNumber
                    textView.font = UIFont(name: currentFontName, size: currentFontSize)
//                }
            }
            
            textView.frame.size = CGSize(width: oldFrame.width, height: sizeToFit.height)
            
//            textView.font = UIFont(name: currentFontName, size: currentFontSize)
        }
    }
    public func textViewDidBeginEditing(_ textView: UITextView) {
        isTyping = true
        lastTextViewTransform =  textView.transform
        lastTextViewTransCenter = textView.center
        lastTextViewFont = textView.font!
        activeTextView = textView
        textView.superview?.bringSubviewToFront(textView)
        textView.font = UIFont(name: currentFontName, size: currentFontSize)
        UIView.animate(withDuration: 0.3,
                       animations: {
                        textView.transform = CGAffineTransform.identity
                        textView.center = CGPoint(x: UIScreen.main.bounds.width / 2,
                                                  y:  UIScreen.main.bounds.height / 5)
        }, completion: nil)
        
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        guard lastTextViewTransform != nil && lastTextViewTransCenter != nil && lastTextViewFont != nil
            else {
                return
        }
        activeTextView = nil
        textView.font = self.lastTextViewFont!
        UIView.animate(withDuration: 0.3,
                       animations: {
                        textView.transform = self.lastTextViewTransform!
                        textView.center = self.lastTextViewTransCenter!
        }, completion: nil)
    }
    
}
