# What

ObjectiveCで、スコープを抜ける時に実行したい処理を先に記述できるマクロ。
Go言語のdefer文やC++/BoostのScopeExitに似ています。

In Objective-C, you can write code that you want to run at exiting scope on ahead by this macro.
It looks like defer statement in Go language Or Boost.ScopeExit in C++ language.

# Before After

## Before

~~~Objective-C
-(BOOL)hoge{
	NSInputStream *stream = [NSInputStream inputStreamWith...];
	if(!stream)return NO;
	[stream open];
	while(YES){
		uint8_t buf[1024];
		int readLen = [stream read:buf maxLength:sizeof(buf)];
		if(readLen == -1){
			[stream close]; // ★1
			return NO;
		}
		process(buf);
	}
	[stream close]; // ★2
	return YES;
}
~~~

ストリーム処理など、return箇所が複数あると、それら全てでcloseなどの片付け処理を書く必要があります。
エラーケースなどでこれを書き忘れるとバグの原因になります。

For example , in stream processing , you must write cleanup code such as calling "close".
If you forget to write on error case and other , it causes bug.

## After

~~~Objective-C
-(BOOL)hoge{
	NSInputStream *stream = [NSInputStream inputStreamWith...];
	if(!stream)return NO;
	[stream open];
	OMCDefer(
		[stream close]; //★
	);
	while(YES){
		uint8_t buf[1024];
		int readLen = [stream read:buf maxLength:sizeof(buf)];
		if(readLen == -1)return NO;
		process(buf);
	}
	return YES;
}
~~~

このマクロを使うと、スコープを抜ける時に実行したいコードを好きな場所に書けます。
どこでreturnしてもそのタイミングでコードが実行されます。
openの直後にcloseを書く事ができるので、コードとしても対応関係がわかりやすくなります。

Using this macro , you can write code that you want to run at exiting scope on anywhere .
Code run when execute any return statement.
You can write "close" in shortly after "open", so correspondence relation of code will be easily comprehensible.



