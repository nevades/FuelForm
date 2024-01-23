package Fuel;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Neva
 */
@WebServlet(name = "fuel_download", urlPatterns = {"/fuel_download"})
public class fuel_download extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        if (req.getParameter("name") == null) {
            resp.sendRedirect("");
            return;
        }

        String[] fileNames = req.getParameter("name").split(",");
        if (fileNames.length == 0) {
            resp.sendRedirect("");
            return;
        }

        for (String fileName : fileNames) {
            File myFile = new File("Fuel Documents/" + fileName.trim());
            if (myFile.exists()) {
                String mimeType = Files.probeContentType(myFile.toPath());
                resp.setContentType(mimeType);

                resp.setHeader("Content-Disposition", "inline; filename=" + myFile.getName());

                try (OutputStream out = resp.getOutputStream(); FileInputStream in = new FileInputStream(myFile)) {

                    byte[] buffer = new byte[4096];
                    int length;
                    while ((length = in.read(buffer)) > 0) {
                        out.write(buffer, 0, length);
                    }
                }
            }
        }
    }
}
