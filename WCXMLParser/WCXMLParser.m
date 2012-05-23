//
//  WCXMLParser.m
//  Matters
//
//  Created by Wess Cope on 5/22/12.
//  Copyright (c) 2012 Wess Cope. All rights reserved.
//

#import "WCXMLParser.h"

@interface WCXMLParser()
{
    NSXMLParser         *_parser;
    NSMutableArray      *_resultsArray;
    NSMutableString     *_processingText;
}
- (void)initialize;
@end

@implementation WCXMLParser
@synthesize successCallback = _successCallback;
@synthesize errorCallback   = _errorCallback;
@synthesize options         = _options;

- (void)initialize
{
    _parser.delegate    = self;
    _resultsArray       = [[NSMutableArray alloc] init];
    _processingText     = [[NSMutableString alloc] init];
}

- (id)initWithParser:(NSXMLParser *)parser
{
    self = [super init];
    if(self)
    {
        _parser = parser;
        [self initialize];
    }
    return self;
}

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if(self)
    {
        _parser             = [[NSXMLParser alloc] initWithData:data];
        [self initialize];
    }
    return self;
}

- (void)setOptions:(WCXMLParserOptions)options
{
    _parser.shouldReportNamespacePrefixes    = (options & WCXMLParserReportNamespacePrefixes);
    _parser.shouldProcessNamespaces          = (options & WCXMLParserProcessNamespaces);
    _parser.shouldResolveExternalEntities    = (options & WCXMLParserResolveExternalEntities);
}

- (void)parse
{
    [_parser parse];
}

#pragma mark - NXMLParser Delegate Methods
-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    _resultsArray   = nil;
    _resultsArray   = [[NSMutableArray alloc] init];
    _processingText = nil;
    _processingText = [[NSMutableString alloc] init];
    
    [_resultsArray addObject:[NSMutableDictionary dictionary]];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSMutableDictionary *parentDictionary = [_resultsArray lastObject];
    
    NSMutableDictionary *childDictionary = [NSMutableDictionary dictionary];
    [childDictionary addEntriesFromDictionary:attributeDict];
    
    id tmpValue = [parentDictionary objectForKey:elementName];

    if(tmpValue)
    {
        NSMutableArray *tmpArray = nil;
        if([tmpValue isKindOfClass:[NSMutableArray class]])
        {
            tmpArray = (NSMutableArray *)tmpValue;
        }
        else 
        {
            tmpArray = [NSMutableArray array];
            [tmpArray addObject:tmpValue];
            
            [parentDictionary setObject:tmpArray forKey:elementName];
        }
        
        [tmpArray addObject:childDictionary];
    }
    else 
    {
        [parentDictionary setObject:childDictionary forKey:elementName];
    }
    
    [_resultsArray addObject:childDictionary];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [_processingText appendString:[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSMutableDictionary *progressDictionary = [_resultsArray lastObject];
    if(_processingText.length > 0)
    {
        [progressDictionary setObject:_processingText forKey:@"text"];
        _processingText = nil;
        _processingText = [[NSMutableString alloc] init];
    }
    
    [_resultsArray removeLastObject];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"ERROR: %@", [parseError description]);
        _errorCallback(self, parseError);
    });
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSDictionary *result = [_resultsArray objectAtIndex:0];
        _successCallback(self, result);        
    });
}

#pragma mark - Simple Method
+ (void)parseWithParser:(NSXMLParser *)parser success:(WCXMLParserSuccessCallback)success failure:(WCXMLParserErrorCallback)failure
{
    
}

+ (void)parseXMLString:(NSString *)string withOptions:(WCXMLParserOptions)options success:(WCXMLParserSuccessCallback)success failure:(WCXMLParserErrorCallback)failure
{
    NSData *xmlData             = [string dataUsingEncoding:NSUTF8StringEncoding];
    [WCXMLParser parseXMLData:xmlData withOptions:options success:success failure:failure];
}

+ (void)parseXMLData:(NSData *)data withOptions:(WCXMLParserOptions)options success:(WCXMLParserSuccessCallback)success failure:(WCXMLParserErrorCallback)failure
{
    WCXMLParser *wcParser       = [[WCXMLParser alloc] initWithData:data];
    wcParser.successCallback    = success;
    wcParser.errorCallback      = failure;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [wcParser parse]; 
    });
    
}

+ (void)parseContentFromURL:(NSURL *)url withOptions:(WCXMLParserOptions)options success:(WCXMLParserSuccessCallback)success failure:(WCXMLParserErrorCallback)failure
{
    NSString *content = [[NSString alloc] initWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
    [WCXMLParser parseXMLString:content withOptions:0 success:success failure:failure];
}
@end
