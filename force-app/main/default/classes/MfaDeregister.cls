public class MfaDeregister {
    public class UserMethod {
        public @InvocableVariable Id userId;
        public @InvocableVariable String method;

        public UserMethod(Id userId, String method) {
            this.userId = userId;
            this.method = method;
        }

        public UserMethod() {
            this.userId = null;
            this.method = null;
        }
    }

    @InvocableMethod(label='MFA Deregistered Method' category='MFA')
    static public void deregister(List<UserMethod> userMethod) {
        for (UserMethod userMethod1 : userMethod) {
            switch on userMethod1.method {
                when 'SMS' {
                    System.UserManagement.deregisterVerificationMethod(userMethod1.userId, Auth.VerificationMethod.SMS);
                }
                when 'Auth' {
                    System.UserManagement.deregisterVerificationMethod(userMethod1.userId, Auth.VerificationMethod.SALESFORCE_AUTHENTICATOR);
                }
                when 'TOTP' {
                    System.UserManagement.deregisterVerificationMethod(userMethod1.userId, Auth.VerificationMethod.TOTP);
                }
                when 'U2F' {
                    System.UserManagement.deregisterVerificationMethod(userMethod1.userId, Auth.VerificationMethod.U2F);
                }
                when 'Email' {
                    System.UserManagement.deregisterVerificationMethod(userMethod1.userId, Auth.VerificationMethod.EMAIL);
                }
            }
        }
    }
}
