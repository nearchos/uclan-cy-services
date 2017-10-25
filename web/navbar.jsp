<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="org.inspirecenter.uclancyservices.data.UserEntity" %>
<%--
  Created by IntelliJ IDEA.
  User: Nearchos
  Date: 19-Oct-17
  Time: 9:07 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Fixed navbar -->
<%
    final boolean isAdminPage = request.getRequestURI().startsWith("/admin");
%>
<nav class="navbar navbar-expand-lg navbar-light <%=isAdminPage ? "bg-warning" : "bg-light"%>">
    <a class="navbar-brand" href="/"><img src="/favicon.png"> UCLan Cyprus e-Services</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

<%
    final UserService userService = UserServiceFactory.getUserService();
    final User user = userService.getCurrentUser();
    final boolean isLoggedIn = user != null;
    final String queryString = request.getQueryString();
    final String requestPath = request.getRequestURI() + (queryString == null ? "" : "?" + request.getQueryString());
    final String uclanId;
    final boolean isAdmin;
    {
        final String email = user == null ? null : user.getEmail();
        final UserEntity userEntity = email == null ? null : UserEntity.getUserEntityByEmail(email);
        uclanId = userEntity == null ? null : userEntity.getUclanId();
        isAdmin = isLoggedIn && userEntity != null && userEntity.isConfirmed();
    }
%>
    <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav mr-auto">
<%
    if(isAdmin) {
%>
            <li class="nav-item">
                <a class="nav-link" href="/admin/users">Users</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/admin/roles">Roles</a>
            </li>
            <span class="nav-link">|</span>
<%
    }
    // either way show the list of basic (non-admin) options
%>
            <li class="nav-item">
                <a class="nav-link" href="/redirect">Redirection</a>
            </li>
            <%--<li class="nav-item">--%>
                <%--<a class="nav-link" href="/FAQ">FAQ</a>--%>
            <%--</li>--%>
            <%--<li class="nav-item">--%>
                <%--<a class="nav-link disabled" href="#">Disabled</a>--%>
            <%--</li>--%>
        </ul>
<%
    if(isLoggedIn) { // logged in
        if(isAdmin) { // admin
%>
        <span class="form-inline my-2 my-lg-0">
            <mark><%=user.getEmail()%></mark> &nbsp; <a class="btn btn-outline-info btn-sm" href="/users/profile" title="Linked to <%=uclanId%>"><i class="material-icons">person</i></a> &nbsp; <%=isAdmin ? "<a class='btn btn-outline-primary btn-sm' href='/admin' title='Administration pages'><i class=\"material-icons\">settings</i></a>" : ""%> &nbsp; <a class="btn btn-outline-danger" href="<%=userService.createLogoutURL(requestPath)%>">Log out</a>
        </span>
<%
        } else { // not admin
%>
        <span class="form-inline my-2 my-lg-0">
            <mark><%=user.getEmail()%></mark> &nbsp; <a class="btn btn-outline-primary my-sm" href="/users/profile">Link a UCLan account</a> &nbsp; <a class="btn btn-outline-danger" href="<%=userService.createLogoutURL(requestPath)%>">Log out</a>
        </span>
<%
        }
    } else { // not logged in
%>
        <span class="form-inline my-2 my-lg-0">
            Guest &nbsp; <a class="btn btn-outline-success my-sm" href="<%=userService.createLoginURL(requestPath)%>">Log in</a>
        </span>
<%
    }
%>
    </div>
</nav>
