//
//  StringDrawingOptions+combine.h
//  RZTimelineCollection
//
//  Created by Rostyslav Kobizsky on 12/24/14.
//  Copyright (c) 2014 Rozdoum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (combine)

+ (NSStringDrawingOptions)combine:(NSStringDrawingOptions)option1 with:(NSStringDrawingOptions)option2;

@end
