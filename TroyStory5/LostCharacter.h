//
//  Lover.h
//  TroyStory5
//
//  Created by Andrew Webb on 1/28/14.
//  Copyright (c) 2014 Andrew Webb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LostCharacter : NSManagedObject

@property (nonatomic, retain) NSString * characterName;
@property (nonatomic, retain) NSString * actorName;
@property (nonatomic, retain) NSString * dateIntroduced;
@property (nonatomic, retain) NSString * dateKilled;

@end
