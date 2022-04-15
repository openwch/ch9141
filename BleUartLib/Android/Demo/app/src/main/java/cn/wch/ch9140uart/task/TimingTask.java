package cn.wch.ch9140uart.task;

import android.os.AsyncTask;

import java.lang.ref.WeakReference;

import cn.wch.ch9140lib.CH9140BluetoothManager;

import cn.wch.ch9140lib.utils.LogUtil;
import cn.wch.ch9140uart.MainActivity;

public class TimingTask extends AsyncTask<BytesTaskBean,Integer,Integer> {
    private WeakReference<MainActivity> weakReference;
    private long length = 0;
    private boolean flag = false;


    public TimingTask(MainActivity activity) {
        this.weakReference = new WeakReference<>(activity);
    }



    @Override
    protected void onPreExecute() {
        MainActivity activity = weakReference.get();
        if (activity == null || activity.isDestroyed() || isCancelled()) {
            return;
        }
        flag=true;
        activity.onPreExecute(SendType.TYPE_TIMING);
        activity.flag=true;
        LogUtil.d("开始发送");
    }

    @Override
    protected Integer doInBackground(BytesTaskBean... bytesTaskBeans) {
        Thread.currentThread().setPriority(Thread.NORM_PRIORITY);

        MainActivity activity = weakReference.get();


        int ret = 0;
        BytesTaskBean bytesTaskBean = bytesTaskBeans[0];

        byte[] data = bytesTaskBean.getData();
        long interval=bytesTaskBean.getInterval();

        //即便是sleep(0)也是有效果的
        if(interval<0){
            LogUtil.d("发送间隔不能小于0");
            return -3;
        }
        if(interval==0){
            //连续发送
            LogUtil.d("连续发送");
            while (flag && !isCancelled()) {
                ret = CH9140BluetoothManager.getInstance().write( data,data.length);
                if (ret >= 0) {
                    LogUtil.d("发送数据结果："+ret);
                    activity.onCount(ret);
                    if(ret!=data.length){
                        LogUtil.d("发送数据未完成:"+ret+"/"+data.length);
                        return -1;
                    }
                } else {
                    LogUtil.d("error: "+ret);
                    return -2;
                }
            }

        }else {
            LogUtil.d("定时发送： "+interval);
            //间隔发送
            while (flag && !isCancelled()) {
                ret = CH9140BluetoothManager.getInstance().write(data,data.length);
                if (ret >= 0) {
                    LogUtil.d("发送数据结果："+ret);
                    activity.onCount(ret);
                    if(ret!=data.length){
                        LogUtil.d("发送数据未完成:"+ret+"/"+data.length);
                        return -1;
                    }
                } else {
                    LogUtil.d("error: "+ret);
                    return -2;
                }

                try {
                    Thread.sleep(interval);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                    return -3;
                }
            }
        }
        return 0;
    }



    @Override
    protected void onPostExecute(Integer integer) {
        MainActivity activity = weakReference.get();
        if (activity == null || activity.isDestroyed() || isCancelled()) {
            return;
        }
        LogUtil.d("结束发送:"+integer);
        activity.onResult(SendType.TYPE_TIMING,true);

    }

    @Override
    protected void onProgressUpdate(Integer... integers) {

    }

    @Override
    protected void onCancelled(Integer b) {
        flag = false;
        MainActivity activity = weakReference.get();
        if (activity == null || activity.isDestroyed()) {
            return;
        }
        LogUtil.d("取消发送:"+b);
        activity.onResult(SendType.TYPE_TIMING,true);
    }

    @Override
    protected void onCancelled() {

    }





}
