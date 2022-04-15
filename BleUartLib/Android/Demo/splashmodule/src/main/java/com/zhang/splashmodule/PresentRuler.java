package com.zhang.splashmodule;

import java.util.Arrays;
import java.util.List;

import androidx.annotation.DrawableRes;
import androidx.annotation.IdRes;
import androidx.annotation.NonNull;

public class PresentRuler {
    //splash page
    private @DrawableRes int splashImg;
    private @DrawableRes int splashBottomImg;

    //advertisement page
    private String advertiseUrl;
    private @DrawableRes int advertiseImg;
    private @DrawableRes int advertiseBottomImg;

    //guide page
    private List<Integer> guideImg;

    private PresentRuler(int splashImg, int splashBottomImg,String url, int advertiseImg, int advertiseBottomImg, List<Integer> guideImg) {
        this.splashImg = splashImg;
        this.splashBottomImg = splashBottomImg;
        this.advertiseUrl=url;
        this.advertiseImg = advertiseImg;
        this.advertiseBottomImg = advertiseBottomImg;
        this.guideImg = guideImg;
    }

    public int getSplashImg() {
        return splashImg;
    }

    public int getSplashBottomImg() {
        return splashBottomImg;
    }

    public String getAdvertiseUrl() {
        return advertiseUrl;
    }

    public int getAdvertiseImg() {
        return advertiseImg;
    }

    public int getAdvertiseBottomImg() {
        return advertiseBottomImg;
    }

    public List<Integer> getGuideImg() {
        return guideImg;
    }

    public static class Builder{
        //splash page
        private @DrawableRes int splashImg;
        private @DrawableRes int splashBottomImg;

        //advertisement page
        private String url;
        private @DrawableRes int advertiseImg;
        private @DrawableRes int advertiseBottomImg;

        //guide page
        private List<Integer> guideImg;

        /**
         * splash主体图片
         * @param splashImg
         */
        public void splashMain(@NonNull @DrawableRes int splashImg){
            this.splashImg=splashImg;
        }

        /**
         * splash底部图片
         * @param splashBottomImg
         */
        public void splashBottom(@NonNull @DrawableRes int splashBottomImg){
            this.splashBottomImg=splashBottomImg;
        }

        /**
         * 广告页主体图片
         *
         */
        private void advertiseMain(@NonNull String url){
            this.url=url;
        }

        /**
         * 广告页主体图片
         *
         */
        public void advertiseMain(@NonNull @DrawableRes int advertiseImg){
            this.advertiseImg=advertiseImg;
        }

        /**
         * 广告页底部图片
         * @param advertiseBottomImg
         */
        public void advertiseBottom(@NonNull @DrawableRes int advertiseBottomImg){
            this.advertiseBottomImg=advertiseBottomImg;
        }

        /**
         * 引导页的图片
         * @param imgs
         */
        public void guide(@NonNull @DrawableRes Integer... imgs){
            guideImg= Arrays.asList(imgs);
        }

        public PresentRuler builder(){
           return new PresentRuler(splashImg,splashBottomImg,url,advertiseImg,advertiseBottomImg,guideImg);
        }
    }
}
