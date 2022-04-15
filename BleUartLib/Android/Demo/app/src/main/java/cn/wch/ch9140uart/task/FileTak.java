package cn.wch.ch9140uart.task;

import android.os.AsyncTask;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.ref.WeakReference;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;

import cn.wch.ch9140lib.CH9140BluetoothManager;

import cn.wch.ch9140lib.utils.LogUtil;
import cn.wch.ch9140uart.MainActivity;
/**
 * 文件发送
 */
public class FileTak extends AsyncTask<FileTaskBean,Integer,Integer> {
    private WeakReference<MainActivity> weakReference;
    private long fileLength = 0;
    private boolean flag = false;
    private long length = 0;


    public FileTak(MainActivity activity) {
        weakReference=new WeakReference<>(activity);
    }




    @Override
    protected void onPreExecute() {
        MainActivity activity = weakReference.get();
        if (activity == null || activity.isDestroyed() || isCancelled()) {
            return;
        }
        flag=true;
        activity.onPreExecute(SendType.TYPE_FILE);
        activity.flag=true;
        LogUtil.d("开始发送");
    }

    @Override
    protected Integer doInBackground(FileTaskBean... fileTaskBeans) {
        Thread.currentThread().setPriority(Thread.NORM_PRIORITY);
        MainActivity activity = weakReference.get();
        if (activity == null || activity.isDestroyed() || isCancelled()) {
            return -3;
        }
        FileTaskBean fileWriteBean = fileTaskBeans[0];

        File file = fileWriteBean.getFile();

        FileInputStream is=null;
        FileChannel fileChannel=null;
        ByteBuffer byteBuffer;
        int eof = 0;
        byte[] buf;
        long writeCount = 0;
        int ret = 0;

        if (file==null || !file.exists()) {
            return -3;
        }
        fileLength = file.length();
        try {
            is = new FileInputStream(file);
            fileChannel = is.getChannel();
            byteBuffer = ByteBuffer.allocate(1024);
            buf = new byte[1024];
            while (true) {
                try {
                    eof = fileChannel.read(byteBuffer);
                } catch (IOException e) {
                    e.printStackTrace();
                }
                if (eof == -1) break;
                byteBuffer.flip();
                byteBuffer.get(buf, 0, eof);
                ret = CH9140BluetoothManager.getInstance().write(buf, eof);
                if (ret >= 0) {
                    if (activity.isDestroyed() ) {
                        return -3;
                    } else {
                        LogUtil.d("发送数据结果："+ret);
                        activity.onCount(ret);
                        if(ret!=Math.min(buf.length,eof)){
                            LogUtil.d("发送数据未完成:"+ret+"/"+Math.min(buf.length,eof));
                            return -1;
                        }
                    }
                } else {
                    return -2;
                }
                byteBuffer.compact();
                byteBuffer.clear();
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
            return -3;
        }
        finally {
            if(fileChannel!=null){
                try {
                    fileChannel.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if(is!=null){
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return 0;
    }

    @Override
    protected void onProgressUpdate(Integer... values) {

    }

    @Override
    protected void onPostExecute(Integer integer) {
        MainActivity activity = weakReference.get();
        if (activity == null || activity.isDestroyed() || isCancelled()) {
            return;
        }
        LogUtil.d("结束发送"+integer);
        if(integer==0){
            LogUtil.d("发送结束");
            activity.onResult(SendType.TYPE_FILE,true);
        }else {
            LogUtil.d("发送未完成");
            activity.onResult(SendType.TYPE_FILE,false);
        }


    }


    @Override
    protected void onCancelled(Integer aBoolean) {
        flag = false;
        MainActivity activity = weakReference.get();
        if (activity == null || activity.isDestroyed()) {
            return;
        }
        //activity.onCancel(SendType.TYPE_FILE);
        LogUtil.d("取消发送:"+aBoolean);
        if(aBoolean==0){
            LogUtil.d("发送结束");
            activity.onResult(SendType.TYPE_FILE,true);
        }else {
            LogUtil.d("发送未完成");
            activity.onResult(SendType.TYPE_FILE,false);
        }
    }

}
