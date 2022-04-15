package cn.wch.ch9140uart.database;

import java.util.List;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.OnConflictStrategy;
import androidx.room.Query;
import androidx.room.Update;


@Dao
public interface DeviceDao {

    @Query("select * from devices")
    List<Device> queryAll();

    @Query("select * from devices where ble_mac == :mac")
    List<Device> queryByMac(String mac);

    @Query("select count(*) from devices")
    int queryCount();

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    void insert(Device... device);

    @Delete
    void delete(Device device);

    @Update(onConflict = OnConflictStrategy.REPLACE)
    void modify(Device device);


}
