package model;

import org.jetbrains.annotations.NotNull;

import javax.servlet.ServletContext;
import java.sql.*;

public class DBUtil {

    // 로그인
    @NotNull
    public static Member findUser(ServletContext sc, String us_id) {
        Member member = new Member();

        Connection conn = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        try {
            System.out.print("DBUtil.findUser()에서 호출한 ");
            conn = DBConnection.getCon();

            psmt = conn.prepareStatement("SELECT * FROM user WHERE us_id = ?");
            psmt.setString(1, us_id);
            rs = psmt.executeQuery();
            if (rs.next()) { // existing user
                //마이페이지 정보들 담아 놓기 위한 맴버 세팅
                System.out.println("존재하는 사용자임");
                member.setName(rs.getString("us_name"));
                member.setPasswd(rs.getString("us_pw"));
                member.setEmail(rs.getString("us_email"));
                member.setTel(rs.getString("us_tel"));
                member.setLevel(rs.getString("us_level"));
                member.setUs_black_count(rs.getDouble("us_black_count"));
            } else { // invalid user
                System.out.println("존재하는 사용자가 아님");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("SQL문 실행 중 문제가 있다");
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("뭔가 문제가 있다: " + e.toString());
        } finally {
            try {
                if (psmt != null)
                    psmt.close();
                if (rs != null)
                    rs.close();
                if (conn != null)
                    conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
                System.out.println("뭔가 문제가 있다: " + e.toString());
            }
        }
        return member;
    }

    // 관리자인지 확인
    public static boolean assureAdmin(String us_id) {
        boolean result = false;

        Connection conn = null;
        PreparedStatement psm = null;
        ResultSet rs = null;

        try {
            System.out.print("DBUtil.assureAdmin()에서 호출한 ");
            conn = DBConnection.getCon();

            psm = conn.prepareStatement("SELECT * FROM user WHERE us_id = ? AND us_level = '4'");
            psm.setString(1, us_id);
            rs = psm.executeQuery();

            if (rs.next()) { // existing user
                System.out.println("DBUtil.assureAdmin() : 관리자 사용자로 확인함");
                result = true;
            } else {
                System.out.println("DBUtil.assureAdmin() : 관리자 사용자인지 확인했으나 없음");
            }

            rs.close();
            psm.close();
            conn.close();

            return result;

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("뭔가 문제가 있다: " + e.toString());

            return result;
        }
    }

    // 학생사용자인지 확인
    public static boolean assureStudent(String us_id) {
        boolean result = false;

        Connection conn = null;
        PreparedStatement psm = null;
        ResultSet rs = null;

        try {
            System.out.print("DBUtil.assureStudent()가 호출한 ");
            conn = DBConnection.getCon();
            psm = conn.prepareStatement("SELECT * FROM user WHERE us_id = ? AND (us_level = '1' OR us_level = '6')");
            psm.setString(1, us_id);
            rs = psm.executeQuery();

            if (rs.next()) { // existing user
                System.out.println("DBUtil.assureStudent() : 학생 사용자로 확인함");
                result = true;
            } else {
                System.out.println("DBUtil.assureAdmin() : 관리자 사용자인지 확인했으나 없음");
            }

            rs.close();
            psm.close();
            conn.close();

            return result;

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("뭔가 문제가 있다: " + e.toString());
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("뭔가 문제가 있다: " + e.toString());
            return result;
        }
    }

    // 회원가입
    public static boolean joinUser(ServletContext sc, String us_id, String us_name, String us_pw,
                                   String us_email, String us_tel, String us_filename, String us_level, String us_date) { // 속성 10개 중 7개 이용 + sc
        Connection conn;
        PreparedStatement psm;
        try {
            System.out.print("DBUtil.joinUser()가 호출한 ");
            conn = DBConnection.getCon();
            String sql = "INSERT INTO user VALUES (?, ?, ?, ?, ?, ?, ?, ?, 0)"; // 9개 속성 중 8개 속성이 ?
            psm = conn.prepareStatement(sql);
            psm.setString(1, us_id);
            psm.setString(2, us_name);
            psm.setString(3, us_pw);
            psm.setString(4, us_email);
            psm.setString(5, us_tel);
            psm.setString(6, us_filename);
            psm.setString(7, us_level);
            psm.setString(8, us_date);
            psm.executeUpdate();
            psm.close();
            conn.close();
            System.out.println("DBUtil.joinUser.jsp : 회원가입 완료");
            return true;
        } catch (SQLException e) {
            System.out.println("joinUser() 실행 중 오류");
            e.printStackTrace();
            return false;
        }

    }

    // 회원 탈퇴
    public static int memberOut(String us_id, String path, String fileName) {
        Connection con = null;

        PreparedStatement psmSearch = null;
        ResultSet rsSearch = null;

        PreparedStatement psmSet = null;

        try {
            System.out.print("DBUtil.memeberOut()이 호출한 ");
            con = DBConnection.getCon();

            // 1. 현재 예약/대여/노쇼미완처리 된 내역이 있거나, 페널티가 있으면 탈퇴 불가능
            if (DBUtil.checkUsB4Updating(us_id)) {
                return 2;

            } else {

                // 2. 탈퇴된 아이디를 어떻게 데이터베이스에 저장할 것인지 결정
                String sqlSearch = "SELECT * FROM user WHERE us_id = ?";
                String keep_us_id = us_id + "/";
                while (true) {
                    psmSearch = con.prepareStatement(sqlSearch);
                    psmSearch.setString(1, keep_us_id);
                    rsSearch = psmSearch.executeQuery();
                    if (!rsSearch.next()) break;
                    else {
                        keep_us_id += "/";
                    }
                }

                // 3. 탈퇴 날짜 가져오기
                String memberOutDate = DailyUpdate.getTodayDate();

                // 4. us_filename에 해당하는 파일을 서버에서 삭제
                FileManage.fileDelete(path, fileName);

                // 5. user 테이블 갱신: us_id와 us_level의 갱신. 다른 컬럼들은 삭제. (참고: 페널티 있으면 탈퇴 못하게 되어있음)
                String sqlSet = "UPDATE user SET us_id = ?, us_name = '', us_pw = '', us_email = '', us_tel = '', us_filename ='', us_level = '5', us_date = ?  WHERE us_id = ? ";
                psmSet = con.prepareStatement(sqlSet);
                psmSet.setString(1, keep_us_id); // us_id 변경
                psmSet.setString(2, memberOutDate); // us_date 갱신
                psmSet.setString(3, us_id); // user테이블 질의 조건
                psmSet.executeUpdate();
                return 3;
            }
        } catch (SQLException e) {
            System.out.println("DBUtil.memberOut() 예외 발생");
            e.printStackTrace();
            return 1;
        } finally {
            try {
                if (psmSet != null)
                    psmSet.close();
                if (rsSearch != null)
                    rsSearch.close();
                if (psmSearch != null)
                    psmSearch.close();
                if (con != null)
                    con.close();
            } catch (SQLException e1) {
                System.out.println("DBUtil.memberOut() 예외 발생");
                e1.printStackTrace();
            }
        }
    }

    // 가입 승인 or 거절
    public static boolean levelChangeMember(ServletContext sc, String us_id, String us_level) {
        String sqlSt = "UPDATE user SET us_level = ? WHERE us_id = ?";
        try {
            Connection conn = DBConnection.getCon();
            PreparedStatement psmt = conn.prepareStatement(sqlSt);
            psmt.setString(2, us_id);
            psmt.setString(1, us_level);
            psmt.executeUpdate();
            psmt.close();
            conn.close();
            System.out.print("us_id : " + us_id);
            System.out.println("의 회원 레벨 변경: " + us_level);
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 물품 예약하기
    public static boolean reserveIn(ServletContext sc, String us_id, String ca_name, String hi_book_time) {
        System.out.println("DBUtil.reserveIn()의 실행");

        boolean success = false;

        int hi_id = 0;
        int it_serial = 0;
        int hi_isFriday = -1;

        String sqlGetRow = "SELECT COUNT(*) AS rowCount FROM history"; // hi_id 위해서
        PreparedStatement psmGetRow = null;
        ResultSet rsGetRow = null;

        String sqlGetItSerial = "SELECT * FROM item WHERE ca_name = ? AND it_status = '0' ORDER BY it_serial ASC"; // it_srial 위해서
        PreparedStatement psmGetItSerial = null;
        ResultSet rsGetItSerial = null;

        String sqlUpdate = "INSERT INTO history VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"; // 9개 속성
        PreparedStatement psmUpdate = null;

        String sqlUpdate2 = "UPDATE item SET it_status = '1' WHERE ca_name = ? AND it_serial = ?";
        PreparedStatement psmUpdate2 = null;

        try {
            System.out.print("DBUtil.reserveIn()이 호출한 ");
            Connection conn = DBConnection.getCon();

            // 1. 첫번째 인자 hi_id 확정하기
            psmGetRow = conn.prepareStatement(sqlGetRow);
            rsGetRow = psmGetRow.executeQuery();
            if (rsGetRow.next()) {
                hi_id = rsGetRow.getInt("rowCount") + 1; //
            } else {
                hi_id = 1;
            }

            System.out.println("DBUtil.reserveIn() : hi_id = " + hi_id);

            // 2. 두번째 인자 us_id
            // 3. 세번째 인자 ca_name

            // 4. 네번째 인자 it_serial
            psmGetItSerial = conn.prepareStatement(sqlGetItSerial);
            psmGetItSerial.setString(1, ca_name);
            rsGetItSerial = psmGetItSerial.executeQuery();
            if (rsGetItSerial.next()) {
                it_serial = rsGetItSerial.getInt("it_serial");

                // 5. 다섯번째 인자 hi_book_time
                // 6. 여섯번째 인자 hi_delay = 0
                // 7. 일곱번째 인자 hi_return_time : null
                // 8. 여덟번째 인자 hi_status = 0

                // 9. 아홉번째 인자 hi_isFriday
                if (DailyUpdate.getIsFriday()) {
                    hi_isFriday = -3;
                }

                // history 테이블에 예약건 추가
                psmUpdate = conn.prepareStatement(sqlUpdate);
                psmUpdate.setInt(1, hi_id);
                psmUpdate.setString(2, us_id);
                psmUpdate.setString(3, ca_name);
                psmUpdate.setInt(4, it_serial);
                psmUpdate.setString(5, hi_book_time);
                psmUpdate.setInt(6, 0); // hi_delay
                psmUpdate.setString(7, ""); // hi_return_time
                psmUpdate.setString(8, "0"); // hi_status
                psmUpdate.setInt(9, hi_isFriday);
                psmUpdate.executeUpdate();

                // 마지막으로 item 테이블의 it_status 상태도 갱신
                psmUpdate2 = conn.prepareStatement(sqlUpdate2);
                psmUpdate2.setString(1, ca_name);
                psmUpdate2.setInt(2, it_serial);
                psmUpdate2.executeUpdate();

                success = true;

            } else {
                // 예약 가능한 물품이 없으므로 예약 불가능
            }
            return success;

        } catch (SQLException e) {
            System.out.println("DBUtil.ReserveIn() 예외 발생");
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (psmGetItSerial != null)
                    psmGetItSerial.close();
                if (rsGetRow != null)
                    rsGetRow.close();
                if (psmGetItSerial != null)
                    psmGetItSerial.close();
                if (rsGetItSerial != null)
                    rsGetItSerial.close();
                if (psmUpdate != null)
                    psmUpdate.close();
                if (psmUpdate2 != null)
                    psmUpdate2.close();
            } catch (SQLException e) {
                System.out.println("DBUtil.ReserveIn() 예외 발생");
                e.printStackTrace();
            }
        }
    }

    // 연체자인지 확인
    public static boolean checkIfGreyOrBlack(String us_id) {
        System.out.println("DBUtil.checkIfGreyORBlack()의 실행");

        boolean result = false;

        String sqlCheckIfHasDelays = "SELECT * FROM history WHERE us_id = ? AND hi_status = '1' AND hi_delay + hi_isFriday > 0";
        PreparedStatement psmCheckIfHasDelays = null;
        ResultSet rsCheckIfHasDelays = null;

        try {
            System.out.print("DBUtil.checkIfGreyORBlack()이 호출한 ");
            Connection conn = DBConnection.getCon();

            // 0. 해당 user가 연체 중인 예약 내역이 있는지 체크
            psmCheckIfHasDelays = conn.prepareStatement(sqlCheckIfHasDelays);
            psmCheckIfHasDelays.setString(1, us_id);
            rsCheckIfHasDelays = psmCheckIfHasDelays.executeQuery();

            if (rsCheckIfHasDelays.next()) {
                System.out.println("이 사용자는 연체자라서 예약 불가능! ");
                result = true;
            }

        } catch (SQLException e) {
            System.out.println("DBUtil.ReserveIn() 예외 발생");
            e.printStackTrace();
        } finally {
            try {
                if (psmCheckIfHasDelays != null)
                    psmCheckIfHasDelays.close();
                if (rsCheckIfHasDelays != null)
                    rsCheckIfHasDelays.close();
            } catch (SQLException e) {
                System.out.println("DBUtil.ReserveIn() 예외 발생");
                e.printStackTrace();
            }
            return result;
        }
    }

    // 현재 예약/대여중인 항목이 있는지 확인
    public static boolean checkIfRenting(String us_id) {
        System.out.println("DBUtil.checkIfRenting()의 실행");

        boolean result = false;

        String sqlCheckIfRenting = "SELECT * FROM history WHERE us_id = ? AND (hi_status = '0' OR hi_status = '1')";
        PreparedStatement psmCheckIfRenting = null;
        ResultSet rsCheckIfRenting = null;

        try {
            System.out.print("DBUtil.CheckIfRenting()이 호출한 ");
            Connection conn = DBConnection.getCon();

            psmCheckIfRenting = conn.prepareStatement(sqlCheckIfRenting);
            psmCheckIfRenting.setString(1, us_id);
            rsCheckIfRenting = psmCheckIfRenting.executeQuery();

            if (rsCheckIfRenting.next()) {
                System.out.println("이 사용자는 현재 예약/대여 중인 것이 있어서 전화번호수정 불가능! ");
                result = true;
            }

        } catch (SQLException e) {
            System.out.println("DBUtil.checkIfRenting() 예외 발생");
            e.printStackTrace();
        } finally {
            try {
                if (psmCheckIfRenting != null)
                    psmCheckIfRenting.close();
                if (rsCheckIfRenting != null)
                    rsCheckIfRenting.close();
            } catch (SQLException e) {
                System.out.println("DBUtil.checkIfRenting() 예외 발생");
                e.printStackTrace();
            }
            return result;
        }
    }

    // 카테고리 추가
    public static boolean addingCategory(ServletContext sc, String ca_name, String ca_filename, String ca_deposit) {
        Connection conn;
        PreparedStatement psm;

        try {
            conn = DBConnection.getCon();
            String sql = "INSERT INTO category VALUES (?, ?, ?)";
            psm = conn.prepareStatement(sql);
            psm.setString(1, ca_name);
            psm.setString(2, ca_filename);
            psm.setString(3, ca_deposit);
            psm.executeUpdate();
            psm.close();
            conn.close();
            System.out.println("DBUtil.addingCategory.jsp : 카테고리 추가 완료");
            return true;
        } catch (SQLException e) {
            System.out.println("addingCategory() 실행 중 오류");
            e.printStackTrace();
            return false;
        }
    }

    // 보증금 변경하기 전에, 현재 예약중/대여중/노쇼처리미완인 내역이 있는지 확인 by ca_name, hi_status
    public static boolean checkCaB4Updating(String ca_name) { // 결과가 true면, 보증금 변경하면 안 됨!
        boolean result = false;

        Connection con = null;
        PreparedStatement psmCheck = null;
        ResultSet rsCheck = null;

        try {
            con = DBConnection.getCon();

            String sqlCheck = "SELECT * FROM history WHERE ca_name = ? AND (hi_status = '0' OR hi_status = '1' OR hi_status = '4')";
            psmCheck = con.prepareStatement(sqlCheck);
            psmCheck.setString(1, ca_name);
            rsCheck = psmCheck.executeQuery();
            if (rsCheck.next()) {
                result = true;
                // 보증금 변경하면 안 됨 (result = false)
            } else {
            }
            return result;
        } catch (SQLException e1) {
            System.out.println("DBUtil.checkCaB4Updating() 예외 발생 : " + e1.toString());
            e1.printStackTrace();
            return true;
        } finally {
            try {
                if (rsCheck != null)
                    rsCheck.close();
                if (psmCheck != null)
                    psmCheck.close();
                if (con != null)
                    con.close();
            } catch (SQLException e2) {
                System.out.println("DBUtil.checkCaB4Updating() 예외 발생 : " + e2.toString());
                e2.printStackTrace();
            }
        }
    }

    // 회원탈퇴하기 전에, 현재 예약중/대여중/노쇼처리미완인 내역이 있는지, 페널티가 있는지 확인 by us_id, hi_status
    public static boolean checkUsB4Updating(String us_id) { // 결과가 true면, 회원탈퇴하면 안 됨
        boolean result = false;

        Connection con = null;

        PreparedStatement psmCheck = null;
        ResultSet rsCheck = null;

        PreparedStatement psmCheck2 = null;
        ResultSet rsCheck2 = null;

        try {
            System.out.print("DBUtil.checkUsB4Updating()이 호출한 ");
            con = DBConnection.getCon();

            // 현재 예약중/대여중/노쇼처리미완인 내역이 있는지
            String sqlCheck = "SELECT * FROM history WHERE us_id = ? AND (hi_status = '0' OR hi_status = '1' OR hi_status = '4')";
            psmCheck = con.prepareStatement(sqlCheck);
            psmCheck.setString(1, us_id);
            rsCheck = psmCheck.executeQuery();
            if (rsCheck.next()) {
                result = true;
                // 회원탈퇴하면 안 됨
            } else {

                // 페널티가 있는지 확인 by us_id, hi_status
                String sqlCheck2 = "SELECT us_black_count FROM user WHERE us_id = ?";
                psmCheck2 = con.prepareStatement(sqlCheck2);
                psmCheck2.setString(1, us_id);
                rsCheck2 = psmCheck2.executeQuery();
                if (rsCheck2.next()) {
                    double penalty = rsCheck2.getDouble("us_black_count");
                    if (penalty > 0.0) {
                        result = true;
                        // 회원 탈퇴하면 안 됨
                    }
                }
            }

            return result;
        } catch (SQLException e1) {
            System.out.println("DBUtil.checkUsB4Updating() 예외 발생 : " + e1.toString());
            e1.printStackTrace();
            return true;
        } finally {
            try {
                if (rsCheck2 != null)
                    rsCheck2.close();
                if (psmCheck2 != null)
                    psmCheck2.close();
                if (rsCheck != null)
                    rsCheck.close();
                if (psmCheck != null)
                    psmCheck.close();
                if (con != null)
                    con.close();
            } catch (SQLException e2) {
                System.out.println("DBUtil.checkUsB4Updating() 예외 발생 : " + e2.toString());
                e2.printStackTrace();
            }
        }
    }

    // 회원 사용 중지시키기 전에, 현재 예약중인 내역이 있는지 확인 by ca_name
    public static boolean checkUsB4LevelDown(String us_id) { // 결과가 true면, 회원 사용중지 시키면 안 됨됨 (예약취소 원할 수도 있으니까)
        boolean result = false;

        Connection con = null;
        PreparedStatement psmCheck = null;
        ResultSet rsCheck = null;

        try {
            con = DBConnection.getCon();

            String sqlCheck = "SELECT * FROM history WHERE us_id = ? AND hi_status = '0'";
            psmCheck = con.prepareStatement(sqlCheck);
            psmCheck.setString(1, us_id);
            rsCheck = psmCheck.executeQuery();
            if (rsCheck.next()) {
                result = true;
                // 사용 중지 시키면 안 됨
            } else {
            }
            return result;
        } catch (SQLException e1) {
            System.out.println("DBUtil.checkUsB4LevelDown() 예외 발생 : " + e1.toString());
            e1.printStackTrace();
            return true;
        } finally {
            try {
                if (rsCheck != null)
                    rsCheck.close();
                if (psmCheck != null)
                    psmCheck.close();
                if (con != null)
                    con.close();
            } catch (SQLException e2) {
                System.out.println("DBUtil.checkUsB4Updating() 예외 발생 : " + e2.toString());
                e2.printStackTrace();
            }
        }
    }
}