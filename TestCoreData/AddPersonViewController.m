//
//  AddPersonViewController.m
//  TestCoreData
//
//  Created by Mike Chen on 13-6-4.
//  Copyright (c) 2013年 BeyondSoft Co.,Ltd. All rights reserved.
//

#import "AddPersonViewController.h"
#import <CoreData/CoreData.h>
#import "Person.h"
#import "AppDelegate.h"

@interface AddPersonViewController ()

@property (nonatomic ,retain) UITextField *textFieldFirstName;
@property (nonatomic ,retain) UITextField *textFieldLastName;
@property (nonatomic , retain)UITextField *textFieldAge;
@property (nonatomic , retain)UIBarButtonItem *barButtonAdd;

@end

@implementation AddPersonViewController

@synthesize textFieldAge = _textFieldAge;
@synthesize textFieldFirstName = _textFieldFirstName;
@synthesize textFieldLastName = _textFieldLastName;
@synthesize barButtonAdd = _barButtonAdd;

- (void)dealloc
{
    [_textFieldLastName release];
    [_textFieldFirstName release];
    [_textFieldAge release];
    [_barButtonAdd release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"New Person";
    CGRect textFieldRect = CGRectMake(20, 20, self.view.bounds.size.width - 40, 31);
    self.textFieldFirstName = [[[UITextField alloc] initWithFrame:textFieldRect] autorelease];
    self.textFieldFirstName.placeholder = @"First Name";
    self.textFieldFirstName.borderStyle = UITextBorderStyleRoundedRect;
    self.textFieldFirstName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.textFieldFirstName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.textFieldFirstName];
    
    textFieldRect.origin.y += 37;
    self.textFieldLastName = [[[UITextField alloc] initWithFrame:textFieldRect] autorelease];
    self.textFieldLastName.placeholder = @"Last Name";
    self.textFieldLastName.borderStyle = UITextBorderStyleRoundedRect;
    self.textFieldLastName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.textFieldLastName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.textFieldLastName];
    
    textFieldRect.origin.y += 37;
    self.textFieldAge = [[[UITextField alloc] initWithFrame:textFieldRect] autorelease];
    self.textFieldAge.placeholder = @"Age";
    self.textFieldAge.borderStyle = UITextBorderStyleRoundedRect;
    self.textFieldAge.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.textFieldAge.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.textFieldAge];

    self.barButtonAdd = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(createNewPerson:)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationItem setRightBarButtonItem:self.barButtonAdd animated:YES];
    [self.textFieldFirstName becomeFirstResponder];
}

- (void)createNewPerson:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    Person *newPerson = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:managedObjectContext];
    if (newPerson) {
        newPerson.firstName = self.textFieldFirstName.text;
        newPerson.lastName = self.textFieldLastName.text;
        newPerson.age = [NSNumber numberWithInteger:[self.textFieldAge.text integerValue]];
        NSError *savingError = nil;
        if ([managedObjectContext save:&savingError]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else{
            NSLog(@"往CoreData保存失败.");
        }
    } else{
        NSLog(@"Failed to create the new person object.");
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.textFieldFirstName resignFirstResponder]) {
    } else if ([self.textFieldLastName resignFirstResponder]){
    }else if ([self.textFieldAge resignFirstResponder]){
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
