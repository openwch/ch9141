package cn.wch.ch9140uart.database;

import android.content.Context;

import java.util.Date;
import java.util.List;

import androidx.room.Room;
import cn.wch.ch9140lib.utils.LogUtil;
import cn.wch.ch9140uart.utils.TimeUtil;


public class RoomUtil {
    private DataBase db;
    private static RoomUtil roomUtil;

    public static RoomUtil getInstance() {
        if(roomUtil==null){
            synchronized (RoomUtil.class){
                roomUtil=new RoomUtil();
            }
        }
        return roomUtil;
    }
    public RoomUtil() {

    }
    public void init(Context context){
        db = Room.databaseBuilder(context,
                DataBase.class, "devices.db")
                .allowMainThreadQueries()
                .fallbackToDestructiveMigration()
                .build();
    }

    public boolean isEmpty(){
        return db.userDao().queryCount()==0;
    }

    public boolean isExistInDatabase(String mac){
        List<Device> devices = db.userDao().queryByMac(mac);
        return devices!=null && devices.size()!=0;
    }

    public void add(String mac){
        Device device=new Device();
        device.setBleMac(mac);
        device.setTime(TimeUtil.parseFrom(new Date()));
        if(!isExistInDatabase(mac)){
            LogUtil.d("insert-->"+device.getBleMac()+" "+device.getTime());
            db.userDao().insert(device);
        }else {
            LogUtil.d("update-->"+device.getBleMac()+" "+device.getTime());
            db.userDao().modify(device);
        }


    }


}
