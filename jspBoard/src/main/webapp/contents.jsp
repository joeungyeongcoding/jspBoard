<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="jspBoard.service.*, 
                jspBoard.dto.BDto,
                java.text.SimpleDateFormat" %>  
                  
<%@ include file="inc/header.jsp" %>
<%@ include file="inc/aside.jsp" %>
<%   
   HttpSession sess2 = request.getSession(true);
   Cookie[] cooks2 = request.getCookies();

   String id = request.getParameter("id"); 
   String cpg = request.getParameter("cpg");
   if(cpg == null) cpg = "1";

   SimpleDateFormat sdf = new SimpleDateFormat("yyyy년 MM월 dd일 hh시 mm분 ss초");
  
   DbWorks db = new DbWorks();
   db.setId(id);
   BDto rs = db.getSelectOne();
   
   Boolean addCook = true;
   
   if((cooks2 != null) && (cooks2.length>0)){
	  for(Cookie cook:cooks2){
		 if(cook.getName().equals("cid") && cook.getValue().equals(id)){
			 addCook = false;
		 }
	  }
   }
   if(addCook){ 
      int addHit = rs.getHit() + 1;
      db.getUpdate(addHit);
      //쿠키생성
      Cookie cookie = new Cookie("cid", id);
      cookie.setMaxAge(600);
      response.addCookie(cookie);
   }   
   
   String wdate = sdf.format(rs.getWdate());
%>
    <section>
       <!-- listbox -->
       <div class="listbox">
          <h3 class="mt-5"><i class="ri-arrow-right-double-line"></i> <%=rs.getTitle() %></h3> 
          <div class="mt-2 mb-5 pt-2 border-top text-right">
             <span class="mr-4"><label class="font-italic">hit:</label> <%=rs.getHit() %></span>
             <span class="mr-4 font-weight-bold"><%=rs.getWriter() %></span>
             <span class="mr-2"><%=wdate%> </span>
          </div>
          <!-- 
          <div class="mt-2 pt-2 border-top file-box">
             <span>
                    <label class="font-italic">file :</label>
                    <a href="#">asdf.gif</a>  <a href="#">afdfd.asdf</a>
             </span>
          </div>
          -->
          <div class="content-box mt-3">
             <%=rs.getContent() %>
          </div>
          
          <div class="my-5 pt-5 text-right">
             <a href="./?cpg=<%=cpg %>" class="btn btn-primary mr-3">목록</a>
             <a href="rewrite.jsp?id=<%=id %>&refid=<%=rs.getRefid() %>&depth=<%=rs.getDepth() %>&renum=<%=rs.getRenum() %>&cpg=<%=cpg %>" class="btn btn-primary">답글쓰기</a>
             <a href="pass.jsp?id=<%=id %>&mode=edit" class="btn btn-primary">수정</a>
             <a href="pass.jsp?id=<%=id %>&mode=del" class="btn btn-danger">삭제</a>                      
          </div>
          
       </div>
    </section>        

<%@ include file="inc/footer.jsp" %>  