/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Fuel;

import cls.Db;
import java.sql.Connection;
import java.sql.PreparedStatement;
import org.json.JSONObject;

/**
 *
 * @author Neva
 */
public class fuel_audit {

    public void fuelLog(String table_name, Integer table_id, String operation, String user, JSONObject hist) {
        try (Connection con = Db.getConnection()) {
            PreparedStatement stmt = con.prepareStatement("INSERT INTO `fuel_logs` (`table_name`,`table_id`,`operation`,`mod_by`,`mod_on`,`data`) VALUES (?,?,?,?,NOW(),'" + hist + "')");
            stmt.setString(1, table_name);
            stmt.setInt(2, table_id);
            stmt.setString(3, operation);
            stmt.setString(4, user);
            stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
