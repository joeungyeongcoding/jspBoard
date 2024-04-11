<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="true" %>
<%@ page  import="java.sql.Connection, 
                  java.util.ArrayList, 
                  
                  jspBoard.dao.MembersDao,jspBoard.dto.MDto,
                  
                  java.sql.Timestamp,
                  java.text.SimpleDateFormat,
                  java.text.NumberFormat" %>    
<jsp:include page="inc/header.jsp" flush="true" />
<%@ include file="inc/aside.jsp" %>
<jsp:useBean id="db" class="jspBoard.dao.DBConnect" scope="page"/>
<%
    String sname = request.getParameter("searchname");  //검색
    String svalue = request.getParameter("searchvalue");
  
    /* 페이징을 위한 변수 */
    int pg; //받아올 현재 페이지 번호
    int allCount; //1. 전체 개시글 수 
    int listCount; //2. 한 페이지에 보일 목록 수
    int pageCount; //3. 한 페이지에 보일 페이지 수
    int allPage;  //4. 전체 페이지 수
    int limitPage; //4. 쿼리문으로 보낼 시작번호
    int startPage;  //5. 시작페이지
    int endPage;   //6. 마지막 페이지
    
    String cpg = request.getParameter("cpg");
    pg = (cpg == null)?1:Integer.parseInt(cpg);  //3항 연산
    listCount = 10;
    pageCount = 10;
    
    limitPage = (pg-1)*listCount;  //(현재페이지-1)x목록수 
    Connection conn = db.getConnection();
    MembersDao dao = new MembersDao(conn);
    ArrayList<MDto> list = null;
    allCount = dao.AllSelectDB();
    allPage = (int) Math.ceil(allCount/(double) listCount);
 
    //시작페이지
    startPage = ((pg-1)/pageCount) * pageCount+1;
    
    //마지막페이지
    endPage = startPage + pageCount -1;
    if(endPage > allPage) endPage = allPage;
    
      
    list = dao.selectDB(limitPage, listCount);
    
       
    db.closeConnection();

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
    NumberFormat formatter = NumberFormat.getInstance();
 %>
    <section>
            <!-- listbox -->
            <div class="listbox">
                <h1 class="text-center mb-5">멤버 리스트</h1>
                <div class="d-flex justify-content-between py-4">
                    <div>
                        <label>총 게시글</label> :<%=formatter.format(allCount) %>개 / <%=formatter.format(allPage) %>page
                    </div>
                    <div>
                        <a href="index.jsp" class="btn btn-primary">홈</a>                      
                    </div>
                </div>
                <table class="table table-hover">
                    <colgroup>
                       <col width="8%">
                       <col>
                       <col width="15%">
                       <col width="10%">
                       <col width="15%">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>번호</th>
                            <th>회원아이디</th>
                            <th>비밀번호</th>
                            <th>이름</th>
                            <th>가입날짜</th>
                        </tr>
                    </thead>
                    <tbody>
                       <!-- loop --> 
                   <%
                      int num = allCount - limitPage; //게시글 번호
                   
                      for(int i=0; i<list.size(); i++){
                    	  MDto dto = list.get(i);
                    	  int id = dto.getId();
                    	  String userid = dto.getUserid();
                    	  String userpass = dto.getUserpass();
                    	  String username = dto.getUsername();
                    	  String useremail = dto.getUseremail();
                    	  
                    	  Timestamp dates = dto.getWdate();
                    	  String wdate = sdf.format(dates);

                   %>    
                       <tr>
                           <td class="text-center"><%=num %></td>
                           <td><%=userid %></td>
                           <td class="text-center"><%=userpass %></td>
                           <td class="text-center"><%=username %></td>
                           <td class="text-center"><%=wdate %></td>
                       </tr>
                  <% 
                        num--;
                      } 
                  %>     
                       <!-- /loop -->
                    </tbody>
                </table>
                <div class="d-flex justify-content-between py-4">
                    <div>
                    </div>
                    <ul class="paging">
                        <li>
                            <a href="?cpg=1"><i class="ri-arrow-left-double-line"></i></a>
                        </li>
                        <li>
                        <%
                           if(startPage - 1 == 0){
                        %>
                            <a href="?cpg=<%=startPage%>"><i class="ri-arrow-left-s-line"></i></a>
                        <% }else{ %>
                            <a href="?cpg=<%=startPage-1%>"><i class="ri-arrow-left-s-line"></i></a>
                        <% } %>
                        </li>
                        <%
                        //시작페이지 6
                        for(int i = startPage; i <= endPage; i++){
                           if(pg == i) {
                        	   out.println("<li><a href=\"?cpg="+i+"\" class=\"active\">"+i+"</a></li>");
                           }else{
                        	   out.println("<li><a href=\"?cpg="+i+"\">"+i+"</a></li>");
                           }
                        }
                        //끝페이지 10
                        %>
                        
                        <li>
                          <%
                           if(endPage + 1 > allPage){
                          %>
                            <a href="?cpg=<%=endPage%>"><i class="ri-arrow-right-s-line"></i></a>
                         <%
                           }else{ 
                         %>   
                            <a href="?cpg=<%=endPage+1%>"><i class="ri-arrow-right-s-line"></i></a>
                         <%
                           }
                         %>
                        </li>
                        <li>
                            <a href="?cpg=<%=allPage%>"><i class="ri-arrow-right-double-line"></i></a>
                        </li>
                    </ul>
                    <div>
                        <a href="index.jsp" class="btn btn-primary">홈</a>
                    </div>
               </div>
              
            </div>
            <!-- /listbox-->
         </section>
    <%@ include file="inc/footer.jsp" %>     