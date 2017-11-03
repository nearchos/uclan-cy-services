package org.inspirecenter.uclancyservices.admin;

import org.inspirecenter.uclancyservices.data.RoleEntity;
import org.inspirecenter.uclancyservices.data.UserEntity;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class DeleteRoleServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        final String keyword = request.getParameter("keyword");
        if(keyword == null || keyword.trim().isEmpty()) {
            response.sendRedirect("/admin/roles?message=Invalid or missing 'keyword' parameter");
        } else {
            final boolean result = RoleEntity.deleteEntityByKeyword(keyword);
            response.sendRedirect("/admin/roles" + (result ? "" : "?message=Could not find and delete specified entity with 'keyword': " + keyword));
        }
    }
}