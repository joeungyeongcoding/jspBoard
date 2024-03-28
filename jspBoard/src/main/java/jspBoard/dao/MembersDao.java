package jspBoard.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;

import jspBoard.dto.BDto;
import jspBoard.dto.MDto;

public class MembersDao {

   //필드
	
   PreparedStatement pstmt = null;
   Statement stmt = null;
   ResultSet rs = null;
   Connection conn;
   
   //생성자에서 db 접속
   public MembersDao(Connection conn) {
      this.conn = conn;
   }
   
   //JBoardDao에서 가져온 AllSelectDB메소드
   
   public int AllSelectDB() {
   	String sql = "select count(*) from members";
   	int result = 0;    	
       try {
       	    stmt = conn.createStatement();
       	    rs = stmt.executeQuery(sql);
       	    if(rs.next()) {
       	        result = rs.getInt(1);	
       	    }
       	    
       } catch(SQLException e) {
           e.printStackTrace();
       } finally {
          try {
             if(rs != null) rs.close();
             if(stmt != null) stmt.close();
          }catch(SQLException e) {e.printStackTrace();}   
       }
       return result;
   }
   
   //특정 회원정보의 db 조회
    
   
   //회원정보 db조회 ( memberlist용 )
    public ArrayList<MDto> selectDB(int limitPage, int listCount){
       
       ArrayList<MDto> mtos = new ArrayList<>();
   
       String sql = "select * from members  order by id desc"
             + " limit ?, ?";
       try {
         pstmt = conn.prepareStatement(sql);
         pstmt.setInt(1, limitPage);
         pstmt.setInt(2, listCount);
              
         rs = pstmt.executeQuery();
       
         while(rs.next()) {
           int id = rs.getInt("id");
           String userid = rs.getString("userid");
           String userpass = rs.getString("userpass");
           String username = rs.getString("username");
           String useremail = rs.getString("useremail");
           String usertel = rs.getString("usertel");
           int zipcode = rs.getInt("zipcode");
           String addr1 = rs.getString("addr1");
           String addr2 = rs.getString("addr2");
           String userlink = rs.getString("userlink");
           String role = rs.getString("role");
           Timestamp wdate = rs.getTimestamp("wdate");
           
           MDto mDto = new MDto();
           mDto.setId(id);
           mDto.setUserid(userid);
           mDto.setUserpass(userpass);
           mDto.setUsername(username);
           mDto.setUseremail(useremail);
           mDto.setUsertel(usertel);
           mDto.setZipcode(zipcode);
           mDto.setAddr1(addr1);
           mDto.setAddr2(addr2);
           mDto.setUserlink(userlink);
           mDto.setRole(role);
           mDto.setWdate(wdate);
           mtos.add(mDto);
         }
       } catch(SQLException e) {
          e.printStackTrace();
       } finally {
          try {
             if(rs != null) rs.close();
             if(pstmt != null) pstmt.close();
          }catch(SQLException e) {e.printStackTrace();}   
       }
       
       return mtos;
    }
       	

   //회원가입
	public int insertDB(MDto dto) {
		int num = 0;
		String sql = "insert into members "
				+ " (userid, userpass, username, useremail, usertel, zipcode, addr1, addr2, userlink) "
				+ " values (?, ?, ?, ?, ?, ?, ?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getUserid());
			pstmt.setString(2, dto.getUserpass());
			pstmt.setString(3, dto.getUsername());
			pstmt.setString(4, dto.getUseremail());
			pstmt.setString(5, dto.getUsertel());
			pstmt.setInt(6, dto.getZipcode());
			pstmt.setString(7, dto.getAddr1());
			pstmt.setString(8, dto.getAddr2());
			pstmt.setString(9, dto.getUserlink());
			System.out.println(pstmt);
			num = pstmt.executeUpdate();
			
		}catch(SQLException e) {
			e.printStackTrace();
		}finally {
			  try {
					if(pstmt != null) pstmt.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
		}
		return num;
	}
	
	//회원로그인
	public MDto login(String userid, String userpass) {
		String sql = "select * from members where userid=? and userpass=?";
		MDto dto = new MDto();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			pstmt.setString(2, userpass);
			rs = pstmt.executeQuery();
			if(rs.next()) {
			  dto.setId(rs.getInt("id"));
			  dto.setUserid(rs.getString("userid"));
			  dto.setUseremail(rs.getString("useremail"));
			  dto.setUsername(rs.getString("username"));
			  dto.setRole(rs.getString("role"));
			}
		}catch(SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				if(pstmt != null) pstmt.close();
				if(rs != null) rs.close();
			}catch(SQLException e) {
				e.printStackTrace();
			}
		}
		System.out.println(dto.getId());
		return dto;
	}
	
	
   //회원중복 검증
	public boolean findUser(String column, String uname) {
		boolean res = true;
		String sql = "select * from members where "+ column + "= ?";
		try {
		   pstmt = conn.prepareStatement(sql);
		   pstmt.setString(1, uname);	
		  // System.out.println(pstmt);
		   rs = pstmt.executeQuery();
		   if(rs.next()) {
			   res = false;
		   }
		}catch(SQLException e) {
		      e.printStackTrace();
	    }finally {
		  try {
			if(pstmt != null) pstmt.close();
		  } catch (SQLException e) {
			  e.printStackTrace();
		  }
		}
		//System.out.println(res);
		return res;
	}
	
}