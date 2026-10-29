
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Stationery Stock Records</title>
    
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f4;
        color: #333;
        margin: 20px;
        font-size: 13px;
    }

    h2 {
        text-align: center;
        font-size: 18px;
        color: #333;
        margin-bottom: 20px;
    }

    form {
        margin: 15px auto;
        text-align: center;
    }

    input {
        padding: 6px;
        border: 1px solid #ccc;
        background-color: #fff;
        border-radius: 2px;
        font-size: 12px;
    }

    button {
        padding: 6px 14px;
        background-color: #e8e8e8;
        color: #333;
        border: 1px solid #bbb;
        border-radius: 3px;
        cursor: pointer;
        font-size: 12px;
    }

    button:hover {
        background-color: #d6d6d6;
    }

    table {
        width: 90%;
        margin: 20px auto;
        border-collapse: collapse;
        background-color: #fff;
        font-size: 12px;
    }

    th, td {
        border: 1px solid #ccc;
        padding: 8px;
        text-align: center;
    }

    th {
        background-color: #e5e5e5;
        font-weight: bold;
    }

    tr:nth-child(even) {
        background-color: #f9f9f9;
    }

    a {
        display: block;
        text-align: center;
        color: #333;
        margin-top: 15px;
        text-decoration: underline;
    }
</style>

</head>
<body>

<h2>Saved! ALL Records</h2>

<%
String url = "jdbc:mysql://localhost:3306/stationerydb";
String user = "root";
String pass = "12345";
String search = request.getParameter("search");

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(url, user, pass);

    if ("POST".equals(request.getMethod())) {
        PreparedStatement ps = con.prepareStatement(
            "INSERT INTO stationery (item, qty, rate, reorder_level) VALUES (?, ?, ?, ?)"
        );

        ps.setString(1, request.getParameter("item"));
        ps.setInt(2, Integer.parseInt(request.getParameter("qty")));
        ps.setDouble(3, Double.parseDouble(request.getParameter("rate")));
        ps.setInt(4, Integer.parseInt(request.getParameter("reorder_level")));

        ps.executeUpdate();
        ps.close();

        out.print("<p>Saved successfully!</p>");
    }
%>

<form method="get" action="result.jsp">
    Search Item:
    <input type="text" name="search">
    <button type="submit">Search</button>
</form>

<br>

<table border="1" cellpadding="8">
    <tr>
        <th>ID</th>
        <th>Item</th>
        <th>Quantity</th>
        <th>Rate</th>
        <th>Reorder Level</th>
        <th>Reorder?</th>
    </tr>

<%
    PreparedStatement ps = con.prepareStatement(
        "SELECT * FROM stationery WHERE item LIKE ? ORDER BY id"
    );

    ps.setString(1, "%" + (search == null ? "" : search) + "%");
    ResultSet rs = ps.executeQuery();

    while (rs.next()) {
        int q = rs.getInt("qty");
        int level = rs.getInt("reorder_level");
%>

    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("item") %></td>
        <td><%= q %></td>
        <td><%= rs.getDouble("rate") %></td>
        <td><%= level %></td>
        <td><%= q < level ? "Yes" : "No" %></td>
    </tr>

<%
    }

    rs.close();
    ps.close();
    con.close();

} catch (Exception e) {
    out.print("<p>Error: " + e.getMessage() + "</p>");
}
%>

</table>

<br>
<a href="index.html">Add Another Item</a>

</body>
</html>
