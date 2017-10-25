<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="org.inspirecenter.uclancyservices.data.UserEntity" %>
<%@ page import="org.inspirecenter.uclancyservices.util.EmailUtils" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.List" %>
<%@ page import="org.inspirecenter.uclancyservices.data.RoleEntity" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Comparator" %><%--
  Created by IntelliJ IDEA.
  User: Nearchos
  Date: 15-Oct-17
  Time: 12:40 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="/metadata.jsp"%>
    <title>UCLan Cyprus Services - Admin Users</title>
</head>
<body role="document">

<%@include file="/navbar.jsp"%>

<div class="container theme-showcase" role="main">

    <!-- Main jumbotron for a primary marketing message or call to action -->
    <div  style="padding-top: 40px; padding-bottom: 40px; text-align: left;">
        <p class="display-4">Users</p>
    </div>

<%
    if(isLoggedIn) {
        if(isAdmin) {
            final String message = request.getParameter("message");
%>
    <p class="text-info"><%=message == null ? "" : message%></p>
    <table class="table table-hover" style="cursor:pointer">
        <caption>Users</caption>
        <thead>
        <tr>
            <th>Email</th>
            <th>Name</th>
            <th>UCLan ID</th>
            <th>Linked</th>
            <th>Roles</th>
        </tr>
        </thead>
        <tbody>
<%
            final Vector<UserEntity> userEntities = UserEntity.getAllUserEntities();
            for(final UserEntity userEntity : userEntities) {
%>
            <tr onclick="window.location='/admin/user?email=<%=userEntity.getEmail()%>'">
                <th scope="row"><%=userEntity.getEmail()%></th>
                <td><%=userEntity.getName()%></td>
                <td><%=userEntity.getUclanId()%></td>
                <td><%=userEntity.getConfirmedAsFormattedDateTime()%></td>
                <th>
<%
                final List<String> roles = userEntity.getRoles();
                Collections.sort(roles);
                for(final String role : roles) {
%>
                    <span class="badge badge-pill badge-info"><%=role%></span> &nbsp;
<%
                }
%>
                </th>
            </tr>
<%
            }
%>
        </tbody>
    </table>
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

</body>
</html>
