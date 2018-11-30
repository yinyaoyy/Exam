package com.examstack.management.controller.page.admin;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.examstack.common.domain.exam.Exam;
import com.examstack.common.domain.exam.ExamHistory;
import com.examstack.common.domain.exam.ExamPaper;
import com.examstack.common.domain.question.QuestionQueryResult;
import com.examstack.common.domain.user.CountInfo;
import com.examstack.common.domain.user.Department;
import com.examstack.common.domain.user.Group;
import com.examstack.common.util.Page;
import com.examstack.common.util.PagingUtil;
import com.examstack.common.util.QuestionAdapter;
import com.examstack.management.security.UserInfo;
import com.examstack.management.service.ExamPaperService;
import com.examstack.management.service.ExamService;
import com.examstack.management.service.UserService;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

@Controller
public class ExamPageAdmin {

    @Autowired
	private UserService userService;
	@Autowired
	private ExamPaperService examPaperService;
	@Autowired
	private ExamService examService;
	/**
	 * 考试管理
	 * 
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/admin/exam/exam-list", method = RequestMethod.GET)
	private String examListPage(Model model, HttpServletRequest request, @RequestParam(value="page",required=false,defaultValue="1") int page) {
		
		Page<Exam> pageModel = new Page<Exam>();
		pageModel.setPageNo(page);
		pageModel.setPageSize(8);
		List<Exam> examList = examService.getExamList(pageModel,1,2);
		String pageStr = PagingUtil.getPagelink(page, pageModel.getTotalPage(), "", "admin/exam/exam-list");

		model.addAttribute("examList", examList);
		model.addAttribute("pageStr", pageStr);
		return "exam-list";
	}
	
	/**
	 * 模拟考试列表
	 * @param model
	 * @param request
	 * @param page
	 * @return
	 */
	@RequestMapping(value = "/admin/exam/model-test-list", method = RequestMethod.GET)
	private String modelTestListPage(Model model, HttpServletRequest request, @RequestParam(value="page",required=false,defaultValue="1") int page) {
		
		Page<Exam> pageModel = new Page<Exam>();
		pageModel.setPageNo(page);
		pageModel.setPageSize(10);
		List<Exam> examList = examService.getExamList(pageModel,3);
		String pageStr = PagingUtil.getPageBtnlink(page,
				pageModel.getTotalPage());
		model.addAttribute("examList", examList);
		model.addAttribute("pageStr", pageStr);
		return "model-test-list";
	}

