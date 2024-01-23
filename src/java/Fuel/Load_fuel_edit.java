package Fuel;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
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
@WebServlet(name = "Load_fuel_edit", urlPatterns = {"/Load_fuel_edit"})
public class Load_fuel_edit extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        try (Connection con = Db.getConnection()) {

            StringBuffer jb = new StringBuffer();
            String line = null;
            BufferedReader reader = req.getReader();
            while ((line = reader.readLine()) != null) {
                jb.append(line);
            }
            JSONObject request = new JSONObject(jb.toString());

            ArrayList<String> cols = new ArrayList<>();

            cols.add("fd.id");
            cols.add("fd.epf");
            cols.add("e.callname");
            cols.add("fd.allocated_amount");
            cols.add("latest_fuel.latest_year_month");
            String qry = "icm_2.fuel_details fd JOIN hris_new.employee e ON fd.epf = e.epf JOIN (SELECT epf,MAX(`year_month`) AS latest_year_month FROM icm_2.fuel_details GROUP BY epf) latest_fuel ON fd.epf = latest_fuel.epf AND fd.year_month = latest_fuel.latest_year_month";

            JSONObject rs = DataTable.getData(con, request, cols, qry);
            resp.getWriter().print(rs.toString());

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
