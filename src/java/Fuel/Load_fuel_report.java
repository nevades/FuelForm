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
@WebServlet(name = "Load_fuel_report", urlPatterns = {"/Load_fuel_report"})
public class Load_fuel_report extends HttpServlet {

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
            String year_month = request.getString("year_month");
            String[] parts = year_month.split("-");
            String year = parts[0];
            String month = parts[1];

            String epf = request.getString("epf");
            String grade = request.getString("grade");
            String wise = request.getString("wise");
            ArrayList<String> cols = new ArrayList<>();
            String qry = "";
            if (wise.equals("U")) {

                cols.add("f.`id`");
                cols.add("f.`epf`");
                cols.add("f.`year_month`");
                cols.add("(SELECT hris_new.employee.callname FROM hris_new.employee WHERE (hris_new.employee.epf = f.`epf`)) AS `name`");
                cols.add("COALESCE(((SELECT hris_new.emp_grade.name FROM hris_new.emp_grade WHERE hris_new.emp_grade.id = (SELECT `grade` FROM hris_new.employee WHERE hris_new.employee.epf = f.`epf`))), 'No Grade Set') AS grade");
                cols.add("(SELECT `allocated_amount` FROM `fuel_details` WHERE `epf` = '" + epf + "' AND `year_month` <= '" + year_month + "' ORDER BY `year_month` DESC LIMIT 1) AS allocated_amount");
                cols.add("(SELECT `used` FROM `fuel_form` WHERE (`epf` = '" + epf + "') AND `year_month` = '" + year_month + "' AND `status` = 'accepted') AS used");
                cols.add("((SELECT `allocated_amount` FROM `fuel_details` WHERE `epf` = '" + epf + "' AND `year_month` <= '" + year_month + "' ORDER BY `year_month` DESC LIMIT 1)-(SELECT `used` FROM `fuel_form` WHERE (`epf` = '" + epf + "') AND `year_month` = '" + year_month + "' AND `status` = 'accepted')) AS result");
                cols.add("CONCAT(FORMAT(((SELECT `allocated_amount` FROM `fuel_details` WHERE `epf` = '" + epf + "' AND `year_month` <= '" + year_month + "' ORDER BY `year_month` DESC LIMIT 1)*(SELECT `ppl` FROM `fuel_ppl` WHERE `year_month` <= '" + year_month + "' ORDER BY `year_month` DESC LIMIT 1)),0), '.00') AS allocated_amount_price");
                cols.add("CONCAT(FORMAT(((SELECT `used` FROM `fuel_form` WHERE (`epf` = '" + epf + "') AND `year_month` = '" + year_month + "' AND `status` = 'accepted')*(SELECT `ppl` FROM `fuel_ppl` WHERE `year_month` <= '" + year_month + "' ORDER BY `year_month` DESC LIMIT 1)),0), '.00') AS used_price");
                cols.add("CONCAT(FORMAT((((SELECT `allocated_amount` FROM `fuel_details` WHERE `epf` = '" + epf + "' AND `year_month` <= '" + year_month + "' ORDER BY `year_month` DESC LIMIT 1)-(SELECT `used` FROM `fuel_form` WHERE (`epf` = '" + epf + "') AND `year_month` = '" + year_month + "' AND `status` = 'accepted'))*(SELECT `ppl` FROM `fuel_ppl` WHERE `year_month` <= '" + year_month + "' ORDER BY `year_month` DESC LIMIT 1)),0), '.00') AS result_price");

                qry = "`fuel_form` f WHERE f.`year_month` = '" + year_month + "' AND epf = '" + epf + "' AND f.`status` = 'accepted'";
            } else if (wise.equals("G")) {

                cols.add("f.`id`");
                cols.add("f.`epf`");
                cols.add("f.`year_month`");
                cols.add("(SELECT e.`callname` FROM `hris_new`.`employee` e WHERE e.`epf` = f.`epf`) AS `name`");
                cols.add("COALESCE((SELECT eg.`name` FROM `hris_new`.`emp_grade` eg WHERE eg.`id` = (SELECT e.`grade` FROM `hris_new`.`employee` e WHERE e.`epf` = f.`epf`)), 'No Grade Set') AS `grade`");

                cols.add("f.`allocated_amount`");
                cols.add("(SELECT `used` FROM `fuel_form` WHERE `epf` = f.`epf` AND `year_month` = f.`year_month` AND `status` = 'accepted') AS `used`");
                cols.add("(f.`allocated_amount` - COALESCE((SELECT `used` FROM `fuel_form` WHERE `epf` = f.`epf` AND `year_month` = f.`year_month` AND `status` = 'accepted'), 0)) AS `result`");
                cols.add("CONCAT(FORMAT(((f.`allocated_amount`)*(SELECT `ppl` FROM `fuel_ppl` WHERE `year_month` = '" + year_month + "' OR (`year_month` < '" + year_month + "' AND `year_month` = (SELECT MAX(`year_month`) FROM `fuel_ppl` WHERE `year_month` < '" + year_month + "')))),0), '.00') AS allocated_amount_price");
                cols.add("CONCAT(FORMAT(((SELECT `used` FROM `fuel_form` WHERE `epf` = f.`epf` AND `year_month` = f.`year_month` AND `status` = 'accepted')*(SELECT `ppl` FROM `fuel_ppl` WHERE `year_month` = '" + year_month + "' OR (`year_month` < '" + year_month + "' AND `year_month` = (SELECT MAX(`year_month`) FROM `fuel_ppl` WHERE `year_month` < '" + year_month + "')))),0), '.00') AS used_price");
                cols.add("CONCAT(FORMAT((((f.`allocated_amount` - COALESCE((SELECT `used` FROM `fuel_form` WHERE `epf` = f.`epf` AND `year_month` = f.`year_month` AND `status` = 'accepted'), 0)))*(SELECT `ppl` FROM `fuel_ppl` WHERE `year_month` = '" + year_month + "' OR (`year_month` < '" + year_month + "' AND `year_month` = (SELECT MAX(`year_month`) FROM `fuel_ppl` WHERE `year_month` < '" + year_month + "')))),0), '.00') AS result_price");

                qry = "`fuel_details` f WHERE f.`year_month` = '" + year_month + "' AND COALESCE((SELECT eg.`name` FROM `hris_new`.`emp_grade` eg WHERE eg.`id` = (SELECT e.`grade` FROM `hris_new`.`employee` e WHERE e.`epf` = f.`epf`)), 'No Grade Set') = (SELECT `name` FROM `hris_new`.`emp_grade` WHERE `id` = '" + grade + "')";
            }

            JSONObject rs = DataTable.getData(con, request, cols, qry);
            resp.getWriter().print(rs.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
