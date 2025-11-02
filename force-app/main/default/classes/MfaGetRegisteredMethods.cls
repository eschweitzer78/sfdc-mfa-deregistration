// Controller code (Conceptual)
public class MfaGetRegisteredMethods {
    @InvocableMethod(label='MFA Get Registered Methods' category='MFA')
    static public List<List<MfaMethod>> getRegisteredMethods(List<Id> userId) {
        List<List<MfaMethod>> results = new List<List<MfaMethod>>();
        List<TwoFactorMethodsInfo> infos = [
            SELECT UserId, HasSalesforceAuthenticator, HasTOTP, HasVerifiedMobileNumber, HasUserVerifiedEmailAddress, HasU2F
            FROM TwoFactorMethodsInfo
            WHERE UserId IN :userId
        ];

        Map<Id, List<MfaMethod>> m = new Map<Id, List<MfaMethod>>();

        for (TwoFactorMethodsInfo info : infos) {
            List<MfaMethod> methods = m.get(info.UserId);

            if (methods == null) {
                methods = new List<MfaMethod>();
                m.put(info.UserId, methods);
            }

            if (info.HasSalesforceAuthenticator) {
                methods.add(new MfaMethod('Auth'));
            }

            if (info.HasTOTP) {
                methods.add(new MfaMethod('TOTP'));
            }

            if (info.HasU2F) {
                methods.add(new MfaMethod('U2F'));
            }

            if (info.HasVerifiedMobileNumber) {
                methods.add(new MfaMethod('SMS'));
            }

            if (info.HasUserVerifiedEmailAddress) {
                methods.add(new MfaMethod('Email'));
            }
        }

        for (String userId1 : userId) {
            results.add(m.get(userId1));
        }

        return results;
    }
}
