public class MfaRegisterSMS {
    @InvocableMethod(label='MFA Send Verification Code' category='MFA')
    public static List<Boolean> sendVerificationCode(List<MfaRegisterSMSData> data) {
        if (data == null || data.isEmpty()) {
            return new List<Boolean>();
        }

        // Will only be ever executed with a single entry

        String countryCode = data[0].countryCode;
        String phoneNumber = data[0].phoneNumber;
        Boolean success = false;
        String userId = UserInfo.getUserId();
        User u = [
            Select MobilePhone, Id from User Where Id = :userId
        ];

        String currentPhone = u.MobilePhone;
        String fPhoneNumber = System.UserManagement.formatPhoneNumber(
            countryCode, 
            phoneNumber
        );

        try {
            if (currentPhone != fPhoneNumber && !String.isBlank(fPhoneNumber)) {
                u.MobilePhone = fPhoneNumber;
                update u;
            }

            System.UserManagement.initRegisterVerificationMethod(
                Auth.VerificationMethod.SMS
            );

            u.MobilePhone = currentPhone;
            update u;

            success = true;
        } catch (Exception e) {
            u.MobilePhone = currentPhone;
            update u;
        }

        return new List<Boolean> { success };
    }
}