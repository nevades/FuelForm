package Fuel;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
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
 * @author Admin
 */
@WebServlet(name = "fuel_edit", urlPatterns = {"/fuel_edit"})
public class fuel_edit extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        resp.setContentType("text/html");
        HttpSession session = req.getSession();
        String epf = req.getParameter("epf");
        String litresStr = req.getParameter("litres");
        YearMonth currentYearMonth = YearMonth.now();
        String systemYearMonth = currentYearMonth.toString();
        int rst = 0;
        try (Connection con = Db.getConnection()) {
            int litres = Integer.parseInt(litresStr);

            if (!isEpfExists(epf)) {
                if (isEpfExistsHris(epf)) {
                    try (PreparedStatement fuelStmt = con.prepareStatement("INSERT INTO fuel_details (epf, allocated_amount, `year_month`,`code`) VALUES (?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS)) {
                        PreparedStatement code = con.prepareStatement("SELECT hris_new.employee.code FROM hris_new.employee WHERE hris_new.employee.epf = '" + epf + "'");
                        String coder = "0";
                        try (ResultSet rsc = code.executeQuery()) {
                            if (rsc.next()) {
                                coder = rsc.getString(1);
                            }
                        } catch (Exception e) {
                            coder = null;
                        }
                        fuelStmt.setString(1, epf);
                        fuelStmt.setInt(2, litres);
                        if (systemYearMonth.equals("2024-01")) {
                            fuelStmt.setString(3, "2023-12");
                        } else {
                            fuelStmt.setString(3, systemYearMonth);
                        }
                        fuelStmt.setString(4, coder);
                        fuelStmt.executeUpdate();
                        ResultSet rs = fuelStmt.getGeneratedKeys();
                        while (rs.next()) {
                            rst = rs.getInt(1);
                        }
                        System.out.println("Fuel details saved successfully");

                        JSONObject hist = new JSONObject();
                        JSONArray Sublist = new JSONArray();
                        JSONObject li = new JSONObject();
                        li.put("epf", epf);
                        li.put("allocated_amount", litres);
                        li.put("year_month", systemYearMonth);
                        li.put("code", coder);
                        Sublist.put(li);
                        hist.put("history", Sublist);

                        fuel_audit fuelAudit = new fuel_audit();
                        fuelAudit.fuelLog("fuel_details", rst, "insert", session.getAttribute("uid").toString(), hist);
                        resp.getWriter().print("ok");

                    } catch (Exception fuelException) {
                        fuelException.printStackTrace();
                        resp.getWriter().print("no");
                    }
                } else {
                    resp.getWriter().print("EPF " + epf + " doesnt exists");
                }
            } else {
                resp.getWriter().print("Entry with EPF " + epf + " already exists");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().print("Invalid litres value");
        }
    }

    private boolean isEpfExists(String epf) {
        try (Connection con = Db.getConnection(); PreparedStatement stmt = con.prepareStatement("SELECT COUNT(*) FROM fuel_details WHERE epf = ?")) {

            stmt.setString(1, epf);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    return count > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private boolean isEpfExistsHris(String epf) {
        try (Connection con = Db.getConnection(); PreparedStatement stmt = con.prepareStatement("SELECT COUNT(*) FROM hris_new.employee WHERE epf = ?")) {

            stmt.setString(1, epf);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    return count > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
