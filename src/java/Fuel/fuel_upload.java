package Fuel;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import cls.Db;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 *
 * @author admin
 *
 */
@WebServlet(name = "fuel_upload", urlPatterns = {"/fuel_upload"})
public class fuel_upload extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (req.getSession().getAttribute("user") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        int rst = 0;

        HttpSession session = req.getSession();
        resp.setContentType("text/html");
        PrintWriter out = resp.getWriter();

        boolean isMultipart = ServletFileUpload.isMultipartContent(req);

        if (isMultipart) {
            Map<String, String> para = new HashMap<>();
            Map<String, FileItem> files = new HashMap<>();

            FileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);

            try (Connection con = Db.getConnection()) {
                con.setAutoCommit(false);

                List items = upload.parseRequest(req);
                Iterator iterator = items.iterator();
                while (iterator.hasNext()) {
                    FileItem item = (FileItem) iterator.next();
                    if (!item.isFormField()) {
                        files.put(item.getFieldName(), item);
                    } else {
                        para.put(item.getFieldName(), item.getString());
                    }
                }

                String epf = para.get("epf");
                String year_month = para.get("year_month");
                String litres = para.get("litres");

                File ff;
                ff = new File("Fuel Documents");
                if (!ff.exists()) {
                    ff.mkdir();
                }

                String fileName = null;
                String neva = "";

                JSONArray docs = new JSONArray();
                if (!files.isEmpty()) {
                    int fileCount = 1;

                    for (Map.Entry<String, FileItem> entry : files.entrySet()) {
                        String key = entry.getKey();
                        FileItem get = entry.getValue();

                        String fname = "FuelForm_" + epf + "_" + year_month + "_" + new SimpleDateFormat("yyyy-MM-dd HH-mm-ss-SSS").format(new Date()) + ".pdf";
                        neva += (neva.isEmpty() ? "" : ",") + fname;
                        File f2 = new File(ff, fname);
                        get.write(f2);
                        fileName = f2.getName();
                        docs.put(fileName);

                    }

                    FileItem get = files.get("doc");
                }

                String status = "pending";
                JSONObject jo = new JSONObject();
                if (year_month == null || epf == null || litres == null || year_month.isEmpty() || epf.isEmpty() || litres.isEmpty()) {
                    jo.put("status", "input");
                    jo.put("msg", "Invalid input. Please provide all required fields.");
                    resp.getWriter().print(jo);
                    return;
                }
                try (PreparedStatement checkExistingStmt = con.prepareStatement("SELECT COUNT(*) AS count FROM `fuel_form` WHERE `epf` = ? AND `year_month` = ? AND `status` != 'declined'")) {
                    checkExistingStmt.setString(1, epf);
                    checkExistingStmt.setString(2, year_month);

                    try (ResultSet existingResultSet = checkExistingStmt.executeQuery()) {
                        if (existingResultSet.next() && existingResultSet.getInt("count") > 0) {
                            jo.put("status", "exists");
                            jo.put("msg", "Reimbursement already pending for this Year/Month.");
                            resp.getWriter().print(jo);
                            return;
                        }
                    }
                } catch (Exception e) {
                    out.print("An error occurred while checking existing records. Please try again.");
                    return;
                }

                try (PreparedStatement checkStmt = con.prepareStatement("SELECT `allocated_amount` FROM `fuel_details` WHERE `epf` = ? AND `year_month`=(SELECT MAX(`fuel_details`.`year_month`) FROM `fuel_details` WHERE `fuel_details`.`year_month` <= ? AND `epf`= ?)")) {
                    checkStmt.setString(1, epf);
                    checkStmt.setString(2, year_month);
                    checkStmt.setString(3, epf);

                    try (ResultSet resultSet = checkStmt.executeQuery()) {
                        if (resultSet.next()) {
                            System.out.println("1");
                            int allocatedAmount = resultSet.getInt("allocated_amount");

                            int enteredLitres = Integer.parseInt(litres);
                            if (enteredLitres > allocatedAmount) {
                                System.out.println("2");
                                jo.put("status", "exceed");
                                jo.put("msg", "Entered litres exceed allocated amount.");
                                resp.getWriter().print(jo);
                                return;
                            }
                        } else {
                            System.out.println("3");
                            String qr = "SELECT IFNULL((SELECT `allocated_amount` FROM `fuel_details` WHERE `epf` = e.`epf` AND `year_month`=(SELECT MAX(`fuel_details`.`year_month`) FROM `fuel_details` WHERE `fuel_details`.`year_month` <= '" + year_month + "' AND `epf`= e.`epf`)),'-') AS `am` FROM `hris_new`.`employee` e WHERE e.`code`='" + epf + "'";
                            ResultSet rsr = Db.search(con, qr);
                            if (rsr.next()) {
                                System.out.println("4");
                                String allocatedAmount = rsr.getString(1);

                                if (allocatedAmount.equals("-")) {
                                    System.out.println("5");
                                    System.out.println("-");
                                    jo.put("status", "no_allocation");
                                    jo.put("msg", "No allocated amount found for the given EPF.");
                                    resp.getWriter().print(jo);
                                    return;
                                } else {
                                    System.out.println("6");
                                    int enteredLitres = Integer.parseInt(litres);
                                    int allocatedAmountAfter = Integer.parseInt(allocatedAmount);

                                    if (enteredLitres > allocatedAmountAfter) {
                                        jo.put("status", "exceed");
                                        jo.put("msg", "Entered litres exceed allocated amount.");
                                        resp.getWriter().print(jo);
                                        return;
                                    }
                                }

                            } else {
                                System.out.println("7");
                                jo.put("status", "no_allocation");
                                jo.put("msg", "No allocated amount found for the given EPF.");
                                resp.getWriter().print(jo);
                                return;
                            }

                        }
                    }

                    try (PreparedStatement fuelStmt = con.prepareStatement("INSERT INTO fuel_form (`year_month`, `epf`, `used`, `status`,`document`,`reason`) VALUES (?, ?, ?, ?, ?,'No Reason Provided (Request Still Pending Approval)')", PreparedStatement.RETURN_GENERATED_KEYS)) {

                        fuelStmt.setString(1, year_month);
                        fuelStmt.setString(2, epf);
                        fuelStmt.setString(3, litres);
                        fuelStmt.setString(4, status);
                        fuelStmt.setString(5, neva);
                        fuelStmt.executeUpdate();
                        ResultSet rs = fuelStmt.getGeneratedKeys();
                        while (rs.next()) {
                            rst = rs.getInt(1);
                        }

                        JSONObject hist = new JSONObject();
                        JSONArray Sublist = new JSONArray();
                        JSONObject li = new JSONObject();
                        li.put("year_month", year_month);
                        li.put("epf", epf);
                        li.put("used", litres);
                        li.put("status", status);
                        li.put("reason", neva);
                        Sublist.put(li);
                        hist.put("history", Sublist);

                        fuel_audit fuelAudit = new fuel_audit();
                        fuelAudit.fuelLog("fuel_form", rst, "insert", session.getAttribute("uid").toString(), hist);

                    } catch (Exception fuelException) {
                        out.print("An error occurred while saving fuel details. Please try again.");
                    }
                } catch (NumberFormatException e) {
                    jo.put("status", "invalid_litres");
                    jo.put("msg", "Invalid litres value");
                    resp.getWriter().print(jo);
                } catch (Exception fuelException) {
                    jo.put("status", "error");
                    jo.put("msg", "An error occurred while saving fuel details. Please try again.");
                    resp.getWriter().print(jo);
                }

                con.commit();
                jo.put("status", "ok");
                jo.put("msg", "Sucessfully saved!");
                resp.getWriter().print(jo);

            } catch (Exception e) {
                JSONObject jo = new JSONObject();
                jo.put("status", "err");
                jo.put("msg", e.getMessage());
                resp.getWriter().print(jo);
            }
        }
    }
}
