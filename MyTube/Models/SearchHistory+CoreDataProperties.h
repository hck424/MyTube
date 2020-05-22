//
//  SearchHistory+CoreDataProperties.h
//  
//
//  Created by 김학철 on 2020/05/20.
//
//

#import "SearchHistory+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SearchHistory (CoreDataProperties)

+ (NSFetchRequest<SearchHistory *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *searchWord;
@property (nullable, nonatomic, copy) NSDate *searchDate;

@end

NS_ASSUME_NONNULL_END
