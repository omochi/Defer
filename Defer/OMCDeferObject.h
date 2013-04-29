//
//  OMCDefer.h
//  Defer
//
//  Created by おもちメタル on 13/04/29.
//  Copyright (c) 2013年 com.omochimetaru. All rights reserved.
//

#import <Foundation/Foundation.h>

#define OMCDefer(code) _OMCDefer(code,__LINE__)
#define _OMCDefer(code,line) __OMCDefer(code,line)
#define __OMCDefer(code,line) \
OMCDeferObject * __strong _defer_##line = [[OMCDeferObject alloc]initWithBlock:^(){code}]; \
(void)_defer_##line;

@interface OMCDeferObject : NSObject
@property(nonatomic,copy)dispatch_block_t block;
-(id)initWithBlock:(dispatch_block_t)block;
@end
