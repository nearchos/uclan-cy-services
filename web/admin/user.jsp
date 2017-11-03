<%@ page import="org.inspirecenter.uclancyservices.data.RoleEntity" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %><%--
  Created by IntelliJ IDEA.
  User: Nearchos
  Date: 21-Oct-17
  Time: 9:55 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="/metadata.jsp"%>
    <link rel="stylesheet" href="/css/checkboxes.css">
    <title>UCLan Cyprus Services - Admin User</title>
</head>
<body role="document">

<%@include file="/navbar.jsp"%>

<div class="container theme-showcase" role="main">

    <!-- Main jumbotron for a primary marketing message or call to action -->
    <div  style="padding-top: 40px; padding-bottom: 40px; text-align: left;">
        <h1><img src="/favicon.png"/> UCLan Cyprus e-Services - User</h1>
    </div>

<%
    if(isLoggedIn) {
        if(isAdmin) {
            final String email = request.getParameter("email");
            final UserEntity userEntity = UserEntity.getUserEntityByEmail(email);
            if(userEntity == null) {
%>
    <p class="text-danger">Email not specified or invalid or not found: <%=email%></p>
<%
            } else {
                final String message = request.getParameter("message");
%>
    <!-- Modal -->
    <div class="modal fade" id="deleteUser" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteUserLabel">Delete user</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Cancel">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p class="text-primary">Are you sure you want to delete the user associated with email: <mark><%=email%></mark></p>
                </div>
                <div class="modal-footer">
                    <form action="/admin/delete-user" method="post">
                        <button type="button" class="btn btn-outline-info" data-dismiss="modal">Cancel</button>
                        <input type="hidden" name="email" value="<%=userEntity.getEmail()%>">
                        <input class="btn btn-outline-danger" type="submit" value="Delete">
                    </form>
                </div>
            </div>
        </div>
    </div>

    <p class="text-info"><%=message == null ? "" : message%></p>

    <!-- Button trigger modal -->
    <button type="button" class="btn btn-outline-danger m-sm-2" data-toggle="modal" data-target="#deleteUser">Delete user</button>

    <table class="table table-hover">
        <caption>User</caption>
        <tbody>
            <tr>
                <th scope="row">Email</th>
                <td colspan="2"><%=email%></td>
            </tr>
            <tr>
                <th scope="row">Name</th>
                <form action="edit-user" method="post"><input type="hidden" name="email" value="<%=email%>">
                <td><label><input type="text" name="name" value="<%=userEntity.getName()%>"></label></td>
                <td><input class="btn btn-outline-success" type="submit"></td>
                </form>
            </tr>
            <tr>
                <th scope="row">UCLan ID</th>
                <%--todo confirm--%>
                <td><span class="text-primary"><%=userEntity.getUclanId()%></span> linked on <span class="text-info"><%=userEntity.getConfirmedAsFormattedDateTime()%></span></td>
                <td><a class="btn btn-outline-danger" href="todo">Unlink</a></td>
            </tr>
            <tr>
                <th scope="row">Roles</th>
                <td colspan="2">
                    <%-- See https://bootsnipp.com/snippets/nPMDy --%>
                    <div class="form-group badge-checkboxes">
<%
                final Vector<String> allRoles = RoleEntity.getAllRoleKeywords();
                Collections.sort(allRoles);
                final List<String> userRoles = userEntity.getRoles();
                for(final String role : allRoles) {
%>
                        <label class="checkbox-inline">
                            <input type="checkbox" value="" <%=userRoles.contains(role) ? "checked=''" : ""%>>
                            <span class="badge badge-pill badge-info"><%=role%></span>
                        </label>
<%
                }
%>
                    </div>
                </td>
            </tr>
        </tbody>
    </table>
<%
            }
%>
<%
        } else {
%>
    <p class="text-danger">You must be admin to use this page.</p>
<%
        }
    } else {
%>
    <p class="text-danger">You must be logged in to use this page.</p>
<%
}
%>

</div>

<!-- JQuery -->
<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js" integrity="sha384-vFJXuSJphROIrBnz7yo7oB41mKfc8JzQZiCq4NCceLEaO4IHwicKwpJf9c9IpFgh" crossorigin="anonymous"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js" integrity="sha384-alpBpkh1PFOepccYVYDB4do5UnbKysX5WZXm3XxPqe5iKTfUKjNkCk9SaVuEZflJ" crossorigin="anonymous"></script>

</body>
</html>