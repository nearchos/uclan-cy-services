package org.inspirecenter.uclancyservices.users;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import org.inspirecenter.uclancyservices.data.UserEntity;
import org.inspirecenter.uclancyservices.util.EmailUtils;
import org.inspirecenter.uclancyservices.util.TokenUtils;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Logger;

public class LinkAccountsServlet extends HttpServlet {

    private static final String ORIGIN = "/users/profile";

    private static final Logger log = Logger.getLogger("uclan-cy-services");

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        final String uclanId = request.getParameter("uclanId");

        final UserService userService = UserServiceFactory.getUserService();
        final User user = userService.getCurrentUser();

        String message = null;

        if(uclanId == null || uclanId.isEmpty()) {
            log.severe("Missing parameter: " + uclanId);
        } else if(!EmailUtils.isValidEmailAddress(uclanId)) {
            message = "You must specify a valid email address: " + uclanId;
            log.severe(message);
        } else if(!EmailUtils.isValidUCLanEmailAddress(uclanId)) {
            message = "You must specify a valid UCLan email address: " + uclanId;
            log.severe(message);
        } else if(UserEntity.containsLinkedUCLanId(uclanId)) {
            message = "The specified UCLan ID is already linked to another account";
            log.severe(message);
        } else if(user == null) {
            log.severe("User not logged in");
        } else {
            final String email = user.getEmail();
            final UserEntity userEntity = UserEntity.createOrUpdate(email, uclanId);
            final String token = userEntity.getToken();
            EmailUtils.sendToken(email, uclanId, token);
            log.info("Created user entity: " + email + " -> " + uclanId + " (token: " + token + ")");
            message = "Your account was successfully linked to " + uclanId;
        }

        response.sendRedirect(ORIGIN + (message == null ? "" : "?message=" + message));
    }
}
