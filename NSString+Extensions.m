#import "NSString+Extensions.h"
#import <CommonCrypto/CommonDigest.h>
#define MaxEmailLength 254

@implementation NSString (Extensions)


- (NSNumber*)stringToNSNumber {
    NSNumberFormatter* tmpFormatter = [[NSNumberFormatter alloc] init];
    [tmpFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber* theNumber             = [tmpFormatter numberFromString:self];
    return theNumber;
}

- (BOOL)isEmpty {
    if ([self length] <= 0 || self == (id)[NSNull null] || self == nil) {
        return YES;
    }
    return NO;
}

- (BOOL)stringContainsSubString:(NSString *)subString {
    NSRange aRange = [self rangeOfString:subString];
    if (aRange.location == NSNotFound) {
        return NO;
    }
    
    return YES;
}

- (NSString*)stringByReplacingStringsFromDictionary:(NSDictionary*)dict {
    NSMutableString* string = [self mutableCopy];
    for (NSString* target in dict) {
        [string replaceOccurrencesOfString:target withString:[dict objectForKey:target] options:0 range:NSMakeRange(0, [string length])];
    }
    return string;
}

- (NSString *)filterStringWithCharacterSet:(NSCharacterSet *)separator{
    
    return [[self componentsSeparatedByCharactersInSet:separator]componentsJoinedByString:@""];
}
- (NSArray *)arrayByCharacterSet:(NSCharacterSet *)separator{
    
    return [self componentsSeparatedByCharactersInSet:separator];
}

- (NSString *)filterSpecialString{
    
    NSCharacterSet *doNotWantString = [NSCharacterSet characterSetWithCharactersInString:@"<>![]{}\"（#%-*+=_）\\|~(＜＞$%^&*)_+ "];

    return [NSString stringWithFormat:@"%@",[[self componentsSeparatedByCharactersInSet:doNotWantString]componentsJoinedByString:@""]];
}

-(BOOL)isBlank {
    if([[self stringByStrippingWhitespace] isEqualToString:@""])
        return YES;
    return NO;
}

- (NSString *)stringByStrippingWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)substringFrom:(NSInteger)from to:(NSInteger)to {
    NSString *rightPart = [self substringFromIndex:from];
    return [rightPart substringToIndex:to-from];
}

- (NSArray *)splitOnChar:(NSString *)ch {
    NSMutableArray *results = [[NSMutableArray alloc] init];
    int start = 0;
    BOOL isAtSplitChar= NO;
    for(int i=0; i<[self length]; i++) {
        unichar theChar = [self characterAtIndex:i];
        NSString *str =[NSString stringWithFormat:@"%c",theChar];
        isAtSplitChar   = [str isEqualToString:ch]?YES:NO;
        BOOL isAtEnd    = i == [self length] - 1;
        
        if(isAtSplitChar || isAtEnd) {
            
            NSRange range;
            range.location = start;
            range.length   = i - start + 1;

            if(isAtSplitChar)
                range.length -= 1;
            
            [results addObject:[self substringWithRange:range]];
            start = i + 1;
        }
        if(isAtEnd && isAtSplitChar)
            [results addObject:@""];
    }
    
    return results ;
}

- (NSString*)stringByRemovingPrefix:(NSString*)prefix
{
    NSRange range = [self rangeOfString:prefix];
    if(range.location == 0) {
        return [self stringByReplacingCharactersInRange:range withString:@""];
    }
    return self;
}

- (NSString*)stringByRemovingPrefixes:(NSArray*)prefixes
{
    for(NSString *prefix in prefixes) {
        NSRange range = [self rangeOfString:prefix];
        if(range.location == 0) {
            return [self stringByReplacingCharactersInRange:range withString:@""];
        }
    }
    return self;
}

- (BOOL)hasPrefixes:(NSArray*)prefixes
{
    for(NSString *prefix in prefixes) {
        if([self hasPrefix:prefix])
            return YES;
    }
    return NO;
}

- (BOOL)isEqualToOneOf:(NSArray*)strings
{
    for(NSString *string in strings) {
        if([self isEqualToString:string]) {
            return YES;
        }
    }
    return NO;
}
- (NSString*)add:(NSString*)string
{
    if(!string || string.length == 0)
        return self;
    return [self stringByAppendingString:string];
}

- (NSDictionary*)firstAndLastName
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    NSArray *comps = [self componentsSeparatedByString:@" "];
    if(comps.count > 0) dic[@"firstName"] = comps[0];
    if(comps.count > 1) dic[@"lastName"] = comps[1];
    return dic;
}

