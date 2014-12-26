//
//  StringDrawingOptions+combine.m
//  RZTimelineCollection
//
//  Created by Rostyslav Kobizsky on 12/24/14.
//  Copyright (c) 2014 Rozdoum. All rights reserved.
//

#import "StringDrawingOptions+combine.h"

@implementation NSObject (combine)

+ (NSStringDrawingOptions)combine:(NSStringDrawingOptions)option1 with:(NSStringDrawingOptions)option2
{
    return option1 | option2;
}

@end
