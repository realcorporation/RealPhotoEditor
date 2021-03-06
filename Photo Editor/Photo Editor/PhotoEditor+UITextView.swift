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
    static let maxFontSize: CGFloat = 170
    static var previousRect: CGRect?
    
    public func textViewDidChange(_ textView: UITextView) {
        let rotation = atan2(textView.transform.b, textView.transform.a)
        if rotation == 0 {
            let oldFrame = textView.frame
            let sizeToFit = textView.sizeThatFits(CGSize(width: oldFrame.width, height:CGFloat.greatestFiniteMagnitude))
            
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
                
                let position = textView.endOfDocument
                let currentRect = textView.caretRect(for: position)
                if let previousRect = PhotoEditorViewController.previousRect {
                    if currentRect.origin.y > previousRect.origin.y {
                        numberOfLines = numberOfLines + 1
                    }
                }
                
                PhotoEditorViewController.previousRect = currentRect
                
                let lineDiffs: CGFloat = sizeToFit.height - (font.lineHeight * numberOfLines)
                var calFont = (maxTextViewHeight - lineDiffs) / numberOfLines - (font.descender * -1) - font.leading
                if calFont >= PhotoEditorViewController.maxFontSize {
                    calFont = PhotoEditorViewController.maxFontSize
                }
                
                currentFontSize = calFont
                textView.font = UIFont(name: currentFontName, size: currentFontSize)
                self.lastTextViewFont = textView.font
            }
            
            let sizeToFitUpdated = textView.sizeThatFits(CGSize(width: oldFrame.width, height:CGFloat.greatestFiniteMagnitude))
            textView.frame.size = CGSize(width: oldFrame.width, height: sizeToFitUpdated.height)
            currentTextBackgroundView?.frame.size = CGSize(width: oldFrame.width, height: sizeToFitUpdated.height)
        }
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        isTyping = true
        lastTextViewTransform = textView.superview?.transform
        lastTextViewTransCenter = textView.superview?.center
        lastTextViewFont = textView.font!
        activeTextView = textView
        if let background = textView.superview {
            background.superview?.bringSubviewToFront(background)
        }
        textView.font = UIFont(name: currentFontName, size: currentFontSize)
        UIView.animate(withDuration: 0.3,
                       animations: {
                        textView.superview?.transform = CGAffineTransform.identity
                        textView.superview?.center = CGPoint(x: UIScreen.main.bounds.width / 2,
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
        
        if let textBackgroundView = self.currentTextBackgroundView {
            var orignalRect = textBackgroundView.frame
            orignalRect.origin.y = canvasImageView.center.y - textBackgroundView.frame.size.height / 2
            textBackgroundView.frame = orignalRect
        }
        
        UIView.animate(withDuration: 0.3,
                       animations: {
                        textView.superview?.transform = self.lastTextViewTransform!
                        textView.superview?.center = self.lastTextViewTransCenter!
        }, completion: nil)
    }
    
    @IBAction func sizeChanged(sender: UISlider) {
        if let activeTextView = activeTextView {
            let value: CGFloat = CGFloat(sender.value)
            activeTextView.font = UIFont(name: currentFontName, size: currentFontSize * value)
        }
    }
    
    @IBAction func clickChangeFontName(sender: UIButton) {
        changeFontName()
    }
    
    private func changeFontName() {
        if currentFontName == "BarlowCondensed-Regular" {
            currentFontName = "BarlowCondensed-Italic"
        } else {
            currentFontName = "BarlowCondensed-Regular"
        }
        let value: CGFloat = CGFloat(sizeBar.value)
        activeTextView?.font = UIFont(name: currentFontName, size: currentFontSize * value)
    }
    
    @IBAction func clickChangeAlignment(sender: UIButton) {
        changeAlignment()
    }
    
    private func changeAlignment() {
        if let activeTextView = activeTextView {
            if activeTextView.textAlignment == NSTextAlignment.center {
                activeTextView.textAlignment = NSTextAlignment.left
            } else if activeTextView.textAlignment == NSTextAlignment.left {
                activeTextView.textAlignment = NSTextAlignment.right
            } else {
                activeTextView.textAlignment = NSTextAlignment.center
            }
        }
    }
}
