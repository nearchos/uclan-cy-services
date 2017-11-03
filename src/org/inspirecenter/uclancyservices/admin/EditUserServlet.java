package org.inspirecenter.uclancyservices.admin;

import org.inspirecenter.uclancyservices.data.UserEntity;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class EditUserServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        final String email = request.getParameter("email");
        final String name = request.getParameter("name");
        if(email == null || email.trim().isEmpty()) {
            response.sendRedirect("/admin/users?message=Invalid or missing 'email' parameter");
        } else if(name == null || name.trim().isEmpty()) {
            response.sendRedirect("/admin/user?email=" + email + "&message=Invalid or missing 'name' parameter");
        } else {
            final UserEntity userEntity = UserEntity.editUser(email, name);
            if(userEntity != null) { // all ok
                response.sendRedirect("/admin/user?email=" + email);
            } else {
                response.sendRedirect("/admin/users?message=Could not locate a user with 'email': " + email);
            }
        }
    }
}
