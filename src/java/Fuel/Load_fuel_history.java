/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Fuel;

import cls.DataTable;
import cls.Db;
import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Connection;
import java.util.ArrayList;
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
@WebServlet(name = "Load_fuel_history", urlPatterns = {"/Load_fuel_history"})
public class Load_fuel_history extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String type = (String) req.getSession().getAttribute("uname");
        try (Connection con = Db.getConnection()) {

            StringBuffer jb = new StringBuffer();
            String line = null;
            BufferedReader reader = req.getReader();
            while ((line = reader.readLine()) != null) {
                jb.append(line);
            }
            JSONObject request = new JSONObject(jb.toString());

            ArrayList<String> cols = new ArrayList<>();

            cols.add("icm_2.fuel_ppl.year_month");
            cols.add("icm_2.fuel_ppl.ppl");
            String qry = "`fuel_ppl`";

            JSONObject rs = DataTable.getData(con, request, cols, qry);
            resp.getWriter().print(rs.toString());

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
