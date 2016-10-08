//
//  ViewController.m
//  ChatClient
//
//  Created by 刘ToTo on 16/9/23.
//  Copyright © 2016年 com.365ime. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSStreamDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
}

@property (weak, nonatomic) IBOutlet UITextField *textFeild;
@property (weak, nonatomic) IBOutlet UITableView *ListView;

@property (nonatomic, strong) NSMutableArray *chatMsgs;//聊天消息数组

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *host = @"192.168.90.16";
    int port = 4700;
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)host, port, &readStream, &writeStream);
    
    inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    
    inputStream.delegate = self;
    outputStream.delegate = self;
    
    [inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
    
}

#pragma mark - NSStreamDelegete
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
            NSLog(@"输入输出流打开完成");
            break;
            
        case NSStreamEventHasBytesAvailable:
            NSLog(@"有字节可读");
            //                       [self readData];
            break;
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"可以发送字节");
            break;
        case NSStreamEventErrorOccurred:
            NSLog(@" 连接出现错误");
            break;
        case NSStreamEventEndEncountered:
            NSLog(@"连接结束");
            
            // 关闭输入输出流
            [inputStream close];
            [outputStream close];
            
            // 从主运行循环移除
            [inputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
            [outputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
            break;
    }
}

- (IBAction)sendMessage:(id)sender {
    
}

#pragma mark - loader
-(NSMutableArray *)chatMsgs{
    if (!_chatMsgs) {
        _chatMsgs = [NSMutableArray array];
    }
    
    return _chatMsgs;
}

@end
