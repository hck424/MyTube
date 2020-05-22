//
//  SearchHistory+CoreDataProperties.m
//  
//
//  Created by 김학철 on 2020/05/20.
//
//

#import "SearchHistory+CoreDataProperties.h"

@implementation SearchHistory (CoreDataProperties)

+ (NSFetchRequest<SearchHistory *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"SearchHistory"];
}

@dynamic searchWord;
@dynamic searchDate;

@end
