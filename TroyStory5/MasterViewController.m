//
//  ViewController.m
//  TroyStory5
//
//  Created by Andrew Webb on 1/28/14.
//  Copyright (c) 2014 Andrew Webb. All rights reserved.
//

#import "MasterViewController.h"
#import "LostCharacter.h"
#import "LostCharacterTableCell.h"
@import CoreData;

@interface MasterViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    IBOutlet UITableView* lostTableView;
    IBOutlet UITextField* characterNameTextField;
    IBOutlet UITextField* actorNameTextField;
    IBOutlet UITextField* introducedDateTextField;
    IBOutlet UITextField* killedDateTextField;
    
    NSMutableArray* lostCharacters;
    NSIndexPath* deletePath;
    BOOL sortDirection;
   // NSArray* losers;
}
@end

@implementation MasterViewController
@synthesize managedObjectContext;
- (void)viewDidLoad
{
    [super viewDidLoad];
    sortDirection = YES;
	[self reload];
}

-(IBAction)onAddLostCharacterButtonPressed:(id)sender
{
    [self addLostCharacter:characterNameTextField.text
                  playedBy:actorNameTextField.text
          introducedOnDate:introducedDateTextField.text
                  killedOn:killedDateTextField.text];
    
    [self reload];
}

-(void)addLostCharacter:(NSString*)characterName
               playedBy:(NSString*)actorName
       introducedOnDate:(NSString*)introducedDate
               killedOn:(NSString*)killedDate
{
    LostCharacter* lostCharacter = [NSEntityDescription insertNewObjectForEntityForName:@"LostCharacter" inManagedObjectContext:managedObjectContext];
    lostCharacter.characterName = characterName;
    lostCharacter.actorName = actorName;
    lostCharacter.dateIntroduced = introducedDate;
    lostCharacter.dateKilled = killedDate;
    
    [self resetTextFields];
    [managedObjectContext save:nil];
}

-(void)resetTextFields
{
    [characterNameTextField resignFirstResponder];
    [actorNameTextField resignFirstResponder];
    [introducedDateTextField resignFirstResponder];
    [killedDateTextField resignFirstResponder];
    characterNameTextField.text = @"";
    actorNameTextField.text = @"";
    introducedDateTextField.text = @"";
    killedDateTextField.text = @"";
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(!([characterNameTextField.text isEqualToString:@""] && [actorNameTextField.text isEqualToString:@""]))
    {
        [self onAddLostCharacterButtonPressed:nil];
    }
    [textField resignFirstResponder];
    return YES;
}

-(void)reload
{
    NSFetchRequest* request = [[NSFetchRequest alloc]initWithEntityName:@"LostCharacter"];
    NSSortDescriptor* characterSortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"characterName" ascending:sortDirection selector:@selector(caseInsensitiveCompare:)];
    NSSortDescriptor* actorSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"actorName" ascending:sortDirection];
    request.sortDescriptors = @[characterSortDescriptor,actorSortDescriptor];
//    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"prowess > 5"];
//    request.predicate = predicate;
    lostCharacters = [managedObjectContext executeFetchRequest:request error:nil].mutableCopy;
    
    if (lostCharacters.count == 0)
    {
        [self load];
        for (NSDictionary* lostCharacterDictionary in lostCharacters) {
            [self addLostCharacter:lostCharacterDictionary[@"passenger"] playedBy:lostCharacterDictionary[@"actor"] introducedOnDate:@"" killedOn:@""];
        }
    }
    
    
//    request = [[NSFetchRequest alloc]initWithEntityName:@"Lover"];
//    nameSortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
//    prowessSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"prowess" ascending:NO];
//    request.sortDescriptors = @[prowessSortDescriptor,nameSortDescriptor];
//    predicate = [NSPredicate predicateWithFormat:@"prowess <= 5"];
//    request.predicate = predicate;
//    losers = [managedObjectContext executeFetchRequest:request error:nil];
    
    [lostTableView reloadData];
}

-(IBAction)onSortButtonPressed:(id)sender
{
    sortDirection = !sortDirection;
    [self reload];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LostCharacterTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"LostCharacterID"];
    LostCharacter* lostCharacter;
    
    //if (indexPath.section == 0) {
        lostCharacter = lostCharacters[indexPath.row];
//    }else{
//        lover = losers[indexPath.row];
//    }
   
    cell.characterTextLabel.text = lostCharacter.characterName;
    cell.actorTextLabel.text = lostCharacter.actorName;
    
    NSString* timeline = [NSString stringWithFormat:@"%@-%@",lostCharacter.dateIntroduced, lostCharacter.dateKilled];
    cell.timelineLabel.text = timeline;
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //if (section == 0) {
        return lostCharacters.count;
//    }else{
//        return losers.count;
//    }
}

//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    //if (section == 0) {
//        return @"Lost Characters";
////    }else{
////        return @"Losers";
////    }
//}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"SMOKE MONSTER";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteItem:indexPath];
    }
}

-(void)deleteItem:(NSIndexPath *)indexPath {
    deletePath = indexPath;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Eat Character?" message:@"You evil smoke monster, you." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Consume", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [lostCharacters removeObjectAtIndex:deletePath.row];
        [self reload];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)load
{
    lostCharacters = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:@"http://s3.amazonaws.com/mobile-makers-assets/app/public/ckeditor_assets/attachments/2/lost.plist"]];
}

@end
