//
//  OMCViewController.m
//  Defer
//
//  Created by おもちメタル on 13/04/29.
//  Copyright (c) 2013年 com.omochimetaru. All rights reserved.
//

#import "OMCViewController.h"
#import "OMCDeferObject.h"

@interface OMCViewController ()

@end

@implementation OMCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)onButton1Click:(UIButton *)sender forEvent:(UIEvent *)event{
	NSInputStream *stream = [NSInputStream inputStreamWithFileAtPath:[[NSBundle mainBundle]pathForResource:@"Test" ofType:@"txt"]];
	if(!stream)[NSException raise:NSGenericException format:@"stream open failed"];
	[stream open];
	OMCDefer(
		[stream close];
	);
	NSMutableData *data = [NSMutableData data];
	while(YES){
		uint8_t buf[1024];
		int readLen = [stream read:buf maxLength:sizeof(buf)];
		if(readLen == -1)[NSException raise:NSGenericException format:@"read failed"];
		if(readLen == 0)break;
		[data appendBytes:buf length:readLen];
	}
	NSString * text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"text = %@",text);
}

-(IBAction)onButton2Click:(UIButton *)sender forEvent:(UIEvent *)event{
	NSInputStream *stream = [NSInputStream inputStreamWithFileAtPath:[[NSBundle mainBundle]pathForResource:@"Test" ofType:@"txt"]];
	if(!stream)[NSException raise:NSGenericException format:@"stream open failed"];
	[stream open];
	OMCDefer(
		NSLog(@"stream close");
		[stream close];
	);
	OMCDefer(
		NSLog(@"defer 2");
	);
	@try {
		[NSException raise:NSGenericException format:@"catch test"];
	}
	@catch (NSException *exception) {
		NSLog(@"catch %@",exception);
	}
	@finally {
		NSLog(@"finally");
	}
}

//-fobjc-arc-exceptionsが付いていれば動作する
-(IBAction)onButton3Click:(UIButton *)sender forEvent:(UIEvent *)event{
	NSInputStream *stream = [NSInputStream inputStreamWithFileAtPath:[[NSBundle mainBundle]pathForResource:@"Test" ofType:@"txt"]];
	if(!stream)[NSException raise:NSGenericException format:@"stream open failed"];
	[stream open];
	OMCDefer(
			 NSLog(@"stream close");
			 [stream close];
	);
	[NSException raise:NSGenericException format:@"non catch test"];
}



@end
