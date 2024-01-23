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
import java.time.YearMonth;
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
@WebServlet(name = "Load_fuel_form", urlPatterns = {"/Load_fuel_form"})
public class Load_fuel_form extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String type = (String) req.getSession().getAttribute("uname");
        String sepf = (String) req.getSession().getAttribute("epf");
        YearMonth currentYearMonth = YearMonth.now();
        String systemYearMonth = currentYearMonth.toString();
        try (Connection con = Db.getConnection()) {

            StringBuffer jb = new StringBuffer();
            String line = null;
            BufferedReader reader = req.getReader();
            while ((line = reader.readLine()) != null) {
                jb.append(line);
            }
            JSONObject request = new JSONObject(jb.toString());

            ArrayList<String> cols = new ArrayList<>();

            cols.add("icm_2.fuel_form.id");
            cols.add("icm_2.fuel_form.year_month");
            cols.add("(SELECT `allocated_amount` FROM `fuel_details` WHERE `epf`= '" + sepf + "' AND `year_month` <= icm_2.fuel_form.year_month ORDER BY `year_month` DESC LIMIT 1) AS allocated_amount");
            cols.add("icm_2.fuel_form.used");
            cols.add("CONCAT((FORMAT((((`fuel_form`.`used`) * (SELECT `fuel_ppl`.`ppl` FROM `fuel_ppl` WHERE `fuel_ppl`.`year_month` = (SELECT MAX(`fuel_ppl`.`year_month`) FROM `fuel_ppl` WHERE `fuel_ppl`.`type` = 92)))),0)),'.00') AS cau");
            cols.add("icm_2.fuel_form.reason");
            cols.add("icm_2.fuel_form.status");
            //String qry = "`fuel_form` JOIN hris_new.employee ON icm_2.fuel_form.epf = hris_new.employee.epf JOIN icm_2.`user` ON icm_2.fuel_form.epf = icm_2.`user`.epf WHERE icm_2.`user`.username = '" + type + "'";
            String qry = "`fuel_form` WHERE `epf`='" + sepf + "' OR `epf`=(SELECT e.`epf` FROM `hris_new`.`employee` e WHERE e.`code`='" + sepf + "')";

            JSONObject rs = DataTable.getData(con, request, cols, qry);
            resp.getWriter().print(rs.toString());

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
