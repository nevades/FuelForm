package Fuel;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
import cls.Db;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.YearMonth;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 *
 * @author Neva
 */
@WebServlet(name = "fuel_edit_user", urlPatterns = {"/fuel_edit_user"})
public class fuel_edit_user extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        resp.setContentType("text/html");
        HttpSession session = req.getSession();
        String gepf = req.getParameter("gepf");
        String glitresStr = req.getParameter("glitres");
        YearMonth currentYearMonth = YearMonth.now();
        String systemYearMonth = currentYearMonth.toString();
        int rst1 = 0;
        try (Connection con = Db.getConnection()) {
            int glitres = Integer.parseInt(glitresStr);

            try (PreparedStatement selectStmt = con.prepareStatement("SELECT * FROM fuel_details WHERE epf = ? AND `year_month` = ?")) {
                PreparedStatement updateStmt = con.prepareStatement("UPDATE fuel_details SET allocated_amount = ? WHERE epf = ? AND `year_month` = ?");
                PreparedStatement insertStmt = con.prepareStatement("INSERT INTO fuel_details (epf, allocated_amount, `year_month`) VALUES (?, ?, ?)", Statement.RETURN_GENERATED_KEYS);

                selectStmt.setString(1, gepf);
                selectStmt.setString(2, systemYearMonth);

                boolean entryExists = selectStmt.executeQuery().next();

                if (entryExists) {
                    updateStmt.setInt(1, glitres);
                    updateStmt.setString(2, gepf);
                    updateStmt.setString(3, systemYearMonth);
                    int rowsAffected = updateStmt.executeUpdate();
                    PreparedStatement selectStmt1 = con.prepareStatement("SELECT `id` FROM fuel_details WHERE epf = ? AND `year_month` = ?");
                    selectStmt1.setString(1, gepf);
                    selectStmt1.setString(2, systemYearMonth);
                    ResultSet resultSet = selectStmt1.executeQuery();

                    int id = 0;

                    if (resultSet.next()) {
                        id = resultSet.getInt("id");
                    }

                    updateStmt.executeUpdate();
                    if (rowsAffected > 0) {

                        JSONObject hist = new JSONObject();
                        JSONArray Sublist = new JSONArray();
                        JSONObject li = new JSONObject();
                        li.put("allocated_amount", glitres);
                        li.put("epf", gepf);
                        li.put("year_month", systemYearMonth);
                        Sublist.put(li);
                        hist.put("history", Sublist);

                        fuel_audit fuelAudit = new fuel_audit();
                        fuelAudit.fuelLog("fuel_details", id, "update", session.getAttribute("uid").toString(), hist);
                        System.out.println("Fuel details updated successfully");
                        resp.getWriter().print("ok");
                    } else {
                        resp.getWriter().print("EPF " + gepf + " update failed");
                    }
                } else {
                    insertStmt.setString(1, gepf);
                    insertStmt.setInt(2, glitres);
                    insertStmt.setString(3, systemYearMonth);
                    int rowsAffected = insertStmt.executeUpdate();
                    ResultSet rs = insertStmt.getGeneratedKeys();
                    while (rs.next()) {
                        rst1 = rs.getInt(1);
                    }
                    if (rowsAffected > 0) {

                        JSONObject hist = new JSONObject();
                        JSONArray Sublist = new JSONArray();
                        JSONObject li = new JSONObject();
                        li.put("epf", gepf);
                        li.put("allocated_amount", glitres);
                        li.put("year_month", systemYearMonth);
                        Sublist.put(li);
                        hist.put("history", Sublist);

                        fuel_audit fuelAudit = new fuel_audit();
                        fuelAudit.fuelLog("fuel_details", rst1, "insert", session.getAttribute("uid").toString(), hist);
                        System.out.println("Fuel details inserted successfully");
                        resp.getWriter().print("ok");
                    } else {
                        resp.getWriter().print("EPF " + gepf + " insert failed");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                resp.getWriter().print("no");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().print("Invalid litres value");
        }
    }
}
