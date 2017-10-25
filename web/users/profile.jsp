<%@ page import="org.inspirecenter.uclancyservices.data.UserEntity" %>
<%@ page import="org.inspirecenter.uclancyservices.util.TokenUtils" %>
<%@ page import="java.util.logging.Logger" %>
<%--
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
    <title>UCLan Cyprus e-Services - User profile</title>
</head>
<body role="document">

    <%@include file="/navbar.jsp"%>

    <div class="container theme-showcase" role="main">

        <!-- Main jumbotron for a primary marketing message or call to action -->
        <div  style="padding-top: 40px; padding-bottom: 40px; text-align: left;">
            <h1><img src="/favicon.png"/> UCLan Cyprus e-Services - User profile</h1>
        </div>

<%
    UserEntity userEntity = null;
    String uclanId = null;
    /* Levels of completion
     * 1. guest - redirect to authenticate
     * 2. logged in - ask to set uclan id
     * 3. linked - ask to confirm via token
     * 4. confirmed - all done
     */
    String errorMessage = request.getParameter("message");
Logger.getLogger("**").info("message: " + errorMessage);// todo delete

    // check 1
    final boolean check1_isGuest = true; // always true

    // check 2
    final boolean check2_isLoggedIn = user != null;

    // check 3
    final boolean check3_isUCLanIdSpecified;
    if(!check2_isLoggedIn) {
        check3_isUCLanIdSpecified = false;
    } else {
        userEntity = UserEntity.getUserEntityByEmail(user.getEmail());
        if(userEntity == null) {
            check3_isUCLanIdSpecified = false;
        } else if(userEntity.getTokenLastCreated() == 0) {
            check3_isUCLanIdSpecified = false;
        } else {
            check3_isUCLanIdSpecified = true;
        }
    }

    // check 4
    final boolean check4_isUCLanIdConfirmed;
    if(!check3_isUCLanIdSpecified) {
        check4_isUCLanIdConfirmed = false;
    } else {
        long tokenConfirmed = userEntity.getConfirmed();

        final String parameterToken = request.getParameter("token");
        if(tokenConfirmed == 0 && parameterToken != null && !parameterToken.isEmpty()) {
            tokenConfirmed = UserEntity.confirmToken(parameterToken);
            if(tokenConfirmed == 0L) {
                errorMessage = "Invalid token - could not link your email to your UCLan ID";
            } else {
                response.sendRedirect("/users/profile");
            }
        }

        check4_isUCLanIdConfirmed = check3_isUCLanIdSpecified && tokenConfirmed > 0L;
    }

    if(!isLoggedIn) {
%>
        <div>
            <p class="text-danger">You must log in first to use this page.</p>
        </div>
<%
    } else if(check4_isUCLanIdConfirmed) { // everything id ready - the user has linked with a UCLan ID
%>
        <div>
            <%=errorMessage != null && !errorMessage.isEmpty() ? "<p class='text-info'>" + errorMessage + "</p>" : ""%>
            <h3 class="text-primary">User profile</h3>
            <table class="table">
                <tbody>
                <tr>
                    <th scope="row">Email</th>
                    <td><%=userEntity.getEmail()%></td>
                </tr>
                <tr>
                    <th scope="row">Name</th>
                    <td><%=userEntity.getName()%></td>
                </tr>
                <tr>
                    <th scope="row">UCLan ID</th>
                    <td><%=userEntity.getUclanId()%></td>
                </tr>
                <tr>
                    <th scope="row">Linked</th>
                    <td><%=userEntity.getConfirmedAsFormattedDateTime()%> UTC</td>
                </tr>
                <tr>
                    <th scope="row">Roles</th>
                    <td>TBD</td>
                </tr>
                </tbody>
            </table>

        </div>
<%
    } else {
%>
        <div>
            <h3 class="text-primary">You must first link your Google account to a UCLan account to proceed.</h3>
            <p class="text-info">Follow these steps:</p>

            <p class="text-success">1. Get here!</p>
<%
        if(check2_isLoggedIn) {
%>
            <p class="text-success">2. Logged in as <strong><%=user.getEmail()%></strong></p>
<%
        } else {
%>
            <p class="text-danger">2. Not logged in <a class="btn btn-outline-success" href="<%=userService.createLoginURL(requestPath)%>">Log in</a></p>
<%
        }
%>
<%
        if(check3_isUCLanIdSpecified) {
            uclanId = userEntity.getUclanId();
%>
            <p class="text-success">3. Linked to UCLan ID <strong><%=uclanId%></strong></p>
<%
        } else {
%>
            <p class="text-danger">3. Not linked to any UCLan ID</p>
            <form method="post" action="/users/link-accounts">
                <p class="text-danger">
                    Please enter your UCLan Cyprus email id: <input type="email" title="UCLan ID" name="uclanId" placeholder="someone@uclan.ac.uk" <%=check2_isLoggedIn ? "" : "disabled"%>/>
                    <input class="btn-outline-danger" <%=check2_isLoggedIn ? "" : "disabled"%>  type="submit" name="Submit">
                </p>
            </form>
<%
            if(errorMessage != null && !errorMessage.isEmpty()) {
%>
            <p class="text-warning"><%=errorMessage%></p>
<%
            }
        }
%>
<%
        if(check4_isUCLanIdConfirmed) {
%>
            <p class="text-success">4. Confirmed link to UCLan ID <strong><%=uclanId%></strong></p>
<%
        } else {
            if(!check3_isUCLanIdSpecified) { // still defining a uclanId in step 3...
%>
            <p class="text-danger">4. Confirm link to UCLan ID</p>
<%
            } else {
%>
            <p class="text-danger">4. Confirm link to UCLan ID</p>
            <form method="get" action="/users/profile">
                <p class="text-danger">
                    Check your email. A token was sent to <%=uclanId%>. Enter the token here: <input type="text" title="Token" name="token" placeholder="token" />
                    <input class="btn-outline-danger" type="submit" name="Submit">
                </p>
            </form>
<%

            }
            final long tokenLastCreated = userEntity == null ? 0L : userEntity.getTokenLastCreated();
            if(tokenLastCreated > 0L) {
%>
            <p class="text-info">Do you need to resend the token? You can request a new token every 24 hours (i.e. in <%=TokenUtils.getTimeUntilResend(tokenLastCreated)%>).</p>
<%
            }
            if(errorMessage != null && !errorMessage.isEmpty() && check3_isUCLanIdSpecified) {
%>
            <p class="text-warning"><%=errorMessage%></p>
<%
          }
        }
    }
%>
        </div>
    </div>

</body>
</html>