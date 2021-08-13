package com.ylzpay.plugin.map_helper.ui.widget

import android.app.Dialog
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.net.Uri
import android.os.Bundle
import android.view.View
import android.view.ViewGroup
import android.widget.LinearLayout
import android.widget.TextView
import androidx.fragment.app.FragmentManager
import com.blankj.utilcode.util.AppUtils
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.google.android.material.bottomsheet.BottomSheetDialogFragment
import com.sherlockshi.toast.ToastUtils
import com.ylzpay.jianou.R
import java.net.URISyntaxException

/**
 *  Author:      SherlockShi
 *  Email:       sherlock_shi@163.com
 *  Date:        2021-03-03 13:52
 *  Description: 选择地图对话框
 */
class SelectMapDialog : BottomSheetDialogFragment() {

    companion object {
        fun newInstance(lat: String?, lng: String?, keyword: String?): SelectMapDialog {
            val fragment: SelectMapDialog = SelectMapDialog()
            val bundle = Bundle()
            bundle.putString("lat", lat)
            bundle.putString("lng", lng)
            bundle.putString("keyword", keyword)
            fragment.arguments = bundle
            return fragment
        }
    }

    protected lateinit var mContext: Context

    private lateinit var mBehavior: BottomSheetBehavior<*>

    private var mDialog: BottomSheetDialog? = null
    protected var mRootView: View? = null

    private lateinit var llytBaiDuMap: LinearLayout
    private lateinit var llytGaoDeMap: LinearLayout
    private lateinit var llytWebMap: LinearLayout
    private lateinit var tvCancel: TextView

    private var mLat: String? = ""
    private var mLng: String? = ""
    private var mKeyword: String? = ""

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
        mLat = arguments?.getString("lat")
        mLng = arguments?.getString("lng")
        mKeyword = arguments?.getString("keyword")

        mDialog = super.onCreateDialog(savedInstanceState) as BottomSheetDialog
        if (mRootView == null) {
            //缓存下来的View 当为空时才需要初始化 并缓存
            mRootView = View.inflate(mContext, R.layout.dialog_select_map, null)
        }

        // 百度地图
        llytBaiDuMap = mRootView?.findViewById(R.id.llytBaiDuMap)!!
        if (AppUtils.isAppInstalled("com.baidu.BaiduMap")) {
            llytBaiDuMap.visibility = View.VISIBLE
        } else {
            llytBaiDuMap.visibility = View.GONE
        }
        llytBaiDuMap.setOnClickListener {
            close()
            goToBaiDuNavi(requireContext(), mKeyword, mLat, mLng)
        }

        // 高德地图
        llytGaoDeMap = mRootView?.findViewById(R.id.llytGaoDeMap)!!
        if (AppUtils.isAppInstalled("com.autonavi.minimap")) {
            llytGaoDeMap.visibility = View.VISIBLE
        } else {
            llytGaoDeMap.visibility = View.GONE
        }
        llytGaoDeMap.setOnClickListener {
            close()
            goToGaoDeNavi(requireContext(), mKeyword)
        }

        // 网页地图
        llytWebMap = mRootView?.findViewById(R.id.llytWebMap)!!
        llytWebMap.setOnClickListener {
            close()
            goToWebMapNavi(requireContext(), mKeyword, mLat, mLng)
        }

        // 取消
        tvCancel = mRootView?.findViewById(R.id.tvCancel)!!
        tvCancel.setOnClickListener {
            close()
        }

        mDialog?.setContentView(mRootView!!)
        mBehavior = BottomSheetBehavior.from<View>(mRootView?.parent as View)
        mBehavior.isHideable = true

        //圆角边的关键
        (mRootView?.parent as View).setBackgroundColor(Color.TRANSPARENT)
        return mDialog as BottomSheetDialog
    }

    override fun onStart() {
        super.onStart()
        //默认全屏展开
//        mBehavior.setState(BottomSheetBehavior.STATE_EXPANDED);
    }

    override fun onDestroy() {
        super.onDestroy()
        //解除缓存View和当前ViewGroup的关联
        (mRootView?.parent as ViewGroup).removeView(mRootView)
    }

    /**
     * 使用关闭弹框 是否使用动画可选
     * 使用动画 同时切换界面Aty会卡顿 建议直接关闭
     *
     * @param
     */
    fun close() {
        mBehavior.state = BottomSheetBehavior.STATE_HIDDEN
    }

    fun show(manager: FragmentManager) {
        show(manager, "dialog")
    }

    /**
     * 启动百度App进行导航
     */
    private fun goToBaiDuNavi(context: Context, keyword: String?, lat: String?, lng: String?, ) {
        try {
            val intent = Intent.getIntent("intent://map/place/search?query=${keyword}&location=${lat},${lng}"
                    + "&radius=1000&region=&src=thirdapp.poi.yourCompanyName.yourAppName#Intent;scheme=bdapp;package=com.baidu.BaiduMap;end")
            context.startActivity(intent)
        } catch (e: URISyntaxException) {
            e.printStackTrace()
        } catch (e: Exception) {
            e.printStackTrace()
            ToastUtils.showHint("百度地图调用失败，请尝试使用其他导航方式")
        }
    }

    /**
     * 启动高德App进行导航
     */
    private fun goToGaoDeNavi(context: Context, keyword: String?) {
        val intent = Intent()
        intent.action = Intent.ACTION_VIEW
        intent.addCategory(Intent.CATEGORY_DEFAULT)

        // 将功能Scheme以URI的方式传入data
        val uri: Uri = Uri.parse("androidamap://poi?sourceApplication=softname&keywords=${keyword}&dev=0")
        intent.data = uri
        //启动该页面即可
        context.startActivity(intent)
    }

    /**
     * 启动网页地图进行导航
     */
    private fun goToWebMapNavi(context: Context, keyword: String?, lat: String?, lng: String?) {
        val url = "http://api.map.baidu.com/place/search?query=${keyword}&location=${lat},${lng}&radius=1000&region=&output=html&src=ylz"
        val intent = Intent()
        intent.action = "android.intent.action.VIEW"
        intent.data = Uri.parse(url)
        context.startActivity(intent)
    }
}