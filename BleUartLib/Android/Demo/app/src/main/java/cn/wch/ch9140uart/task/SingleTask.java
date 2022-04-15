package cn.wch.ch9140uart.task;

import android.os.AsyncTask;

import java.lang.ref.WeakReference;

import cn.wch.ch9140lib.CH9140BluetoothManager;

import cn.wch.ch9140lib.utils.LogUtil;
import cn.wch.ch9140uart.MainActivity;

/**
 * 单次发送
 */
public class SingleTask extends AsyncTask<BytesTaskBean,Integer,Integer> {

    private WeakReference<MainActivity> weakReference;
    private long length = 0;
    private boolean flag = false;


    public SingleTask(MainActivity activity) {
        weakReference=new WeakReference<>(activity);
    }

    @Override
    protected void onPreExecute() {
        MainActivity activity = weakReference.get();
        if (activity == null || activity.isDestroyed() || isCancelled()) {
            return;
        }
        flag=true;
        activity.onPreExecute(SendType.TYPE_SINGLE);
        activity.flag=true;
        LogUtil.d("开始发送");
    }

    @Override
    protected Integer doInBackground(BytesTaskBean... bytesTaskBeans) {
        Thread.currentThread().setPriority(Thread.NORM_PRIORITY);
        MainActivity activity = weakReference.get();
        int ret = 0;

        BytesTaskBean cyclicWriteBean = bytesTaskBeans[0];

        byte[] data = cyclicWriteBean.getData();

        ret = CH9140BluetoothManager.getInstance().write(data,data.length);
        if (ret >= 0) {
            LogUtil.d("发送数据结果："+ret);
            activity.onCount(ret);
            if(ret!=data.length){
                LogUtil.d("发送数据未完成:"+ret+"/"+data.length);
                return -1;
            }
            return 0;
        }else {
            return -2;
        }

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
            LogUtil.d("发送成功");
            activity.onResult(SendType.TYPE_SINGLE,true);
        }else {
            LogUtil.d("发送未完成");
            activity.onResult(SendType.TYPE_SINGLE,false);
        }

    }


    @Override
    protected void onCancelled(Integer aBoolean) {
        flag = false;
        MainActivity activity = weakReference.get();
        if (activity == null || activity.isDestroyed()) {
            return;
        }
        //activity.onCancel(SendType.TYPE_SINGLE);
        LogUtil.d("取消发送:"+aBoolean);
        if(aBoolean==0){
            LogUtil.d("发送成功");
            activity.onResult(SendType.TYPE_SINGLE,true);
        }else {
            LogUtil.d("发送未完成");
            activity.onResult(SendType.TYPE_SINGLE,false);
        }
    }


}
