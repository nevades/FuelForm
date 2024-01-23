package Fuel;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
import cls.Db;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
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
@WebServlet(name = "fuel_accept", urlPatterns = {"/fuel_accept"})
public class fuel_accept extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        resp.setContentType("text/html");
        HttpSession session = req.getSession();
        String xid = req.getParameter("id");
        String status = req.getParameter("status");
        String reason = req.getParameter("reason");
        try (Connection con = Db.getConnection()) {
            int id = Integer.parseInt(xid);
            try (PreparedStatement updateStmt = con.prepareStatement("UPDATE `fuel_form` SET `status` = ? , `reason` = ? WHERE `id` = ?")) {
                updateStmt.setString(1, status);
                updateStmt.setString(2, reason);
                updateStmt.setInt(3, id);
                updateStmt.executeUpdate();

                JSONObject hist = new JSONObject();
                JSONArray Sublist = new JSONArray();
                JSONObject li = new JSONObject();
                li.put("status", status);
                li.put("reason", reason);
                li.put("id", id);
                Sublist.put(li);
                hist.put("history", Sublist);

                fuel_audit fuelAudit = new fuel_audit();
                fuelAudit.fuelLog("fuel_form", id, "update", session.getAttribute("uid").toString(), hist);
                resp.getWriter().print("ok");
            } catch (Exception updateException) {
                resp.getWriter().print("no");
            }
        } catch (Exception e) {
            resp.getWriter().print("Error");
        }
    }
}
