//
//  ToDoListItem.m
//  ToDoList2
//
//  Created by Ricardo Bedoya on 8/18/13.
//  Copyright (c) 2013 Ricardo Bedoya. All rights reserved.
//

#import "ToDoListItem.h"

@implementation ToDoListItem

#pragma  mark - Loading the file

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.toDoItemText = [aDecoder decodeObjectForKey:@"Task"];
    }
    return self;
}


#pragma mark - encodeWithCoder method

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.toDoItemText forKey:@"Task"];
}


@end
