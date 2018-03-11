//
//  ViewController.m
//  LCAssetsTool
//
//  Created by 林川 on 2018/3/10.
//  Copyright © 2018年 林川. All rights reserved.
//

#import "ViewController.h"
#import "DealView.h"

#define kDefaultValue @"将.car的文件拖动灰色区域"
// 请将Assets.car文件拖入到此框中
@interface ViewController()

@property (weak) IBOutlet NSTextField *srcLabel;

@property (weak) IBOutlet NSButton *dealBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.srcLabel.stringValue = kDefaultValue;
    
    // 创建拖动区域
    DealView *v = [[DealView alloc] initWithFrame:NSMakeRect(0, 80, self.view.bounds.size.width, self.view.bounds.size.height-80)];
    v.wantsLayer = YES;
    v.layer.backgroundColor = [[NSColor grayColor] CGColor];
    v.alphaValue = 0.6;
    [self.view addSubview:v];
    
    // 取出拖入文件的全路径
    [v setDidDragEnd:^(NSString *url) {
        self.srcLabel.stringValue = url;
    }];
}

- (IBAction)btnClick:(NSButton *)sender {
    
    if ([self.srcLabel.stringValue isEqualToString:kDefaultValue]) {
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"确认"];
        [alert setMessageText:@"提示"];
        [alert setInformativeText:@"请拖入一个.car文件"];
        [alert setAlertStyle:NSAlertStyleInformational];
        [alert runModal];
        return;
    }
    
    NSString *desiPath = [NSString stringWithFormat:@"%@/Assets.car目录", [self.srcLabel.stringValue stringByDeletingLastPathComponent]];
    
    // 创建 目标文件的目录
    NSString *mkDirCmd = [NSString stringWithFormat:@"mkdir %@",desiPath];
    
    // carTool工具  源文件  目标文件
    NSString *executeCmd = [NSString stringWithFormat:@"%@ %@ %@",[self carToolPtah], self.srcLabel.stringValue, desiPath];
    
    // 执行命令
    [self runScript:@[mkDirCmd,executeCmd]];
    
    // 执行脚本文件
//    [self runFile:self.srcLabel.stringValue];
}

- (NSString *)carToolPtah
{
    return [NSString stringWithFormat:@"%@/Contents/Resources/cartool",[NSBundle mainBundle].bundlePath];
}

- (NSString *)runScript:(NSArray *)commandArr
{
    // 初始化并设置shell 执行命令的路径(命令解释器)
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/bin/sh";
    // -c 用来执行string-commands（命令字符串），
    // 也就说不管后面的字符串里是什么都会被当做shellcode来执行
    
    task.arguments = @[@"-c",[self strFromArray:commandArr]];
    
    // 新建输出管道作为Task的输出
    NSPipe *pipe = [NSPipe pipe];
    task.standardOutput = pipe;
    
    // 开始task
    NSFileHandle *fileHandle = [pipe fileHandleForReading];
    [task launch];
    
    // 获取运行结果
    NSData *data = [fileHandle readDataToEndOfFile];
    NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return output;
}

- (NSString *)runFile:(NSString *)scriptPath {
    
    // 若出现Permission Denied ,则需要通过chmod +x filename 赋予可执行权限
    return [self runScript:@[[NSString stringWithFormat:@"chmod +x %@",scriptPath], scriptPath]];
}

#pragma mark - Other
// 将字符串数组中的元素 以 ; 拼接成新的字符串
-(NSString *)strFromArray:(NSArray *)array
{
    NSMutableString *resultStr = [NSMutableString string];
    NSUInteger count = array.count;
    for (NSInteger i = 0; i < count; i++) {
        
        i == count - 1 ? [resultStr appendString:array[i]] :
        [resultStr appendFormat:@"%@;",array[i]];
    }
    return resultStr;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

@end
