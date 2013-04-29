//
//  OMCDefer.m
//  Defer
//
//  Created by おもちメタル on 13/04/29.
//  Copyright (c) 2013年 com.omochimetaru. All rights reserved.
//

#import "OMCDeferObject.h"

@implementation OMCDeferObject
-(id)initWithBlock:(dispatch_block_t)block{
	self = [super init];
	if(self){
		_block = [block copy];
	}
	return self;
}
-(void)dealloc{
	self.block();
}
@end
