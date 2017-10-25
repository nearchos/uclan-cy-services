package org.inspirecenter.uclancyservices.admin;

import org.inspirecenter.uclancyservices.data.RoleEntity;
import org.inspirecenter.uclancyservices.data.UserEntity;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class DeleteUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String message = "";
        final String email = request.getParameter("email");

        if(email == null || email.isEmpty()) {
            message = "Error: Email must be specified and not empty";
        } else {
            message = UserEntity.deleteUserEntityByEmail(email);
        }

        response.sendRedirect("/admin/users?message=" + message);
    }
}
