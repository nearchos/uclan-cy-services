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
    <!-- Modal -->
    <div class="modal fade" id="deleteRole" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteUserLabel">Delete role</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Cancel">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p class="text-primary">Are you sure you want to delete the role associated with keyword: <mark id="keyword1"></mark></p>
                </div>
                <div class="modal-footer">
                    <form action="delete-role" method="post">
                        <button type="button" class="btn btn-outline-info" data-dismiss="modal">Cancel</button>
                        <input type="hidden" name="keyword" id="keyword" value="">
                        <input class="btn btn-outline-danger" type="submit" value="Delete">
                    </form>
                </div>
            </div>
        </div>
    </div>

    <p class="text-warning"><%=message == null ? "" : message%></p>

    <table class="table table-hover">
        <caption>Roles</caption>
        <thead>
        <tr>
            <th>Keyword</th>
            <th>Description</th>
            <th>Created by (email)</th>
            <th>Created on</th>
            <th></th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <form action="add-role" method="post">
            <td scope="row"><input type="text" title="Keyword" name="keyword"/></td>
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
            <td><h5><span class="badge badge-pill badge-info"><%=roleEntity.getKeyword()%></span></h5></td>
            <td><%=roleEntity.getDescription()%></td>
            <td><%=roleEntity.getCreatedBy()%></td>
            <td><%=roleEntity.getCreatedOnAsFormattedString()%></td>
            <!-- Button trigger modal -->
            <td><a class="showDeleteRoleModal btn btn-outline-danger m-sm-2" title="Delete this role" data-toggle="modal" data-id="<%=roleEntity.getKeyword()%>" href="#deleteRole">Delete</a></td>
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

<!-- JQuery -->
<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js" integrity="sha384-vFJXuSJphROIrBnz7yo7oB41mKfc8JzQZiCq4NCceLEaO4IHwicKwpJf9c9IpFgh" crossorigin="anonymous"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js" integrity="sha384-alpBpkh1PFOepccYVYDB4do5UnbKysX5WZXm3XxPqe5iKTfUKjNkCk9SaVuEZflJ" crossorigin="anonymous"></script>

<script language="JavaScript">$(document).ready(function () {
    $(".showDeleteRoleModal").click(function () {
        var keyword = $(this).data('id');
        $(".modal-body #keyword1").text(keyword);
        $(".modal-footer #keyword").val(keyword);
    });
});
</script>

</html>
