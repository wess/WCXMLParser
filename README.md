WCXMLParser
==========
WCXMLParser is a block based XML parser based on NSXMLParser, with a pretty package wrapped around it. Syntax/Structure inspired by AFNetworking (I built it to work with AFNetworking's AFXMLRequestOperation and not have to use delegates).  Wanted to make parsing XML painless as possible.

### Using WCXMLParser
To use, simply drop the WXCMLParser.m/.h files into your project (fyi, it is ARC), include the .h file and you should be ready to go.

---

#### WCXMLParser Methods

```objectivec
/**
	Your WCXMLParser options are pretty much the same as the NSXMLParser ones
	 	WCXMLParserProcessNamespaces
    	WCXMLParserReportNamespacePrefixes
    	WCXMLParserResolveExternalEntities
 */

// Already have a parser, you can throw it in to use with the callbacks (looking at you AFNetworking)
+ (void)parseWithParser:(NSXMLParser *)parser success:(WCXMLParserSuccessCallback)success failure:(WCXMLParserErrorCallback)failure;

// Parse using an XML String
+ (void)parseXMLString:(NSString *)string withOptions:(WCXMLParserOptions)options success:(WCXMLParserSuccessCallback)success failure:(WCXMLParserErrorCallback)failure;

// Parse with data
+ (void)parseXMLData:(NSData *)data withOptions:(WCXMLParserOptions)options success:(WCXMLParserSuccessCallback)success failure:(WCXMLParserErrorCallback)failure;

// Even parse XML from a URL (RSS/ATOM feed for example)
+ (void)parseContentFromURL:(NSURL *)url withOptions:(WCXMLParserOptions)options success:(WCXMLParserSuccessCallback)success failure:(WCXMLParserErrorCallback)failure;

```

### Example
```objectivec

    [WCXMLParser parseContentFromURL:[NSURL URLWithString:@"https://github.com/wess.atom"] withOptions:0 success:^(WCXMLParser *parser, id parsedObject) {
        for(NSDictionary *entry in [[parsedObject objectForKey:@"feed"] objectForKey:@"entry"])
            [_items addObject:[[entry objectForKey:@"title"] objectForKey:@"text"]];
        
        [self.tableView reloadData];
    } failure:^(WCXMLParser *parser, NSError *error) {
        NSLog(@"PARSE ERROR: %@", [error description]);        
    }];

```


---

#### Notes:
- This project uses ARC
- This is still in early stages

---


If you have an suggestions, contributes, etc.. Feel free to send me a message here or hit me up on twitter (@wesscope) and I will do what I can to get back with ya.

Thanks, 
Wess