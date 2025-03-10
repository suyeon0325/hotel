<%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
  <head>

      <style>
          * {
              font-family: 'Noto Sans KR', sans-serif;
          }
      </style>

      <meta charset="utf-8">
      <link rel="stylesheet" href="/resources/css/style_qna.css" type="text/css">
      <title>QnA Write</title>

      <script type="text/javascript" src="/resources/js/jquery-1.11.3.min.js"></script>
      <script type="text/javascript" src='/resources/js/jquery.form.js'></script>

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
      <h1>문의하기</h1>
       <form  id="form1" name="form1" action="/qna/insert.do" method="post" enctype="multipart/form-data">

           <h3 class="tit_">● 문의사항</h3>

           <div class="col_one_third">
               <h3 class="join_title">작성자</h3>
               <div class="d_form large">${dto.getUserId()}</div>
           </div>
           
           <div class="col_two_third">
               <h3 class="join_title">제목</h3>
			   <input name="qnatitle" id="qnatitle" size="80" class="d_form large" placeholder="제목을 입력하세요">
           </div>
           
		   <div class="col_one_third col_last">
               <h3 class="join_title"><label for="question_type">사진 추가</label></h3>
               <!-- <input type="file" id="fileItem" name="uploadFile" accept="image/*"> -->
               <input type="file" id ="fileItem" name='uploadFile'>
				<!--  <input type="file" id="chooseFile" name="chooseFile" accept="image/*" onchange="loadFile(this)"> -->
           </div>

     <!-- <div class="col_one_third col_last">
               <h3 class="join_title"><label for="question_type">질문유형</label></h3>
               <select id="question_type" name="question_type" class="box">
                   <option value="">-- Select One --</option>
                   <option value="satisfy">만족</option>
                   <option value="compliment">칭찬</option>
                   <option value="requirement">요구</option>
                   <option value="improvement">개선요청</option>
                   <option value="complaint">불만</option>
                   <option value="etc">기타</option>
               </select>
           </div> -->

          <div class="clear"></div>

          <div class="col_full">
              <h3 class="join_title_write">작성</h3>
              <textarea id="qnacontent" name="qnacontent" rows="10" cols="80"
              placeholder="내용을 입력하세요."></textarea>
          </div>

          <div class="btn_area">
              <input type="submit" id="btnSave" value = "접수" onClick="insertQna();">
          </div>
		</form>
      </div>



	
    </div>
    <%@include file = "/WEB-INF/views/layout/final.jsp" %>

</body>
</html>