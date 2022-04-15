package com.zhang.splashmodule;

import androidx.appcompat.app.AppCompatActivity;
import androidx.viewpager.widget.PagerAdapter;
import androidx.viewpager.widget.ViewPager;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;

import java.util.ArrayList;
import java.util.List;

public class GuideActivity extends AppCompatActivity {

    private ViewPager mViewPager;
    //容器
    private List<View> mList = new ArrayList<>();
    private View view1, view2, view3, view4;
    //小圆点
    private ImageView point1, point2, point3, point4;
    private Button btnStart;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_guide);
        initView();
    }

    private void initView() {
        btnStart=findViewById(R.id.btn_start);
        point1 = (ImageView) findViewById(R.id.point1);
        point2 = (ImageView) findViewById(R.id.point2);
        point3 = (ImageView) findViewById(R.id.point3);
        point4 = (ImageView) findViewById(R.id.point4);

        //设置默认图片
        setPointImg(true, false, false, false);
        mViewPager = (ViewPager) findViewById(R.id.mViewPager);
        view1 = View.inflate(this, R.layout.pager_item_one, null);
        view2 = View.inflate(this, R.layout.pager_item_two, null);
        view3 = View.inflate(this, R.layout.pager_item_three, null);
        //view4 = View.inflate(this, R.layout.pager_item_four, null);

        mList.add(view1);
        mList.add(view2);
        mList.add(view3);
        //mList.add(view4);

        btnStart.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                toNextActivity();
            }
        });
        //设置适配器
        mViewPager.setAdapter(new GuideAdapter());

        //监听ViewPager滑动
        mViewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            //pager切换
            @Override
            public void onPageSelected(int position) {
                switch (position) {
                    case 0:
                        setBtnVisible(false);
                        setPointImg(true, false, false, false);
                        //btn_back.setVisibility(View.VISIBLE);
                        break;
                    case 1:
                        setBtnVisible(false);
                        setPointImg(false, true, false, false);
                        //btn_back.setVisibility(View.VISIBLE);
                        break;
                    case 2:
                        setBtnVisible(true);
                        setPointImg(false, false, true, false);
                        //btn_back.setVisibility(View.VISIBLE);
                        break;
                    case 3:
                        setBtnVisible(true);
                        setPointImg(false, false, false, true);
                        //btn_back.setVisibility(View.GONE);
                        break;
                }
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });

    }
    //设置按钮
    private void setBtnVisible(boolean visible){
        btnStart.setVisibility( visible ? View.VISIBLE: View.INVISIBLE);
    }

    //设置小圆点的选中效果
    private void setPointImg(boolean isCheck1, boolean isCheck2, boolean isCheck3, boolean isCheck4) {
        if (isCheck1) {
            point1.setBackgroundResource(R.drawable.point_on);
        } else {
            point1.setBackgroundResource(R.drawable.point_off);
        }

        if (isCheck2) {
            point2.setBackgroundResource(R.drawable.point_on);
        } else {
            point2.setBackgroundResource(R.drawable.point_off);
        }

        if (isCheck3) {
            point3.setBackgroundResource(R.drawable.point_on);
        } else {
            point3.setBackgroundResource(R.drawable.point_off);
        }

        if (isCheck4) {
            point4.setBackgroundResource(R.drawable.point_on);
        } else {
            point4.setBackgroundResource(R.drawable.point_off);
        }
    }

    class GuideAdapter extends PagerAdapter {

        @Override
        public int getCount() {
            return mList.size();
        }

        @Override
        public boolean isViewFromObject(View view, Object object) {
            return view == object;
        }

        @Override
        public Object instantiateItem(ViewGroup container, int position) {
            ((ViewPager) container).addView(mList.get(position));
            return mList.get(position);
        }

        @Override
        public void destroyItem(ViewGroup container, int position, Object object) {
            ((ViewPager) container).removeView(mList.get(position));
            //super.destroyItem(container, position, object);
        }
    }

    private void toNextActivity(){
        if(SplashModule.getHomeActivity()==null){
            throw new RuntimeException("NextActivity is null");
        }
        Intent intent = new Intent(this,SplashModule.getHomeActivity());
        startActivity(intent);
        finish();
    }
}
