//
//  NSString+Letter.m
//  MomentKit
//
//  Created by LEA on 2019/2/2.
//  Copyright © 2019 LEA. All rights reserved.
//

#import "NSString+Letter.h"
#import "JPinYinUtil.h"

@implementation NSString (Letter)

- (NSString *)firstLetter
{
    NSString * ret = @"";
    if (![self canBeConvertedToEncoding: NSASCIIStringEncoding]) { // 英语
        if ([[self letters] length] > 2) {
            ret = [[self letters] substringToIndex:1];
        } else {
            char code = [[self letters] characterAtIndex:0];
            if((code >= 65 && code <= 90) || (code >= 97 && code <= 122)) {
                ret = [self letters];
            }
        }
    } else {
        ret = [NSString stringWithFormat:@"%c",[self characterAtIndex:0]];
    }
    return ret;
}

- (NSString *)letters
{
    NSMutableString * letterString = [NSMutableString string];
    int len = (int)[self length];
    for (int i = 0;i < len;i++)
    {
        NSString *oneChar = [[self substringFromIndex:i] substringToIndex:1];
        if (![oneChar canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            NSArray *temA = makePinYin2([oneChar characterAtIndex:0]);
            if ([temA count]>0) {
                oneChar = [temA objectAtIndex:0];
            }
        }
        [letterString appendString:oneChar];
    }
    return letterString;
}

@end
