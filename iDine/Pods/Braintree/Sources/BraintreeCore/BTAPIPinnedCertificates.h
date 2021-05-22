#import <Foundation/Foundation.h>

// :rotating_light THIS CODE IS GENERATED BY codify_certificates.sh :rotating_light:

/**
 Encapsualtes our trusted x509 Certificates for Secure SSL Communication with Braintree's servers.

 This class consists of code that is generated by the codify_certificates.sh script, which takes
 a set of PEM formatted certificates and encodes them in code in order to avoid storing certificates
 files in an NSBundle.
*/
@interface BTAPIPinnedCertificates : NSObject

/**
 Returns the set of trusted root certificates based on the PEM files located in this directory.

 @return An array of trusted certificates encoded in the DER format, encapsulated in NSData objects.
*/
+ (NSArray *)trustedCertificates;
@end
