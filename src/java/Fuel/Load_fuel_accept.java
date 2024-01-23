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
@WebServlet(name = "Load_fuel_accept", urlPatterns = {"/Load_fuel_accept"})
public class Load_fuel_accept extends HttpServlet {

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

            String status = request.getString("status");
            cols.add("f.`id`");
            cols.add("f.`year_month`");
            cols.add("f.`epf`");
            cols.add("IFNULL((SELECT `callname` FROM `hris_new`.`employee` e WHERE e.`epf`=f.`epf`),(SELECT `callname` FROM `hris_new`.`employee` e WHERE e.`code`=f.`epf`)) AS `callname`");
//            cols.add("IFNULL(((SELECT `allocated_amount` FROM `fuel_details` WHERE `epf`=icm_2.fuel_form.epf AND (`year_month`=icm_2.fuel_form.year_month))), (SELECT `allocated_amount` FROM `fuel_details` WHERE `epf`=icm_2.fuel_form.epf AND (`year_month`<icm_2.fuel_form.year_month) ORDER BY `year_month` DESC LIMIT 1)) AS allocated");
//            cols.add("IFNULL((SELECT `allocated_amount` FROM `fuel_details` WHERE `year_month`=f.`year_month` AND `epf`=f.`epf`),(SELECT `allocated_amount` FROM `fuel_details` WHERE `epf`=(SELECT `epf` FROM `hris_new`.`employee` e WHERE e.`code`=f.`epf` ORDER BY `year_month` DESC))) AS `allocated`");
            cols.add("f.`used`");
            cols.add("f.`status`");
            cols.add("f.`document`");
            String qry = "`fuel_form` f "
                    + "WHERE f.`status` = '" + status + "'";
            JSONObject rs = DataTable.getData(con, request, cols, qry);
            resp.getWriter().print(rs.toString());

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
