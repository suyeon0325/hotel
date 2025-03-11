<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
	<head>

		<style>
			* {
				font-family: 'Noto Sans KR', sans-serif;
			}
		</style>

		<meta charset="UTF-8">
		<link rel="stylesheet" href="/resources/css/style_qna.css" type="text/css">
		<title>QnA Rewrite</title>

		<script type="text/javascript" src="/resources/js/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src='/resources/js/jquery.form.js'></script>
		<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js?autoload=false"></script>
		<script charset="UTF-8" type="text/javascript" src="http://t1.daumcdn.net/postcode/api/core/190107/1546836247227/190107.js"></script>

		<script type="text/javascript">
		  var result = '${resultMsg}';
		  if(result == "success"){
			  alert("작성되었습니다!");
			  document.location.href="/mypage/mylist";
		  } else if(result == "fail") {
			  alert("다시 작성해주세요.");
		  }
		  </script>
	  	  
		  <script type="text/javascript">
	
	  	  /*이미지 업로드*/
	  	  function insertQna() {
	
	    	var qnatitle = $('#qnatitle').val();
	    	var qnacontent = $('#qnacontent').val();
	    	
	  	  	var formData = new FormData();
	  	    var fileInput = $('input[name="uploadFile"]');
	  	    var fileList = fileInput[0].files;
	  	    var fileObj = fileList[0];
	  	    var fileName = fileObj.name;
	
			formData.append("uploadFile", fileObj);
	
			var data = {"qnatitle" : qnatitle,
						"qnacontent" : qnacontent,
						formData
			}
			
			$.ajaxForm({
				type : "POST",
				dataType : 'json',
				async : false,
				processData : false,
		    	enctype: "multipart/form-data",
				url : "/qna/insert.do",
				data : data			
	  	  	 })
		  }
	  	  
	  	  </script>
  	  
	</head>

<body>
	<%@include file = "/WEB-INF/views/layout/header.jsp" %>
	<div class=contain>
		<div class=left>
			<h2 class=tit>문의 사항</h2>
			<ul class=menu>
				<li class="m1">
					<a href="/qna/list.do">
						<span>게시판</span>
					</a>
				</li>
				<li class="m2">
					<a href="/qna/write.do">
						<span>문의하기</span>
					</a>
				</li>
			</ul>
		</div>

		<div class=contents>
			<h2>게시물 보기</h2>
			<form action="/qna/update.do" action="/qna/update.do" method="post" enctype="multipart/form-data">

				<h3 class="tit_">● 작성자 정보</h3>
				<div class="col_one_third">
					<h3 class="join_title">작성자</h3>
					<div class="d_form large">${dto.QNAWRITER}</div>
				</div>

				<div class="col_one_third">
					<h3 class="join_title">작성일자</h3>
					<div class="d_form large">${dto.QNAREGISTERDATE}</div>
				</div>

				<div class="clear"></div>

				<h3 class="tit_">● 문의사항</h3>

				<div class="col_two_third">
					<h3 class="join_title">제목</h3>
					<input class="d_form large" name="QNATITLE" id="QNATITLE"  value = "${dto.QNATITLE}">
				</div>

				<div class="col_one_third col_last">
	               <h3 class="join_title"><label for="question_type">사진 추가</label></h3>
	               <!-- <input type="file" id="fileItem" name="uploadFile" accept="image/*"> -->
	               <input type="file" id ="fileItem" name='uploadFile'>
					<!--  <input type="file" id="chooseFile" name="chooseFile" accept="image/*" onchange="loadFile(this)"> -->
	            </div>
           
				<div class="clear"></div>

				<div class="col_full">
					<h3 class="join_title_write">내용</h3>
					<textarea class="d_form large_write" name="QNACONTENT" id="QNACONTENT">${dto.QNACONTENT}</textarea>
				</div>

				<div>
					<input type="hidden" name = "QNACODE" value="${dto.QNACODE}">
					<button type ="submit" class="btn_sbm"m id = "btnUpdate" onclick="insertQna();">수정</button>
					<button type ="button" class="btn_sbm" id = "btnDelete" onclick="location.href='/qna/delete.do?QNACODE=${dto.QNACODE}'">삭제</button>
					<button type ="button" class="btn_sbm" id = "btnList" onclick="location.href='/qna/list.do'">목록</button>
				</div>

			</form>
		</div>
	</div>
</body>
</html>