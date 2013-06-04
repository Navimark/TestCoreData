//
//  PersonListViewController.m
//  TestCoreData
//
//  Created by Mike Chen on 13-6-4.
//  Copyright (c) 2013年 BeyondSoft Co.,Ltd. All rights reserved.
//

#import "PersonListViewController.h"
#import "AddPersonViewController.h"
#import "Person.h"
#import "AppDelegate.h"

@interface PersonListViewController ()

@property (nonatomic , retain) UITableView *tableViewPersons;
@property (nonatomic , retain) UIBarButtonItem *barButtonAddPerson;
@property (nonatomic , retain) NSFetchedResultsController *personsFRC;

@end

@implementation PersonListViewController

@synthesize tableViewPersons = _tableViewPersons;
@synthesize barButtonAddPerson = _barButtonAddPerson;
@synthesize personsFRC = _personsFRC;

- (NSManagedObjectContext *)managedObjectContext
{
    return [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
}

- (void)dealloc
{
    [_tableViewPersons release];
    [_barButtonAddPerson release];
    [_personsFRC release];
    [super dealloc];
}

- (id)init
{
    if ((self = [super init])) {
        //
        NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:[self managedObjectContext]];
        NSSortDescriptor *ageSort = [[[NSSortDescriptor alloc] initWithKey:@"age" ascending:YES] autorelease];
        NSSortDescriptor *firstNameSort = [[[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES] autorelease];
        NSArray *sortDescriptors = @[ageSort,firstNameSort];
        fetchRequest.sortDescriptors = sortDescriptors;
        [fetchRequest setEntity:entity];
        self.personsFRC = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
        self.personsFRC.delegate = self;
        NSError *fetchingError = nil;
        if ([self.personsFRC performFetch:&fetchingError]) {
            NSLog(@"Successfully fetched.");
        } else{
            NSLog(@"Failed to fetch.");
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Persons";
    self.tableViewPersons = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
    self.tableViewPersons.delegate = self;
    self.tableViewPersons.dataSource = self;
    [self.view addSubview:self.tableViewPersons];
    self.barButtonAddPerson = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewPerson:)] autorelease];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationItem setLeftBarButtonItem:[self editButtonItem] animated:YES];
    [self.navigationItem setRightBarButtonItem:_barButtonAddPerson animated:YES];
}

- (void)addNewPerson:(id)sender
{
    AddPersonViewController *controller = [[[AddPersonViewController alloc] init] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.personsFRC.sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    Person *person = [self.personsFRC objectAtIndexPath:indexPath];
    cell.textLabel.text = [person.firstName stringByAppendingFormat:@" %@",person.lastName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Age:%d",[person.age integerValue]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    Person *personToDelete = [self.personsFRC objectAtIndexPath:indexPath];
    self.personsFRC.delegate = nil;
    [[self managedObjectContext] deleteObject:personToDelete];
    if ([personToDelete isDeleted]) {
        NSError *savingError = nil;
        if ([[self managedObjectContext] save:&savingError]) {
            NSError *fetchingError = nil;
            if ([self.personsFRC performFetch:&fetchingError]) {
                NSLog(@"Successfully fetched.");
                NSArray *rowsToDelete = @[indexPath];
                [self.tableViewPersons deleteRowsAtIndexPaths:rowsToDelete withRowAnimation:UITableViewRowAnimationAutomatic];
            } else{
                NSLog(@"Failed to fetch with error = %@",fetchingError);
            }
        } else{
            NSLog(@"Failed to save the context with error = %@",savingError);
        }
    }
    self.personsFRC.delegate = self;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//系统编辑按钮的响应
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (editing) {
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    } else{
        [self.navigationItem setRightBarButtonItem:self.barButtonAddPerson animated:YES];
    }
    [self.tableViewPersons setEditing:editing animated:YES];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableViewPersons reloadData];
}

@end
