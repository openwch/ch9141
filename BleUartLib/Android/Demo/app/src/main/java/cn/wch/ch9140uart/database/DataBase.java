package cn.wch.ch9140uart.database;

import androidx.room.Database;
import androidx.room.RoomDatabase;

@Database(entities = {Device.class},version = 1,exportSchema = false)
public abstract class DataBase extends RoomDatabase {
    public abstract DeviceDao userDao();
}
