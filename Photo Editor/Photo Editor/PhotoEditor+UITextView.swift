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
                if let font = textView.font {
                    let layoutManager: NSLayoutManager = textView.layoutManager
                    let numberOfGlyphs = layoutManager.numberOfGlyphs
                    var numberOfLines: CGFloat = 0
                    var index = 0
                    var lineRange: NSRange = NSRange()
                    
                    while (index < numberOfGlyphs) {
                        layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
                        index = NSMaxRange(lineRange)
                        numberOfLines = numberOfLines + 1
                    }
                    
                    let lineDiffs = sizeToFit.height - (font.lineHeight * numberOfLines)
                    
                    
                    let lineHeight: CGFloat = (maxTextViewHeight - lineDiffs) / numberOfLines
                    let updatedFontAscender = lineHeight - (font.descender * -1) - font.leading
                    
                    currentFontSize = updatedFontAscender
                    textView.font = UIFont(name: currentFontName, size: currentFontSize)
                }

                sizeToFit.height = maxTextViewHeight
            } else {
                textView.font = UIFont(name: currentFontName, size: currentFontSize)
            }
            
            textView.frame.size = CGSize(width: oldFrame.width, height: sizeToFit.height)
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
