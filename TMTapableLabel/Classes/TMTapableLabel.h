//
//  TMTapableLabel.h
//  TMTapableLabelDemo
//
//  Created by Martin Yin on 27/07/2017.
//  Copyright © 2017 Martin Yin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TMTapableLabelAction)(void);

@interface TMTapableLabel : UILabel

@property (strong, nonatomic) NSDictionary <NSValue */*NSRange*/, TMTapableLabelAction> *textRangeAndActionBlocks;

#if DEBUG
- (void)test;
#endif

@end
