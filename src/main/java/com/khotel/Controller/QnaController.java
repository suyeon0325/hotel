package com.khotel.Controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.khotel.Service.QnaService;
import com.khotel.ServiceImpl.Pager;
import com.khotel.Util.UploadFileUtils;
import com.khotel.Vo.MemberVo;
import com.khotel.Vo.QnaVo;

@Controller
public class QnaController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	
	@Autowired
	QnaService qnaService;
	
	@RequestMapping(value="/qna/write.do")
	public ModelAndView write(
			HttpServletRequest request) {
		MemberVo member = new MemberVo();
		HttpSession session = request.getSession();
		member = (MemberVo) session.getAttribute("member");
		ModelAndView mav = new ModelAndView();
		mav.setViewName("qna/writeQna");
		mav.addObject("dto", member);
		if (member == null) {
			mav.setViewName("redirect:/qna/list.do");

			return mav;
		}
		String name = member.getUserId();
		
		return mav;
	}
	
	@RequestMapping(value="/qna/rewrite.do", method=RequestMethod.GET)
	public ModelAndView rewrite(@RequestParam int QNACODE,
			HttpServletRequest request) throws Exception{
		MemberVo member = new MemberVo();
		HttpSession session = request.getSession();
		member = (MemberVo) session.getAttribute("member");
		if (member == null) {
			ModelAndView mav = new ModelAndView();
			mav.setViewName("redirect:/qna/list.do");
			return mav;
		}
		
		String id = member.getUserId();
		QnaVo vo = qnaService.read(QNACODE);
		if (id.equals(vo.getQNAWRITER())) {
			ModelAndView mav = new ModelAndView();
			mav.setViewName("qna/rewriteQna");
			mav.addObject("dto", qnaService.read(QNACODE));
			return mav;
		}else {
			ModelAndView mav = new ModelAndView();
			mav.setViewName("redirect:/qna/list.do");
			return mav;			
		}
	}
	
	
	@RequestMapping(value = "/qna/list.do")
	public ModelAndView list(
			@RequestParam(defaultValue="1") int curPage
			) throws Exception {
		int a = qnaService.countQna();
		int count = a;
		Pager pager = new Pager(count, curPage);
		int start = pager.getPageBegin();
		int end = pager.getPageEnd();
		List<QnaVo> list = qnaService.listAll(start, end, "", "");
		ModelAndView mav = new ModelAndView();
		mav.setViewName("qna/list");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", list);
		map.put("count", count);
		map.put("pager", pager);
		mav.addObject("map", map);
		return mav;
	
	}
		
	@RequestMapping(value="/qna/insert.do", method= RequestMethod.POST)
	public ModelAndView insert(Model model,
			@RequestPart("uploadFile") MultipartFile file,
			HttpServletRequest request) throws Exception {	
		
		System.out.println(request.getParameter("qnatitle"));
		System.out.println(request.getParameter("qnacontent"));
		System.out.println(file);
		
		MemberVo member = new MemberVo();
		HttpSession session = request.getSession();
		member = (MemberVo) session.getAttribute("member");
		String writer = member.getUserId();
		
		QnaVo vo = new QnaVo();
		vo.setQNATITLE(request.getParameter("qnatitle"));
		vo.setQNACONTENT(request.getParameter("qnacontent"));
		vo.setQNAWRITER(writer);
		
		if(file != null) vo.setIMAGE(1);
		else vo.setIMAGE(0);
		
		Date now = new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyy/MM/dd", Locale.KOREA);
		String time = format.format(now);
		vo.setQNAREGISTERDATE(time);		
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName("qna/writeQna");
		
		try {
			qnaService.create(vo);
			String qnaId = qnaService.getQnaId(vo);
			if(file != null) UploadFileUtils.uploadFile(qnaId, file);
			mav.addObject("resultMsg", "success");

		} catch (Exception e) {
			mav.addObject("resultMsg", "fail");
		}
		
		return mav;
	}
	
	@RequestMapping(value="/qna/view.do", method=RequestMethod.GET)
	public ModelAndView view(@RequestParam int QNACODE,
			@RequestParam int curPage,
			HttpSession session) throws Exception{
		
		qnaService.increaseViewcnt(QNACODE);
		QnaVo qna = qnaService.read(QNACODE);
		
		MemberVo member = new MemberVo();
		member = (MemberVo) session.getAttribute("member");
		String user = null;
		if(member != null) user = member.getUserId();
		
		int imageCnt = qna.getIMAGE();
		System.out.println("image cnt : " + imageCnt);
		
		if(imageCnt == 0) qna.setQNAIMAGE(null);
		else qna.setQNAIMAGE("https://lucid-hotel-bucket.s3.amazonaws.com/lucid-hotel-bucket/qna/" + qna.getQNACODE() + ".jpg");
		
		System.out.println("qna image url : " + qna.getQNAIMAGE());
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName("qna/view");
		mav.addObject("dto", qna);
		mav.addObject("user", user);
		return mav;
		
	}
	
	@RequestMapping(value="/qna/update.do", method= RequestMethod.POST)
	public ModelAndView update(Model model,
			@RequestPart("uploadFile") MultipartFile file,
			@RequestParam int QNACODE,
			@RequestParam("QNATITLE") String title,
			@RequestParam("QNACONTENT") String content) throws Exception {
		
		QnaVo vo = qnaService.read(QNACODE);
		vo.setQNATITLE(title);
		vo.setQNACONTENT(content);
		
		
		if(file != null) vo.setIMAGE(1);
		else vo.setIMAGE(0);
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName("qna/rewriteQna");
		
		try {
			qnaService.update(vo);
			String qnaId = Integer.toString(QNACODE);
			if(file != null) UploadFileUtils.uploadFile(qnaId, file);
			mav.addObject("resultMsg", "success");

		} catch (Exception e) {
			mav.addObject("resultMsg", "fail");
		}
		
		return mav;
	}
	
	@RequestMapping(value="/qna/delete.do", method=RequestMethod.GET)
	public String updat(
			@RequestParam int QNACODE) throws Exception{
		qnaService.delete(QNACODE);
		return "redirect:/qna/list.do";
	}
	
	@RequestMapping(value = "/admin/qnaList")
	public ModelAndView inlist(
			@RequestParam(defaultValue="1") int curPage
			) throws Exception {
		int a = qnaService.countQna();
		int count = a;
		Pager pager = new Pager(count, curPage);
		int start = pager.getPageBegin();
		int end = pager.getPageEnd();
		List<QnaVo> list = qnaService.listAll(start, end, "", "");
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/admin/qnaList");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", list);
		map.put("count", count);
		map.put("pager", pager);
		mav.addObject("map", map);
		return mav;
	
	}
	
}