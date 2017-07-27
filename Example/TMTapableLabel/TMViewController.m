//
//  TMViewController.m
//  TMTapableLabel
//
//  Created by Martin Yin on 07/27/2017.
//  Copyright (c) 2017 Martin Yin. All rights reserved.
//

#import "TMViewController.h"
#import <TMTapableLabel/TMTapableLabel.h>

@interface TMViewController ()

@property (nonatomic, weak) IBOutlet TMTapableLabel *englishLabel;
@property (nonatomic, weak) IBOutlet TMTapableLabel *chineseLabel;

@property (nonatomic, weak) IBOutlet UILabel *resultLabel;

@end

@implementation TMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    {
        // add actions for english label
        NSArray *words = [self.englishLabel.text componentsSeparatedByString:@" "];
        NSMutableDictionary *rangeAndActions = [NSMutableDictionary dictionaryWithCapacity:words.count];
        for(NSString *word in words) {
            NSRange range = [self.englishLabel.text rangeOfString:word];
            [rangeAndActions setObject:^{[self showResultInEnglish:word];}
                                forKey:[NSValue valueWithRange:range]];
        }
        self.englishLabel.textRangeAndActionBlocks = rangeAndActions;

#if DEBUG
        [self.englishLabel test];
#endif
    }

    {
        // add image at the end of chinese label
        NSMutableAttributedString *chinese = [self.chineseLabel.attributedText mutableCopy];
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = [UIImage imageNamed:@"hugging"];
        [chinese appendAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment]];
        self.chineseLabel.attributedText = chinese;
        
        // add actions for chinese label with image
        NSArray *words = [chinese.string componentsSeparatedByString:@" "];
        NSMutableDictionary *rangeAndActions = [NSMutableDictionary dictionaryWithCapacity:words.count];
        for(NSUInteger i = 0; i < words.count; i++) {
            NSString *word = [words objectAtIndex:i];
            NSRange range = [chinese.string rangeOfString:word];
            if(i == words.count-1) {
                word = @"Hugging Image";
            }
            [rangeAndActions setObject:^{[self showResultInChinese:word];}
                                forKey:[NSValue valueWithRange:range]];
        }
        self.chineseLabel.textRangeAndActionBlocks = rangeAndActions;

#if DEBUG
        [self.chineseLabel test];
#endif
    }
}

- (NSValue *)rangeValue:(NSUInteger)loc len:(NSUInteger)len {
    return [NSValue valueWithRange:NSMakeRange(loc, len)];
}

- (void)showResultInEnglish:(NSString *)word {
    self.resultLabel.text = [NSString stringWithFormat:@"Tap on \"%@\" in English Label", word];
}

- (void)showResultInChinese:(NSString *)word {
    self.resultLabel.text = [NSString stringWithFormat:@"点在中文标签的\"%@\"上", word];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
