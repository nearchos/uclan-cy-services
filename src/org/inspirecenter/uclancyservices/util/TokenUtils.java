package org.inspirecenter.uclancyservices.util;

import java.util.UUID;

public class TokenUtils {

    public static String createRandomToken() {
        return UUID.randomUUID().toString();
    }

    public static final long ONE_MINUTE = 60L * 1000;
    public static final long ONE_HOUR = 60L * ONE_MINUTE;
    public static final long ONE_DAY = 24L * ONE_HOUR;

    public static final long MINIMUM_TOKEN_RESEND_INTERVAL = ONE_DAY;

    public static boolean isTokenExpired(final long tokenLastCreated) {
        return System.currentTimeMillis() - tokenLastCreated > MINIMUM_TOKEN_RESEND_INTERVAL;
    }

    public static String getTimeUntilResend(final long tokenLastCreated) {
        // todo i18n
        final long interval = MINIMUM_TOKEN_RESEND_INTERVAL - (System.currentTimeMillis() - tokenLastCreated);
        if(interval > ONE_HOUR) {
            long hours = interval / ONE_HOUR;
            return hours > 1 ? hours + " hours" : "1 hour";
        } else if(interval > ONE_MINUTE) {
            long minutes = interval / ONE_MINUTE;
            return minutes > 1 ? minutes + " minutes" : "1 minute";
        } else if(interval > 0){
            return "less than a minute";
        } else {
            return "now";
        }
    }
}
