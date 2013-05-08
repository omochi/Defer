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

//simple sample : ok exit
//
//output:
//  enter test1
//  ok : こんにちは
//  stream close
-(BOOL)test1{
	NSLog(@"enter test1");
	NSInputStream *stream = [NSInputStream inputStreamWithFileAtPath:[[NSBundle mainBundle]pathForResource:@"Test" ofType:@"txt"]];
	if(!stream)[NSException raise:NSGenericException format:@"stream open failed"];
	[stream open];
	OMCDefer(
			 NSLog(@"stream close");
			 [stream close];
			 );
	NSMutableData *data = [NSMutableData data];
	while(YES){
		uint8_t buf[1024];
		int readLen = [stream read:buf maxLength:sizeof(buf)];
		if(readLen == -1){
			NSLog(@"error exit");
			return NO;
		}
		if(readLen == 0)break;
		[data appendBytes:buf length:readLen];
	}
	NSString * text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"ok : %@",text);
	return YES;
}

//simple sample : error exit
//
//output:
//  enter test2
//  error exit
//  stream close
-(BOOL)test2{
	NSLog(@"enter test2");
	NSInputStream *stream = [NSInputStream inputStreamWithFileAtPath:[[NSBundle mainBundle]pathForResource:@"Test" ofType:@"txt"]];
	if(!stream)[NSException raise:NSGenericException format:@"stream open failed"];
	[stream open];
	OMCDefer(
			 NSLog(@"stream close");
			 [stream close];
			 );
	NSMutableData *data = [NSMutableData data];
	while(YES){
		uint8_t buf[1024];
		int readLen = [stream read:buf maxLength:sizeof(buf)];
		readLen = -1;//error flow test
		if(readLen == -1){
			NSLog(@"error exit");
			return NO;
		}
		if(readLen == 0)break;
		[data appendBytes:buf length:readLen];
	}
	NSString * text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"ok : %@",text);
	return YES;
}
//multiple defer code and using with finally
//
//output:
//  enter test3
//  catch catch test
//  finally
//  defer code 2
//  stream close
-(BOOL)test3{
	NSLog(@"enter test3");
	NSInputStream *stream = [NSInputStream inputStreamWithFileAtPath:[[NSBundle mainBundle]pathForResource:@"Test" ofType:@"txt"]];
	if(!stream)[NSException raise:NSGenericException format:@"stream open failed"];
	[stream open];
	OMCDefer(
			 NSLog(@"stream close");
			 [stream close];
			 );
	OMCDefer(
			 NSLog(@"defer code 2");
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
	return YES;
}
//exception throw exit
//it works correctly with compile option "-fobjc-arc-exceptions"
//
//output:
//  enter test4
//  stream close
-(BOOL)test4{
	NSLog(@"enter test4");
	NSInputStream *stream = [NSInputStream inputStreamWithFileAtPath:[[NSBundle mainBundle]pathForResource:@"Test" ofType:@"txt"]];
	if(!stream)[NSException raise:NSGenericException format:@"stream open failed"];
	[stream open];
	OMCDefer(
			 NSLog(@"stream close");
			 [stream close];
			 );
	[NSException raise:NSGenericException format:@"non catch test"];
	return YES;
}

-(IBAction)onButton1Click:(UIButton *)sender forEvent:(UIEvent *)event{
	[self test1];
	[self test2];
	[self test3];
	@try{
		[self test4];
	}@catch(NSException *exception){}
}



@end
