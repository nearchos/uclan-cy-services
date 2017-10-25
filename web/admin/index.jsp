<%--
  Created by IntelliJ IDEA.
  User: Nearchos
  Date: 13-Oct-17
  Time: 8:22 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="/metadata.jsp"%>
    <title>UCLan Cyprus Services - User profile</title>
</head>
<body role="document">

<%@include file="/navbar.jsp"%>

<div class="container theme-showcase" role="main">

    <!-- Main jumbotron for a primary marketing message or call to action -->
    <div  style="padding-top: 40px; padding-bottom: 40px; text-align: left;">
        <h1><img src="/favicon.png"/> UCLan Cyprus e-Services - Admin index</h1>
    </div>

    <%
        if(isLoggedIn) {
            if(isAdmin) {
    %>
        <a class="page-link" href="/admin/users">Users</a>
        <a class="page-link" href="/admin/roles">Roles</a>
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
