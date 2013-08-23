//
//  ToDoListViewController.m
//  ToDoList2
//
//  Created by Ricardo Bedoya on 8/18/13.
//  Copyright (c) 2013 Ricardo Bedoya. All rights reserved.
//

#import "ToDoListViewController.h"
#import "ToDoListCustomCell.h"
#import "ToDoListItem.h"

@interface ToDoListViewController ()

@end

@implementation ToDoListViewController {
    NSMutableArray *toDoItems;
}

#pragma mark - Adding persistance

- (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
}

- (NSString *)dataFilePath
{
    return [[self documentsDirectory] stringByAppendingPathComponent:@"ToDoList.plist"];
}

#pragma mark - Save and Load ToDo items

- (void)saveToDoListItems
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:toDoItems forKey:@"ToDoListItems"];
    [archiver finishEncoding];
    
    [data writeToFile:[self dataFilePath] atomically:YES];
}

- (void)loadToDoListItems
{
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        toDoItems = [unarchiver decodeObjectForKey:@"ToDoListItems"];
        [unarchiver finishDecoding];
    } else {
        toDoItems = [[NSMutableArray alloc] initWithCapacity:20];
    }
}

#pragma mark - initWithCoder method

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self loadToDoListItems];
    }
    return self;
}

#pragma mark viewDidLoad method

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Documents folder is %@", [self documentsDirectory]);
    NSLog(@"Data file path is %@", [self dataFilePath]);
    
    self.title = @"To Do List";
    [self setupNavigationBar];
    
    toDoItems = [[NSMutableArray alloc] initWithCapacity:20];
    
    UINib *customNib = [UINib nibWithNibName:@"ToDoListCustomCell" bundle:nil];
    [self.tableView registerNib:customNib forCellReuseIdentifier:@"MyCustomCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Add and Done button methods

- (void)onAddButton
{
    NSLog(@"Add button was tapped");
    ToDoListItem *item;
    item = [[ToDoListItem alloc] init];
    
    [toDoItems addObject:item];
    
    [self saveToDoListItems];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)onDoneButton
{
    NSLog(@"Done button was tapped");
    [self.view endEditing:YES];
}


#pragma mark - UITableView Data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return toDoItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MyCustomCell";
    
    ToDoListCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //UILabel *label = (UILabel *)[cell viewWithTag:1000];
    cell.toDoItemTextField.text = @"New Task";
    cell.toDoItemTextField.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextField Delegates

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDoneButton)];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self setupNavigationBar];
    [self saveToDoListItems];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self saveToDoListItems];
    return YES;
}


#pragma mark - Editing UITableView cells

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [toDoItems removeObjectAtIndex:indexPath.row];
    
    [self saveToDoListItems];
    
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - Rearringing UITableView cells

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *stringToMove = [toDoItems objectAtIndex:sourceIndexPath.row];
    [toDoItems removeObjectAtIndex:sourceIndexPath.row];
    [toDoItems insertObject:stringToMove atIndex:destinationIndexPath.row];
}

#pragma mark - Setup

- (void)setupNavigationBar
{
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                              target:self
                                              action:@selector(onAddButton)];
}



@end
