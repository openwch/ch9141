package cn.wch.ch9140uart.database;

import androidx.annotation.NonNull;
import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

@Entity(tableName = "devices")
public class Device {


    @PrimaryKey()
    @ColumnInfo(name = "ble_mac")
    @NonNull
    private String bleMac;

    @ColumnInfo(name = "ble_time")
    private String time;


    public Device() {
    }


    public String getBleMac() {
        return bleMac;
    }

    public void setBleMac(String bleMac) {
        this.bleMac = bleMac;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    @NonNull
    @Override
    public String toString() {
        return " ble_mac: "+bleMac+" ble_time: "+time;
    }
}
