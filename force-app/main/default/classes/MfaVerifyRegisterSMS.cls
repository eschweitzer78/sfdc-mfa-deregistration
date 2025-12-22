public class MfaVerifyRegisterSMS {
    @InvocableMethod(label='MFA Verify Code' category='MFA' )
    public static List<String> verifyAndRegister(List<String> verificationCode) {
        if (verificationCode == null || verificationCode.isEmpty()) {
            return new List<String>();
        }

        // Will only be ever executed with a single entry}
        String verificationCode0 = verificationCode[0];
        String rv = UserManagement.verifyRegisterVerificationMethod(
            verificationCode0, 
            Auth.VerificationMethod.SMS
        );

        return new List<String> { rv };
    }
}