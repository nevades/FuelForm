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
@WebServlet(name = "fuel_price_edit", urlPatterns = {"/fuel_price_edit"})
public class fuel_price_edit extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        resp.setContentType("text/html");
        HttpSession session = req.getSession();
        Double oppl = Double.parseDouble(req.getParameter("oppl"));
        String year_month = req.getParameter("year_month");
        YearMonth currentYearMonth = YearMonth.now();
        String systemYearMonth = currentYearMonth.toString();
        int rst1 = 0;
        try (Connection con = Db.getConnection()) {
            if (!(year_month.equals(""))) {
                PreparedStatement checkStmt = con.prepareStatement("SELECT * FROM fuel_ppl WHERE `year_month` = ?");
                checkStmt.setString(1, year_month);
                if (checkStmt.executeQuery().next()) {
                    PreparedStatement updateStmt = con.prepareStatement("UPDATE fuel_ppl SET ppl = ? WHERE `year_month` = ?", Statement.RETURN_GENERATED_KEYS);
                    updateStmt.setDouble(1, oppl);
                    updateStmt.setString(2, year_month);
                    updateStmt.executeUpdate();
                    PreparedStatement updateStmt2 = con.prepareStatement("SELECT `id` FROM fuel_ppl WHERE `year_month` = ?");
                    updateStmt2.setString(1, year_month);
                    ResultSet resultSet = updateStmt2.executeQuery();
                    int id = 0;
                    if (resultSet.next()) {
                        id = resultSet.getInt("id");
                    }

                    JSONObject hist = new JSONObject();
                    JSONArray Sublist = new JSONArray();
                    JSONObject li = new JSONObject();
                    li.put("ppl", oppl);
                    li.put("year_month", year_month);
                    Sublist.put(li);
                    hist.put("history", Sublist);

                    fuel_audit fuelAudit = new fuel_audit();
                    fuelAudit.fuelLog("fuel_ppl", id, "update", session.getAttribute("uid").toString(), hist);
                } else {
                    PreparedStatement fuelStmt = con.prepareStatement("INSERT INTO fuel_ppl (ppl, `year_month`, type) VALUES (?, ?, ?)", Statement.RETURN_GENERATED_KEYS);
                    fuelStmt.setDouble(1, oppl);
                    fuelStmt.setString(2, year_month);
                    fuelStmt.setInt(3, 92);
                    fuelStmt.executeUpdate();
                    ResultSet rs = fuelStmt.getGeneratedKeys();
                    while (rs.next()) {
                        rst1 = rs.getInt(1);
                    }

                    JSONObject hist = new JSONObject();
                    JSONArray Sublist = new JSONArray();
                    JSONObject li = new JSONObject();
                    li.put("ppl", oppl);
                    li.put("year_month", year_month);
                    li.put("type", 92);
                    Sublist.put(li);
                    hist.put("history", Sublist);

                    fuel_audit fuelAudit = new fuel_audit();
                    fuelAudit.fuelLog("fuel_ppl", rst1, "insert", session.getAttribute("uid").toString(), hist);
                }
                resp.getWriter().print("ok");
            } else {
                resp.getWriter().print("ym");
            }
        } catch (Exception e) {
            resp.getWriter().print("no");
        }
    }
}
