//
//  NSObject+CRChecker.m
//  CRChecker
//
//  Created by 崔 明辉 on 14-12-25.
//  Copyright (c) 2014年 崔 明辉. All rights reserved.
//

#import "NSObject+CRChecker.h"
#import "CRCounter.h"
#import "CRStatusBar.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "NSObject+CRObjectStorager.h"

static CRStatusBar *statusBar;

@implementation NSObject (CRChecker)

+ (void)load {
    statusBar = [[CRStatusBar alloc] initWithFrame:CGRectZero];
}

- (void)cr_dealloc {
    if ([UIApplication sharedApplication] != nil) {
        [CRCounter decreaseWithClass:[self class]];
    }
    [self cr_dealloc];
}

- (instancetype)cr_init {
    if ([NSBundle bundleForClass:[self class]] != [NSBundle mainBundle]) {
        return [self cr_init];
    }
    else {
        if ([UIApplication sharedApplication] != nil) {
            if ([statusBar superview] == nil) {
                [[[[UIApplication sharedApplication] delegate] window] performSelector:@selector(addSubview:) withObject:statusBar afterDelay:10.0];
            }
            else {
                [[[[UIApplication sharedApplication] delegate] window] setWindowLevel:UIWindowLevelStatusBar];
            }
            [CRCounter increaseWithClass:[self class]];
        }
        id object = [self cr_init];
        [object cr_storagerAddObject];
        return object;
    }
}

@end
