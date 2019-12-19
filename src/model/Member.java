package model;

public class Member { // 속성 10개
    private String us_id;
    private String us_name;
    private String us_pw;
    private String us_email;
    private String us_tel;
    private String us_filename;
    private String us_level;
    private String us_date;
    private Double us_black_count;

    public String getUs_filename() {
        return us_filename;
    }

    public void setUs_filename(String us_filename) {
        this.us_filename = us_filename;
    }

    public Member() {
        this.us_level = "5"; // 로그인 실패임을 알려주기 위함
    }

    public String getId() {
        return us_id;
    }
    public void setId(String us_id) {
        this.us_id = us_id;
    }

    public String getName() {
        return us_name;
    }

    public Double getUs_black_count() {
        return us_black_count;
    }

    public void setUs_black_count(Double us_black_count) {
        this.us_black_count = us_black_count;
    }

    public void setName(String us_name) {
        this.us_name = us_name;
    }

    public String getPasswd() {
        return us_pw;
    }
    public void setPasswd(String us_pw) {
        this.us_pw = us_pw;
    }

    public String getEmail() {
        return us_email;
    }
    public void setEmail(String us_email) {
        this.us_email = us_email;
    }

    public String getTel() {
        return us_tel;
    }
    public void setTel(String us_tel) {
        this.us_tel = us_tel;
    }

    public String getLevel() {
        return us_level;
    }
    public void setLevel(String us_level) {
        this.us_level = us_level;
    }
}