- (BOOL)containsOnlyLetters
{
    NSCharacterSet *blockedCharacters = [[NSCharacterSet letterCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
}

- (BOOL)containsOnlyNumbers
{
    NSCharacterSet *numbers = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    return ([self rangeOfCharacterFromSet:numbers].location == NSNotFound);
}

- (BOOL)containsOnlyNumbersAndLetters
{
    NSCharacterSet *blockedCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
}

- (NSString *)removeNumbersFromString:(NSString *)string{
    
    NSString *trimmedString = @"";
    NSArray *stringArray = nil;
    NSCharacterSet *numbersSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789" ];
    stringArray = [string componentsSeparatedByCharactersInSet:numbersSet];
    for (NSString *thisString in stringArray) {
        trimmedString = [trimmedString stringByAppendingString:thisString];
    }
    return trimmedString;
    
}

+ (BOOL)stringIsEmpty:(NSString *) aString {
    
    if ((NSNull *) aString == [NSNull null]) {
        return YES;
    }
    
    if (aString == nil) {
        return YES;
    } else if ([aString length] == 0) {
        return YES;
    } else {
        aString = [aString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([aString length] == 0) {
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL )stringIsEmpty:(NSString *) aString shouldCleanWhiteSpace:(BOOL)cleanWhileSpace {
    
    if ((NSNull *) aString == [NSNull null]) {
        return YES;
    }
    
    if (aString == nil) {
        return YES;
    } else if ([aString length] == 0) {
        return YES;
    }
    
    if (cleanWhileSpace) {
        aString = [aString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([aString length] == 0) {
            return YES;
        }
    }
    
    return NO;
}

//将NSDictionary, NSArray, NSString转换为JSON格式字符串的NSString类目
+ (NSString *) jsonStringWithString:(NSString *) string{
    
    return [NSString stringWithFormat:@"\"%@\"",[[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\"" withString:@"\\"]];
}
+ (NSString *)jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    
    [reString appendString:@"["];
    
    NSMutableArray *values = [NSMutableArray array];
    
    for (id valueObj in array) {
        
        NSString *value = [NSString jsonStringWithObject:valueObj];
        
        if (value) {
            
            [values addObject:[NSString stringWithFormat:@"%@",value]];
            
        }
        
    }
    
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    
    [reString appendString:@"]"];
    
    return reString;
    
}

+ (NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
    
    NSArray *keys = [dictionary allKeys];
    
    NSMutableString *reString = [NSMutableString string];
    
    [reString appendString:@"{"];
    
    NSMutableArray *keyValues = [NSMutableArray array];
    
    for (int i=0; i<[keys count]; i++) {
        
        NSString *name = [keys objectAtIndex:i];
        
        id valueObj = [dictionary objectForKey:name];
        
        NSString *value = [NSString jsonStringWithObject:valueObj];
        
        if (value) {
            
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":\"%@\"",name,value]];
            
        }
        
    }
    
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    
    [reString appendString:@"}"];
    
    return reString;
    
}

+ (NSString *) jsonStringWithObject:(id) object{
    
    NSString *value = nil;
    
    if (!object) {
        
        return value;
        
    }
    
    if ([object isKindOfClass:[NSString class]]) {
        
        value = [NSString jsonStringWithString:object];
        
    }else if([object isKindOfClass:[NSDictionary class]]){
        
        value = [NSString jsonStringWithDictionary:object];
        
    }else if([object isKindOfClass:[NSArray class]]){
        
        value = [NSString jsonStringWithArray:object];
        
    }
    
    return value;
    
}

- (NSArray *)arrayWithJsonString:(NSString *)jsonString{
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    for (NSString *key in dictionary) {
        NSString *str = [dictionary objectForKey:key];
        [tempArr addObject:str];
    }
    return tempArr;
}

+ (BOOL)validateEmail:(NSString *)email{
    
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:email];
    if (isValid && email.length <=MaxEmailLength) {
        return YES;
    }
    return NO;
}

+ (NSString *)filterAlphabet:(NSString *)str{
    NSString *regex = @"[a-zA-Z]";
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *str1 = nil;
    str1 = [reg stringByReplacingMatchesInString:str options:0 range:NSMakeRange(0, [str length]) withTemplate:@""];
    return str1;
    
}

+ (NSString *)filterFigure:(NSString *)str{
    NSString *regex = @"[a-zA-Z]";
    NSArray *array;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *string = [[NSString alloc] init];
    array = [reg matchesInString:str options:0 range:NSMakeRange(0,[str length])];
    for (NSTextCheckingResult *result in array) {
        
        string = [string stringByAppendingString:[str substringWithRange:result.range]];
    }
    return string;
}

+ (NSString *)stringWithReformat:(NSString *)formatStr
{
    formatStr = [formatStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    formatStr = [formatStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    formatStr = [formatStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
    
    formatStr = [formatStr stringByReplacingOccurrencesOfString:@")" withString:@""];
    
    return formatStr;
}
//UTF8编码：汉字占3个字节，英文字符占1个字节
//判断是否有中文
-(BOOL)isChinese:(NSString *)str{
    
    for(int i=0; i< [str length];i++){
    int a = [str characterAtIndex:i];
    if( a > 0x4e00 && a < 0x9fff){
        return YES;
}

}
    return NO;

}
// 判断字符串 ，中文字符 ，字母，数字，以及下划线
-(BOOL)isChineseCharacterAndLettersAndNumbersAndUnderScore:(NSString *)string
{
    int len = (int)string.length;
    for(int i=0;i<len;i++)
    {
        unichar a=[string characterAtIndex:i];
        if(!((isalpha(a))
             ||(isalnum(a))
             ||((a=='_'))
             ||((a >= 0x4e00 && a <= 0x9fa6))
             ))
            return NO;
    }
    return YES;
}
-(BOOL)isPureNumberCharacters{
    
    if ([self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]].length >0) {
        return NO;
    }
    return YES;
}
- (BOOL)isAllNum{
    unichar c;
    for (int i = 0; i<self.length; i ++) {
        c= [self characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}
-(BOOL)isPureInt{
    NSScanner *scanner =[NSScanner scannerWithString:self];
    int val;
    return [scanner scanInt:&val] && [scanner isAtEnd];
}
@end
