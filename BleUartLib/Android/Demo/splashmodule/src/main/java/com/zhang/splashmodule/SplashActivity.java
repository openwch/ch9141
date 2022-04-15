package com.zhang.splashmodule;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.constraintlayout.widget.ConstraintLayout;

import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.os.Looper;
import android.text.Html;
import android.text.TextUtils;
import android.view.View;
import android.view.Window;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.Target;
import com.zhang.splashmodule.log.LogUtil;
import com.zhang.splashmodule.util.SPUtil;
import com.zhang.splashmodule.util.SystemUiUtil;

import java.util.Locale;

public class SplashActivity extends AppCompatActivity {

    private Context mContext;
    private long TIME_COUNTDOWN_SPLASH=1500;
    private long TIME_COUNTDOWN_LONG_ADV=3500;
    private Handler handler=new Handler(Looper.getMainLooper());

    private ImageView ivLaunch;
    private ImageView ivLaunchLogo;
    private Button btnSkip;
    private ConstraintLayout constraintLayout;
    private CountDownTimer timer;

    private PresentRuler ruler;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_splash);
        mContext=this;
        SystemUiUtil.setSystemUi(this,true,true,true,true);
        ruler=SplashModule.getPresentRuler();
        initWidget();
        init();
    }

    private void initWidget(){
        ivLaunch=findViewById(R.id.iv_launch_main);
        ivLaunchLogo=findViewById(R.id.iv_launch_logo);
        btnSkip=findViewById(R.id.btn_skip);
        constraintLayout=findViewById(R.id.cl_logo);
    }

    private void init() {
        LogUtil.d("launch image start: ");
        //先加载splash
        //不显示按钮
        setSkipVisibility(false);
        //加载底部图片
        int bottomId=0;
        if(ruler!=null && ruler.getSplashBottomImg()!=0){
            //设置底部图片
            bottomId=ruler.getSplashBottomImg();
        }
        if(bottomId==0){
            //未设置，加载默认
            bottomId=R.drawable.ic_logo_shape;
        }
        Glide.with(mContext).load(bottomId).into(ivLaunchLogo);
        //加载splash主页面
        int splashMainId=0;
        if(ruler!=null && ruler.getSplashImg()!=0){
            //设置主图片
            splashMainId=ruler.getSplashImg();
        }
        if(splashMainId==0){
            //未设置，加载默认
            splashMainId=R.drawable.ic_logo_text;
        }
        Glide.with(mContext).load(splashMainId).into(ivLaunch);
        //定时结束后，如需加载广告页，开始加载
        loadAdvertisementCountDown();


        //如果不从网络加载图片，不显示按钮，并且缩短展示时间

        btnSkip.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(timer!=null){
                    timer.cancel();
                    timer.onFinish();
                }else {
                    toNextActivity(200);
                }
            }
        });

    }

    void setSkipVisibility(final boolean visible){
        handler.post(new Runnable() {
            @Override
            public void run() {
                btnSkip.setVisibility(visible ? View.VISIBLE : View.GONE);
            }
        });
    }

    /**
     * splash结束后加载广告页
     */
    void loadAdvertisementCountDown(){
        timer=new CountDownTimer(TIME_COUNTDOWN_SPLASH,1000) {
            @Override
            public void onTick(long millisUntilFinished) {

            }

            @Override
            public void onFinish() {
                loadAdvertisement();
            }
        };
        timer.start();
    }

    void loadAdvertisement(){
        //如果未指定主体图片，则直接跳转到下一Activity
        if(ruler==null || (TextUtils.isEmpty(ruler.getAdvertiseUrl()) && ruler.getAdvertiseImg()==0)){
            toNextActivity(300);
            return;
        }
        //加载广告页底部图片
        int bottomId=0;
        if(ruler!=null && ruler.getAdvertiseBottomImg()!=0){
            //设置底部图片
            bottomId=ruler.getAdvertiseBottomImg();
        }
        if(bottomId==0){
            //未设置，默认为splash的底部图片，不加载

        }else {
            Glide.with(mContext).load(bottomId).into(ivLaunchLogo);
        }
        //加载广告页主体图片
        String advertiseUrl="";
        int mainId=0;
        if(ruler!=null ){
            advertiseUrl = ruler.getAdvertiseUrl();
            mainId=ruler.getAdvertiseImg();
        }
        if(!TextUtils.isEmpty(advertiseUrl)){
            //加载网络图片
            Glide.with(mContext).load(advertiseUrl)
                    .skipMemoryCache(true)
                    .diskCacheStrategy(DiskCacheStrategy.NONE)
                    .listener(new RequestListener<Drawable>() {
                @Override
                public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {
                    setNextActivityCountDown();
                    return false;
                }

                @Override
                public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                    setNextActivityCountDown();
                    return false;
                }
            }).into(ivLaunch);
        }else {
            //加载本地图片
            Glide.with(mContext).load(mainId).listener(new RequestListener<Drawable>() {
                @Override
                public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {
                    return false;
                }

                @Override
                public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                    return false;
                }
            }).into(ivLaunch);
            setNextActivityCountDown();
        }

    }

    void setNextActivityCountDown() {
        timer=new CountDownTimer(TIME_COUNTDOWN_LONG_ADV,1000) {
            @Override
            public void onTick(long millisUntilFinished) {
                setSkipText(millisUntilFinished/1000);
            }

            @Override
            public void onFinish() {
                toNextActivity(200);
            }
        };
        timer.start();
    }

    void setSkipText(final long time){
        handler.post(new Runnable() {
            @Override
            public void run() {
                String s="还剩"+"<font color='#C226DD'>" + String.format(Locale.US,"%d",time) + "</font>";
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    btnSkip.setText(Html.fromHtml(s,Html.FROM_HTML_MODE_LEGACY));
                }else {
                    btnSkip.setText(Html.fromHtml(s));
                }
            }
        });
    }

    private void toNextActivity(long delay) {
        //目前直接使用默认的guide
        //GuideActivity目前没有动态加载的功能，所以默认guide
        //ruler!=null && ruler.getGuideImg()!=null && ruler.getGuideImg().size()!=0 &&
        if( SPUtil.isFirstRun(mContext)){
            LogUtil.d("to GuideActivity");
            handler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    Intent intent = new Intent(mContext, GuideActivity.class );
                    startActivity(intent);
                    finish();
                }
            },delay);
        }else {
            LogUtil.d("to HomeActivity");
            if(SplashModule.getHomeActivity()==null){
                throw new RuntimeException("SplashModule.init() method should invoke");
            }
            handler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    Intent intent = new Intent(mContext,SplashModule.getHomeActivity());
                    startActivity(intent);
                    finish();
                }
            },delay);
        }
    }
}
