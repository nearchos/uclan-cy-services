package org.inspirecenter.uclancyservices.util;

import com.sun.istack.internal.NotNull;

import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;

public class EmailUtils {

    public static boolean isValidUCLanEmailAddress(@NotNull final String email) {
        return isValidEmailAddress(email) && email.endsWith("@uclan.ac.uk");
    }

    public static boolean isValidEmailAddress(@NotNull final String email) {
        if(email == null) return false;
        boolean result = true;
        try {
            final InternetAddress emailInternetAddress = new InternetAddress(email);
            emailInternetAddress.validate();
        } catch (AddressException ex) {
            result = false;
        }
        return result;
    }

    public static void sendToken(@NotNull final String email, @NotNull final String uclanId, @NotNull final String token) {
        // todo i18n
        final String title = "UCLan Cyprus eServices - Please confirm your email";
        final String link = "http://eservices.uclancyprus.ac.cy/users/profile?token=" + token; // todo edit server
        final String message = "Dear User,\n" +
                "\n" +
                "We received a request to link your account: " + email + "\n" +
                "with the UCLan ID: " + uclanId + "\n" +
                "\n" +
                "If this process was initiated by yourself and you approve this link, then visit the following URL:\n" +
                "\n" +
                "<a href='" + link + "'>" + link + "</a>\n" +
                "\n" +
                "Alternatively, copy-paste the following token in your user profile page:\n" +
                "\n" +
                "<code>" + token + "</code>\n" +
                "\n" +
                "If you did not request this link, please ignore this email.\n" +
                "You can report suspicious activity via email at: CyprusHelpdesk@uclan.ac.uk\n" +
                "\n" +
                "Best regards,\n" +
                "UCLan Cyprus eServices";
    }
}