package org.inspirecenter.uclancyservices.admin;

import org.inspirecenter.uclancyservices.data.RoleEntity;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class AddRoleServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String message = "";
        final String keyword = request.getParameter("keyword");
        final String description = request.getParameter("description");
        final String createdBy = request.getParameter("createdBy");

        if(keyword == null || keyword.isEmpty()) {
            message = "Error: Keyword must be specified and not empty";
        } else if(description == null || description.isEmpty()){
            message = "Error: Description must be specified and not empty";
        } else if(createdBy == null || createdBy.isEmpty()) {
            message = "Error: CreatedBy must be specified and not empty";
        } else {
            message = RoleEntity.addRoleEntity(keyword, description, createdBy);
        }

        response.sendRedirect("/admin/roles?message=" + message);
    }
}
