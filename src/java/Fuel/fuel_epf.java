package Fuel;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
import cls.Db;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Neva
 */
@WebServlet(name = "fuel_epf", urlPatterns = {"/fuel_epf"})
public class fuel_epf extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try (Connection connection = Db.getConnection()) {

            String type = (String) req.getSession().getAttribute("uname");
            String selectQuery = "SELECT `epf` FROM `user` WHERE username = ?";

            PreparedStatement preparedStatement = connection.prepareStatement(selectQuery);
            preparedStatement.setString(1, type);

            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                String price = resultSet.getString("epf");
                PrintWriter out = resp.getWriter();
                out.print(price);
            } else {
                PrintWriter out = resp.getWriter();
                out.print("EPF not found");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
