package com.ylzpay.plugin.map_helper

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.LinearLayout
import android.widget.TextView
import androidx.fragment.app.FragmentManager
import com.blankj.utilcode.util.AppUtils
import com.blankj.utilcode.util.ToastUtils
import com.google.android.material.bottomsheet.BottomSheetDialogFragment
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

    private lateinit var llytBaiDuMap: LinearLayout
    private lateinit var llytGaoDeMap: LinearLayout
    private lateinit var llytWebMap: LinearLayout
    private lateinit var tvCancel: TextView

    private var mLat: String? = ""
    private var mLng: String? = ""
    private var mKeyword: String? = ""

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.dialog_select_map, container, false)
        initView(view)
        return view
    }

    private fun initView(view: View?) {
        mLat = arguments?.getString("lat")
        mLng = arguments?.getString("lng")
        mKeyword = arguments?.getString("keyword")

        // 百度地图
        llytBaiDuMap = view?.findViewById(R.id.llytBaiDuMap)!!
        if (AppUtils.isAppInstalled("com.baidu.BaiduMap")) {
            llytBaiDuMap.visibility = View.VISIBLE
        } else {
            llytBaiDuMap.visibility = View.GONE
        }
        llytBaiDuMap.setOnClickListener {
            dismiss()
            goToBaiDuNavi(requireContext(), mKeyword, mLat, mLng)
        }

        // 高德地图
        llytGaoDeMap = view?.findViewById(R.id.llytGaoDeMap)!!
        if (AppUtils.isAppInstalled("com.autonavi.minimap")) {
            llytGaoDeMap.visibility = View.VISIBLE
        } else {
            llytGaoDeMap.visibility = View.GONE
        }
        llytGaoDeMap.setOnClickListener {
            dismiss()
            goToGaoDeNavi(requireContext(), mKeyword)
        }

        // 网页地图
        llytWebMap = view?.findViewById(R.id.llytWebMap)!!
        llytWebMap.setOnClickListener {
            dismiss()
            goToWebMapNavi(requireContext(), mKeyword, mLat, mLng)
        }

        // 取消
        tvCancel = view?.findViewById(R.id.tvCancel)!!
        tvCancel.setOnClickListener {
            dismiss()
        }
    }

    fun show(manager: FragmentManager) {
        show(manager, "dialog")
    }

    /**
     * 启动百度App进行导航
     */
    private fun goToBaiDuNavi(context: Context, keyword: String?, lat: String?, lng: String?) {
        try {
//            val intent = Intent()
//            intent.data = Uri.parse("baidumap://map/place/search?query=${keyword}&region=beijing&location=${lat},${lng}&radius=1000&region=&src=com.ylzpay.jianou")
            val intent = Intent.getIntent("intent://map/place/search?query=${keyword}&location=${lat},${lng}"
                    + "&radius=1000&region=&src=thirdapp.poi.yourCompanyName.yourAppName#Intent;scheme=bdapp;package=com.baidu.BaiduMap;end")
            context.startActivity(intent)
        } catch (e: URISyntaxException) {
            e.printStackTrace()
        } catch (e: Exception) {
            e.printStackTrace()
            ToastUtils.showShort("百度地图调用失败，请尝试使用其他导航方式")
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