	/**
	 * 发布考试
	 * 
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/admin/exam/exam-add", method = RequestMethod.GET)
	private String examAddPage(Model model, HttpServletRequest request) {
		
		UserInfo userInfo = (UserInfo) SecurityContextHolder.getContext()
			    .getAuthentication()
			    .getPrincipal();
		List<Group> groupList = userService.getGroupListByUserId(userInfo.getUserid(), null);
		List<ExamPaper> examPaperList = examPaperService.getEnabledExamPaperList(userInfo.getUsername(), null);
		model.addAttribute("groupList", groupList);
		model.addAttribute("examPaperList", examPaperList);
		return "exam-add";
	}
	
	/**
	 * 发布考试
	 * 
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/admin/exam/model-test-add", method = RequestMethod.GET)
	private String modelTestAddPage(Model model, HttpServletRequest request) {
		
		UserInfo userInfo = (UserInfo) SecurityContextHolder.getContext()
			    .getAuthentication()
			    .getPrincipal();
		List<ExamPaper> examPaperList = examPaperService.getEnabledExamPaperList(userInfo.getUsername(), null);
		
		model.addAttribute("examPaperList", examPaperList);
		return "model-test-add";
	}

	/**
	 * 学员名单
	 * 
	 * @param model
	 * @param request
	 * @param examIdS
	 * @return
	 */
	@RequestMapping(value = "/admin/exam/exam-student-list/{examId}", method = RequestMethod.GET)
	private String examStudentListPage(Model model, HttpServletRequest request, @PathVariable int examId,@RequestParam(value="searchStr",required=false,defaultValue="") String searchStr,@RequestParam(value="order",required=false,defaultValue="") String order,@RequestParam(value="limit",required=false,defaultValue="0") int limit, @RequestParam(value="page",required=false,defaultValue="1") int page,@RequestParam(value="depId",required=false,defaultValue="-1") int depId) {
		UserInfo userInfo = (UserInfo) SecurityContextHolder.getContext()
			    .getAuthentication()
			    .getPrincipal();
		Page<ExamHistory> pageModel = new Page<ExamHistory>();
		pageModel.setPageNo(page);
		pageModel.setPageSize(10);
		if("".equals(searchStr))
			searchStr = null;
		String submitOrder = null;
		String verifyOrder = null;
		if(!"".equals(order) && order.equals("submitAsc")) {
			submitOrder = "m.submitTime is null,m.submitTime";
		}else if(!"".equals(order) && order.equals("submitDesc")){
			submitOrder = "m.submitTime is null desc,m.submitTime desc";
		}
		if(!"".equals(order) && order.equals("verifyAsc")) {
			verifyOrder = "m.verifyTime is null,m.verifyTime";
		}else if(!"".equals(order) && order.equals("verifyDesc")){
			verifyOrder = "m.verifyTime is null desc,m.verifyTime desc";
		}
		if("".equals(order) || (!"desc".equals(order) && !"asc".equals(order)))
			order = null;
		List<ExamHistory> histList = examService.getUserExamHistListByExamId(examId, searchStr, order, limit, pageModel,depId,submitOrder,verifyOrder);
		String pageStr = PagingUtil.getPagelink(page,
				pageModel.getTotalPage(),"","admin/exam/exam-student-list/" + examId);
		List<Group> groupList = userService.getGroupListByUserId(userInfo.getUserid(), null);
		List<Department> depList = userService.getDepByList();
		model.addAttribute("groupList", groupList);
		model.addAttribute("histList", histList);
		model.addAttribute("pageStr", pageStr);
		model.addAttribute("examId", examId);
		model.addAttribute("limit", limit);
		model.addAttribute("order", order);
		model.addAttribute("searchStr", searchStr);
		model.addAttribute("depList", depList);
		model.addAttribute("depId", depId);
		return "user-exam-list";
	}
	@RequestMapping(value = "/admin/exam/canYuLv/{examId}", method = RequestMethod.GET)
	public  String  getCanYuTongJi(Model model, 
			HttpServletRequest request,
			@PathVariable int examId,
			@RequestParam(value="searchStr",required=false,defaultValue="") String searchStr,
			@RequestParam(value="order",required=false,defaultValue="") String order,
			@RequestParam(value="limit",required=false,defaultValue="0") int limit, 
			@RequestParam(value="page",required=false,defaultValue="1") int page){
		    model.addAttribute("examId",examId);
		    return  "user-exam-statistics";
	}
	@RequestMapping(value = "/admin/exam/canyu", method = RequestMethod.GET)
	@ResponseBody
	public  List<CountInfo>  getCanYuTongJiShuJu(Model model, 
			HttpServletRequest request,
			@RequestParam(value="examId",required=false,defaultValue="") int examId,
			@RequestParam(value="searchStr",required=false,defaultValue="") String searchStr,
			@RequestParam(value="order",required=false,defaultValue="") String order,
			@RequestParam(value="limit",required=false,defaultValue="0") int limit, 
			@RequestParam(value="page",required=false,defaultValue="1") int page){
		
		List<CountInfo> list = userService.getCanYuLv(examId);
		
		return  list;
	}
	/**
	 * 学员试卷
	 * @param model
	 * @param request
	 * @param examhistoryId
	 * @return
	 */
	@RequestMapping(value = "/admin/exam/student-answer-sheet/{histId}", method = RequestMethod.GET)
	private String studentAnswerSheetPage(Model model, HttpServletRequest request, @PathVariable int histId) {
		
		ExamHistory history = examService.getUserExamHistListByHistId(histId);
		int examPaperId = history.getExamPaperId();
		
		String strUrl = "http://" + request.getServerName() // 服务器地址
				+ ":" + request.getServerPort() + "/";
		
		ExamPaper examPaper = examPaperService.getExamPaperById(examPaperId);
		StringBuilder sb = new StringBuilder();
		if(examPaper.getContent() != null && !examPaper.getContent().equals("")){
			Gson gson = new Gson();
			String content = examPaper.getContent();
			List<QuestionQueryResult> questionList = gson.fromJson(content, new TypeToken<List<QuestionQueryResult>>(){}.getType());
			
			for(QuestionQueryResult question : questionList){
				QuestionAdapter adapter = new QuestionAdapter(question,strUrl);
				sb.append(adapter.getStringFromXML());
			}
		}
		
		model.addAttribute("htmlStr", sb);
		model.addAttribute("exampaperid", examPaperId);
		model.addAttribute("examHistoryId", history.getHistId());
		model.addAttribute("exampapername", examPaper.getName());
		model.addAttribute("examId", history.getExamId());
		return "student-answer-sheet";
	}
	
