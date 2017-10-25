<%@ page import="org.inspirecenter.uclancyservices.data.RoleEntity" %>
<%@ page import="java.util.Vector" %><%--
  Created by IntelliJ IDEA.
  User: Nearchos
  Date: 20-Oct-17
  Time: 9:41 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="/metadata.jsp"%>
    <title>UCLan Cyprus Services - Admin Roles</title>
</head>
<body role="document">

<%@include file="/navbar.jsp"%>

<div class="container theme-showcase" role="main">

    <!-- Main jumbotron for a primary marketing message or call to action -->
    <div  style="padding-top: 40px; padding-bottom: 40px; text-align: left;">
        <h1><img src="/favicon.png"/> UCLan Cyprus e-Services - Roles</h1>
    </div>

<%
    if(isLoggedIn) {
        if(isAdmin) {
            final String message = request.getParameter("message");
%>
    <p class="text-warning"><%=message == null ? "" : message%></p>

    <table class="table table-hover">
        <caption>Roles</caption>
        <thead>
        <tr>
            <th>Keyword</th>
            <th>Description</th>
            <th>Created by (email)</th>
            <th>Created on</th>
            <th/>
        </tr>
        </thead>
        <tbody>
        <tr>
            <form action="/admin/add-role" method="post">
            <th scope="row"><input type="text" title="Keyword" name="keyword"/></th>
            <td><input type="text" title="Description" name="description"/></td>
            <td><input type="hidden" name="createdBy" value="<%=user.getEmail()%>"><%=user.getEmail()%></td>
            <td>now</td>
            <td><input class="btn btn-outline-success" type="submit" name="Add" value="Add"></td>
            </form>
        </tr>
<%
            final Vector<RoleEntity> roleEntities = RoleEntity.getAllRoleEntities();
            for(final RoleEntity roleEntity : roleEntities) {
%>
        <tr>
            <th><h5><span class="badge badge-pill badge-info"><%=roleEntity.getKeyword()%></span></h5></th>
            <td><%=roleEntity.getDescription()%></td>
            <td><%=roleEntity.getCreatedBy()%></td>
            <td><%=roleEntity.getCreatedOnAsFormattedString()%></td>
            <td><a class="btn btn-outline-danger">Delete</a></td>
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
