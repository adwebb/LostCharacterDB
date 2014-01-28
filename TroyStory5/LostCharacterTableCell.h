//
//  LostCharacterTableCell.h
//  LostCharactersDB
//
//  Created by Andrew Webb on 1/28/14.
//  Copyright (c) 2014 Andrew Webb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LostCharacterTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timelineLabel;
@property (weak, nonatomic) IBOutlet UILabel *characterTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *actorTextLabel;

@end
