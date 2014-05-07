//
//  AEAppDelegate.m
//  AutoEncoder
//
//  Created by Sudeep Sidhu on 2014-04-10.
//  Copyright (c) 2014 Tipping Canoe. All rights reserved.
//

#import "AEAppDelegate.h"

@implementation AEAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [_txtInput setTextColor:[NSColor blackColor]];
    [_txtOutput setTextColor:[NSColor blackColor]];
}

- (IBAction)doIt:(id)sender{
    
    NSArray *vars = [self extractVariables:_txtInput.string];
    [self encodifyVars:vars];
}

- (NSArray*)extractVariables:(NSString *)input{
    
    NSMutableArray *lines =  [NSMutableArray arrayWithArray:[input componentsSeparatedByString:@"\n"]];
    NSMutableArray *vars = [NSMutableArray array];
    
    //regex to grab everything between the last " " and ";"
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"( )(?!.* )(.*?)(?=;)" options:NSRegularExpressionCaseInsensitive error:nil];
    
    for (NSString *l in lines) {
        
        NSString *line = [l stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (line.length) {
            NSArray* matches = [regex matchesInString:line options:0 range:[line rangeOfString:line]];
            
            if (matches.count == 1) {
                NSTextCheckingResult *firstMatch = [matches firstObject];
                NSString *cleanedVar = [[line substringWithRange:firstMatch.range] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"* \n"]];
                
                [vars addObject:cleanedVar];
            }
        }
    }
    

    return vars;
}

- (void)encodifyVars:(NSArray*)variables{
    
    [_txtOutput setString:@""];
    
    NSAttributedString *initBeginString = [[NSAttributedString alloc] initWithString:@"- (instancetype)initWithCoder:(NSCoder *)aDecoder{\n\n\tself = [super initWithCoder:aDecoder];\n\n\tif (self) {\n\n"];
    
    [_txtOutput.textStorage appendAttributedString:initBeginString];
    
    for (NSString *var in variables) {
        
        NSAttributedString *decodeString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\t\tself.%@ = [aDecoder decodeObjectForKey:@\"%@\"];\n",var, var]];
        [_txtOutput.textStorage appendAttributedString:decodeString];
    }
    
    NSAttributedString *initEndString = [[NSAttributedString alloc] initWithString:@"\t}\n\n\treturn self;\n}\n\n\n"];
    
    [_txtOutput.textStorage appendAttributedString:initEndString];

    
    NSAttributedString *encodeBeginString = [[NSAttributedString alloc] initWithString:@"- (void)encodeWithCoder:(NSCoder *)aCoder{\n\n\t[super encodeWithCoder:aCoder];\n\n"];
    
    [_txtOutput.textStorage appendAttributedString:encodeBeginString];

    for (NSString *var in variables) {
        
        NSAttributedString *decodeString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\t[aCoder encodeObject:self.%@ forKey:@\"%@\"];\n",var, var]];
        [_txtOutput.textStorage appendAttributedString:decodeString];
    }
    
    NSAttributedString *encodeEndString = [[NSAttributedString alloc] initWithString:@"}\n\n\n"];

    [_txtOutput.textStorage appendAttributedString:encodeEndString];
    
    NSAttributedString *copyBeginString = [[NSAttributedString alloc] initWithString:@"- (instancetype)copyWithZone:(NSZone *)zone{\n\n\ttypeof(self) copy = [super copyWithZone:zone];\n\n\tif (copy) {\n"];
    
    [_txtOutput.textStorage appendAttributedString:copyBeginString];
    
    for (NSString *var in variables) {
        
        NSAttributedString *copyString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\t\tcopy.%@ = [self.%@ copyWithZone:zone];\n",var, var]];
        [_txtOutput.textStorage appendAttributedString:copyString];
    }
    
    NSAttributedString *copyEndString = [[NSAttributedString alloc] initWithString:@"\t}\n\n\treturn copy;\n}"];
    
    [_txtOutput.textStorage appendAttributedString:copyEndString];
}


@end
