public class MfaVerifyRegisterSMS {
    @InvocableMethod(label='MFA Verify Code' category='MFA' )
    public static List<String> verifyAndRegister(List<MfaRegisterSMSData> data) {
       if (data == null || data.isEmpty()) {
            return new List<String>();
        }

        // Will only be ever executed with a single entry

        String countryCode = data[0].countryCode;
        String phoneNumber = data[0].phoneNumber;
        String verificationCode = data[0].verificationCode;
        String userId = UserInfo.getUserId();
        User u = [
            Select MobilePhone, Id from User Where Id = :userId
        ];
        String currentPhone = u.MobilePhone;
        String fPhoneNumber = System.UserManagement.formatPhoneNumber(
            countryCode, 
            phoneNumber
        );
        String rv;

        try {
            if (currentPhone != fPhoneNumber && !String.isBlank(fPhoneNumber)) {
                u.MobilePhone = fPhoneNumber;
                update u;
            }

            rv = UserManagement.verifyRegisterVerificationMethod(
                verificationCode, 
                Auth.VerificationMethod.SMS
            );
        } catch (Exception e) {
            rv = e.getMessage();
        }

        if (!String.isBlank(rv)) {
            // NOK revert mobile phone
            u.MobilePhone = currentPhone;
            update u;
        }

        return new List<String> { rv };
    }
}