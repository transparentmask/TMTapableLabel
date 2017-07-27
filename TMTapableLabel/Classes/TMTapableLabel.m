//
//  TMTapableLabel.m
//  TMTapableLabelDemo
//
//  Created by Martin Yin on 27/07/2017.
//  Copyright © 2017 Martin Yin. All rights reserved.
//

#import "TMTapableLabel.h"

@interface TMTapableLabel ()

@property (strong, nonatomic) NSLayoutManager *layoutManager;
@property (strong, nonatomic) NSTextContainer *textContainer;
@property (strong, nonatomic) NSTextStorage *textStorage;

@end

@implementation TMTapableLabel

- (NSLayoutManager *)layoutManager {
    if(!_layoutManager) {
        _layoutManager = [[NSLayoutManager alloc] init];
        [_layoutManager addTextContainer:self.textContainer];
    }
    return _layoutManager;
}

- (NSTextContainer *)textContainer {
    if(!_textContainer) {
        _textContainer = [[NSTextContainer alloc] init];
        
        _textContainer.lineFragmentPadding = 0.0;
        _textContainer.lineBreakMode = self.lineBreakMode;
        _textContainer.maximumNumberOfLines = self.numberOfLines;
        
    }
    return _textContainer;
}

- (NSTextStorage *)textStorage {
    if(!_textStorage) {
        if(self.attributedText) {
            _textStorage = [[NSTextStorage alloc] initWithAttributedString:self.attributedText];
        }
        else {
            _textStorage = [[NSTextStorage alloc] initWithString:self.text];
        }
        
        [_textStorage addLayoutManager:self.layoutManager];
    }
    return _textStorage;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    [self initialize];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    [self initialize];
    
    return self;
}

- (void)initialize {
    self.userInteractionEnabled = TRUE;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTapAction:)]];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
    self.textStorage = nil;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    
    self.textStorage = nil;
}

- (void)doTapAction:(UITapGestureRecognizer *)gestureRecognizer {
    if(!self.textRangeAndActionBlocks) {
        return;
    }
    
    [self textStorage];

    CGSize labelSize = self.frame.size;
    
    CGPoint locationOfTouchInLabel = [gestureRecognizer locationInView:self];
    CGSize calcSize = [self sizeThatFits:labelSize];
    
    CGPoint locationOfTouchInTextContainer = locationOfTouchInLabel;
    if(self.textAlignment == NSTextAlignmentLeft ||
       self.textAlignment == NSTextAlignmentJustified ||
       self.textAlignment == NSTextAlignmentNatural) {
//        locationOfTouchInTextContainer = locationOfTouchInLabel;
    }
    else if(self.textAlignment == NSTextAlignmentCenter) {
        if(calcSize.width <= labelSize.width) {
            locationOfTouchInTextContainer.x = locationOfTouchInLabel.x - (labelSize.width-calcSize.width)*0.5;
        }
    }
    else if(self.textAlignment == NSTextAlignmentRight) {
        if(calcSize.width <= labelSize.width) {
            locationOfTouchInTextContainer.x = locationOfTouchInLabel.x - (labelSize.width-calcSize.width);
        }
    }
    
    NSInteger indexOfCharacter = [self.layoutManager characterIndexForPoint:locationOfTouchInTextContainer
                                                            inTextContainer:self.textContainer
                                   fractionOfDistanceBetweenInsertionPoints:nil];
    
    for(NSValue *rangeValue in self.textRangeAndActionBlocks) {
        NSRange range = [rangeValue rangeValue];
        if(NSLocationInRange(indexOfCharacter, range)) {
            TMTapableLabelAction actionBlock = self.textRangeAndActionBlocks[rangeValue];
            actionBlock();
        }
    }
}

#if DEBUG
- (void)test {
    if(!self.textRangeAndActionBlocks) {
        return;
    }
    
    [self textStorage];
    
    CGSize labelSize = self.frame.size;
    CGSize calcSize = [self sizeThatFits:labelSize];
    CGFloat xOffset = 0;
    if(self.textAlignment == NSTextAlignmentLeft ||
       self.textAlignment == NSTextAlignmentJustified ||
       self.textAlignment == NSTextAlignmentNatural) {
    }
    else if(self.textAlignment == NSTextAlignmentCenter) {
        if(calcSize.width <= labelSize.width) {
            xOffset = (labelSize.width-calcSize.width)*0.5;
        }
    }
    else if(self.textAlignment == NSTextAlignmentRight) {
        if(calcSize.width <= labelSize.width) {
            xOffset = (labelSize.width-calcSize.width);
        }
    }

    while(self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }

    for(NSValue *rangeValue in self.textRangeAndActionBlocks) {
        NSRange range = [rangeValue rangeValue];
        NSRange glyphRange = [self.layoutManager glyphRangeForCharacterRange:range actualCharacterRange:nil];
        CGRect rect = [self.layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:self.textContainer];
        rect.origin.x += xOffset;
        UIView *testView = [[UIView alloc] initWithFrame:rect];
        testView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:testView];
    }
}
#endif
@end
