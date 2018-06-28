//
//  NSString+Encrypt.m
//  Utils
//
//  Created by yuexun on 2018/6/28.
//  Copyright © 2018年 yuexun. All rights reserved.
//

#import "NSString+Encrypt.h"
#import <CommonCrypto/CommonCrypto.h>
#define MD5_key  @"szhgydpt"

@implementation NSString (Encrypt)
-(NSString *)StringToMD5String{
    
    return [self encryptUseDES:self andKey:MD5_key];
}
-(NSString *)MD5StringToString{
    
    return [self decryptUseDES:self key:MD5_key];
}
static Byte iv[] = {0,1,2,3,4,5,6,7,8,9,'A','B','C','D','E','F'};
-(NSString *)encryptUseDES:(NSString *)plaintext andKey:(NSString *)key
{
    NSString *ciphertext=nil;
    const char *textbyte=[plaintext UTF8String];
    NSInteger dataLength=[plaintext length];
    unsigned char buffer[1024];
    memset(buffer,0,sizeof(char));
    size_t  numBytesEncrypted = 0;
    CCCryptorStatus cryptor=CCCrypt(kCCEncrypt, kCCAlgorithmDES, kCCOptionECBMode|kCCOptionPKCS7Padding, [key UTF8String], kCCKeySizeDES, iv, textbyte, dataLength, buffer, 1024, &numBytesEncrypted);
    if (cryptor==kCCSuccess) {
        NSData *data=[NSData dataWithBytes:buffer length:(NSInteger)numBytesEncrypted];
        ciphertext=[self base64Encoding:data];
    }
    return ciphertext;
}
static const char encodingTable[] ="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
-(NSString *)base64Encoding:(NSData *)text
{
    if (text.length == 0)
        return @"";
    
    char *characters = malloc(text.length*3/2);
    
    if (characters == NULL)
        return @"";
    
    NSInteger end = text.length - 3;
    int index = 0;
    int charCount = 0;
    int n = 0;
    
    while (index <= end) {
        int d = (((int)(((char *)[text bytes])[index]) & 0x0ff) << 16)
        | (((int)(((char *)[text bytes])[index + 1]) & 0x0ff) << 8)
        | ((int)(((char *)[text bytes])[index + 2]) & 0x0ff);
        
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = encodingTable[(d >> 6) & 63];
        characters[charCount++] = encodingTable[d & 63];
        
        index += 3;
        
        if(n++ >= 14)
        {
            n = 0;
            characters[charCount++] = ' ';
        }
    }
    
    if(index == text.length - 2)
    {
        int d = (((int)(((char *)[text bytes])[index]) & 0x0ff) << 16)
        | (((int)(((char *)[text bytes])[index + 1]) & 255) << 8);
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = encodingTable[(d >> 6) & 63];
        characters[charCount++] = '=';
    }
    else if(index == text.length - 1)
    {
        int d = ((int)(((char *)[text bytes])[index]) & 0x0ff) << 16;
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = '=';
        characters[charCount++] = '=';
    }
    NSString * rtnStr = [[NSString alloc] initWithBytesNoCopy:characters length:charCount encoding:NSUTF8StringEncoding freeWhenDone:YES];
    
    return rtnStr;
    
}
// des解密
-(NSString *)decryptUseDES:(NSString *)plainText key:(NSString *)key
{
    NSString *cleartext = nil;
    NSData *textData = [self dataWithBase64EncodedString:plainText];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          nil,                                      [textData bytes], [textData length],
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        cleartext = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }else{
        NSLog(@"DES解密失败");
    }
    return cleartext;
}
-(NSData *)dataWithBase64EncodedString:(NSString *)string
{
    if (string == nil)
        [NSException raise:NSInvalidArgumentException format:nil];
    if ([string length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}
@end
