package Fuel;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author Neva
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
 * @author Admin
 */
@WebServlet(name = "fuel_ppl", urlPatterns = {"/fuel_ppl"})
public class fuel_ppl extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try (Connection connection = Db.getConnection()) {
            String type = req.getParameter("type");

            String selectQuery = "SELECT ppl FROM fuel_ppl WHERE type = ? AND `year_month` = (SELECT MAX(`year_month`) FROM fuel_ppl WHERE type = 92)";

            PreparedStatement preparedStatement = connection.prepareStatement(selectQuery);
            preparedStatement.setString(1, type);

            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                String price = resultSet.getString("ppl");
                PrintWriter out = resp.getWriter();
                out.print(price);
            } else {
                PrintWriter out = resp.getWriter();
                out.print("Fuel price not found");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
