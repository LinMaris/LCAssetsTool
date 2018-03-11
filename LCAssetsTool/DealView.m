//
//  DealView.m
//  LCAssetsTool
//
//  Created by 林川 on 2018/3/10.
//  Copyright © 2018年 林川. All rights reserved.
//

#import "DealView.h"

@implementation DealView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    // Drawing code here.
    [self registerForDraggedTypes:[NSArray arrayWithObjects: NSFilenamesPboardType, nil]];
}

BOOL canDrag = NO;
- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pb =[sender draggingPasteboard];
    NSArray *array=[pb types];
    
    if ([array containsObject:NSFilenamesPboardType]) {
        
        NSArray* allFileUrls = [pb propertyListForType:NSFilenamesPboardType];
        NSArray* array = [allFileUrls filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension.lowercaseString IN %@", @[@"car"]]];
        if (array.count > 0) {
            canDrag = YES;
            return NSDragOperationCopy;
        }
    }
    return NSDragOperationNone;
}

-(NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender
{
    if (canDrag) {
        return NSDragOperationCopy;
    }
    return NSDragOperationNone;
}

-(void)draggingEnded:(id<NSDraggingInfo>)sender
{
    NSArray* allFileUrls = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
    NSArray* fileURLarray = [allFileUrls filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension.lowercaseString IN %@", @[@"car"]]];
    
    // 这里不对拖入的文件做限制, 方便执行脚本文件
    fileURLarray = allFileUrls;
    
    if (fileURLarray.count>1) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"确认"];
        [alert setMessageText:@"提示"];
        [alert setInformativeText:@"请拖入一个.car文件"];
        [alert setAlertStyle:NSAlertStyleInformational];
        [alert runModal];
    }
    else if (fileURLarray.count > 0) {
        if (self.didDragEnd) {
            self.didDragEnd(fileURLarray[0]);
        }
    }
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    return YES;
}

@end
