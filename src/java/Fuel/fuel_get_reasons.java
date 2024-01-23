/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Fuel;

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
import org.json.JSONObject;

/**
 *
 * @author Neva
 */
@WebServlet(name = "fuel_get_reasons", urlPatterns = {"/fuel_get_reasons"})
public class fuel_get_reasons extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try (Connection connection = Db.getConnection()) {
            String id = req.getParameter("id");

            String selectQuery = "SELECT icm_2.fuel_form.reason FROM fuel_form WHERE icm_2.fuel_form.id = ?";

            try (PreparedStatement preparedStatement = connection.prepareStatement(selectQuery)) {
                preparedStatement.setString(1, id);

                ResultSet resultSet = preparedStatement.executeQuery();

                if (resultSet.next()) {
                    String reason = resultSet.getString("reason");

                    JSONObject json = new JSONObject();
                    json.put("reason", reason);

                    resp.setContentType("application/json");

                    PrintWriter out = resp.getWriter();
                    out.print(json.toString());
                } else {
                    PrintWriter out = resp.getWriter();
                    out.print("ID not found");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
