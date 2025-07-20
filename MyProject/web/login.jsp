<%-- 
    Document   : login
    Created on : Jul 10, 2025, 2:38:30 PM
    Author     : hoang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
          <title>Login</title>
          <link rel="stylesheet" href="design/style.css"/>
    </head>
    <body>
        <div class="login-container">
        <form action="login" method="POST">
            username:<input type="text" name="username"/><br/>
            password:<input type="password" name="password"/> <br/>
            <input type="submit" value="login"/>
        </form>
        </div>
    </body>
</html>