	/**
	 * 人工阅卷
	 * @param model
	 * @param request
	 * @param examhistoryId
	 * @return
	 */
	@RequestMapping(value = "/admin/exam/mark-exampaper/{examhistoryId}", method = RequestMethod.GET)
	private String markExampaperPage(Model model, HttpServletRequest request, @PathVariable int examhistoryId) {
		
		ExamHistory history = examService.getUserExamHistListByHistId(examhistoryId);
		int examPaperId = history.getExamPaperId();
		
		String strUrl = "http://" + request.getServerName() // 服务器地址
				+ ":" + request.getServerPort() + "/";
		
		ExamPaper examPaper = examPaperService.getExamPaperById(examPaperId);
		StringBuilder sb = new StringBuilder();
		if(examPaper.getContent() != null && !examPaper.getContent().equals("")){
			Gson gson = new Gson();
			String content = examPaper.getContent();
			List<QuestionQueryResult> questionList = gson.fromJson(content, new TypeToken<List<QuestionQueryResult>>(){}.getType());
			
			for(QuestionQueryResult question : questionList){
				QuestionAdapter adapter = new QuestionAdapter(question,strUrl);
				sb.append(adapter.getStringFromXML());
			}
		}
		
		model.addAttribute("htmlStr", sb);
		model.addAttribute("exampaperid", examPaperId);
		model.addAttribute("examHistoryId", history.getHistId());
		model.addAttribute("exampapername", examPaper.getName());
		model.addAttribute("examId", history.getExamId());
		return "exampaper-mark";
	}
	/**
	 * 通过率
	 * 
	 * @param model
	 * @param request
	 * @param examId
	 * @return
	 */
	@RequestMapping(value = "/admin/exam/tongGuoLv/{examId}", method = RequestMethod.GET)
	private String tongGuoLvPage(Model model, HttpServletRequest request, @PathVariable int examId,@RequestParam(value="searchStr",required=false,defaultValue="") String searchStr,@RequestParam(value="order",required=false,defaultValue="") String order,@RequestParam(value="limit",required=false,defaultValue="0") int limit, @RequestParam(value="page",required=false,defaultValue="1") int page) {
		List<ExamHistory> histList = examService.gettongGuoLvByExamId(examId);
		ArrayList alist = new ArrayList();
		ArrayList blist = new ArrayList();
		ArrayList clist = new ArrayList();
		ArrayList dlist = new ArrayList();
		ArrayList flist = new ArrayList();
		String name = "";
		String vianum = "";
		String partakenum = "";
		String viarate = "";
		float zrs = 0;
		float tgrs = 0;
		float tgl = 0;
		for(int i=0;i<histList.size();i++){
			if(i == (histList.size()-1)){
				name += "\'"+histList.get(i).getDepName()+"\'";
				vianum += histList.get(i).getPointGet();
				partakenum += histList.get(i).getPoint();
				viarate += histList.get(i).getPassPoint();
				tgrs += histList.get(i).getPointGet();
				zrs += histList.get(i).getPoint();
			}else{
				name += "\'"+histList.get(i).getDepName()+"\',";
				vianum += histList.get(i).getPointGet()+",";
				partakenum += histList.get(i).getPoint()+",";
				viarate += histList.get(i).getPassPoint()+",";
				tgrs += histList.get(i).getPointGet();
				zrs += histList.get(i).getPoint();
			}
		}
		if(tgrs > 0){
			tgl = tgrs/zrs*100;
		}
		DecimalFormat decimalFormat=new DecimalFormat(".00");
		alist.add(name);
		blist.add(vianum);
		clist.add(partakenum);
		dlist.add(viarate);
		flist.add((int)zrs+"");
		flist.add((int)tgrs+"");
		flist.add(decimalFormat.format(tgl));
		model.addAttribute("alist", alist);
		model.addAttribute("blist", blist);
		model.addAttribute("clist", clist);
		model.addAttribute("dlist", dlist);
		model.addAttribute("flist", flist);
		return "user-exam-tongGuoLv";
	}
	
	/**
	 * 高分榜
	 * 
	 * @param model
	 * @param request
	 * @param examId
	 * @return
	 */
	@RequestMapping(value = "/admin/exam/gaoFenBang/{examId}", method = RequestMethod.GET)
	private String gaoFenBangPage(Model model, HttpServletRequest request, @PathVariable int examId,@RequestParam(value="searchStr",required=false,defaultValue="") String searchStr,@RequestParam(value="order",required=false,defaultValue="") String order,@RequestParam(value="limit",required=false,defaultValue="0") int limit, @RequestParam(value="page",required=false,defaultValue="1") int page) {
		//高分榜图表
		List<ExamHistory> histList = examService.getgaoFenBangByExamId(examId);
		//高分榜列表
		List<ExamHistory> sList = examService.getgaoFenBangListByExamId(examId);
		ArrayList alist = new ArrayList();
		ArrayList blist = new ArrayList();
		ArrayList clist = new ArrayList();
		ArrayList flist = new ArrayList();
		String name = "";
		String vianum = "";
		String partakenum = "";
		String viarate = "";
		float zrs = 0;
		float mf = 0;
		float f = 0;
		for(int i=0;i<histList.size();i++){
			if(i == (histList.size()-1)){
				name += "\'"+histList.get(i).getDepName()+"\'";
				vianum += histList.get(i).getPointGet();
				partakenum += histList.get(i).getPoint();
				mf += histList.get(i).getPoint();
				f += histList.get(i).getPointGet();
			}else{
				name += "\'"+histList.get(i).getDepName()+"\',";
				vianum += histList.get(i).getPointGet()+",";
				partakenum += histList.get(i).getPoint()+",";
				mf += histList.get(i).getPoint();
				f += histList.get(i).getPointGet();
			}
		}
		float zrt = mf+f;
		
		alist.add(name);
		blist.add(partakenum);
		clist.add(vianum);
		flist.add((int)zrt+"");
		flist.add((int)mf+"");
		flist.add((int)f+"");
		model.addAttribute("alist", alist);
		model.addAttribute("blist", blist);
		model.addAttribute("clist", clist);
		model.addAttribute("dlist", sList);
		model.addAttribute("flist", flist);
		return "user-exam-gaoFenBang";
	}
	
}
