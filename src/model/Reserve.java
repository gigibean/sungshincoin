package model;


public class Reserve {

    private Integer hi_id;
    private String us_id;
    private String ca_name;
    private String it_serial;
    private String hi_book_time;
    private Integer hi_delay;
    private String hi_return_time;
    private String hi_status;
    private Integer hi_isFriday;

    public Integer getHi_id() {
        return hi_id;
    }

    public void setHi_id(Integer hi_id) {
        this.hi_id = hi_id;
    }

    public String getUs_id() {
        return us_id;
    }

    public void setUs_id(String us_id) {
        this.us_id = us_id;
    }

    public String getCa_name() {
        return ca_name;
    }

    public void setCa_name(String ca_name) {
        this.ca_name = ca_name;
    }

    public String getIt_serial() {
        return it_serial;
    }

    public void setIt_serial(String it_serial) {
        this.it_serial = it_serial;
    }

    public String getHi_book_time() {
        return hi_book_time;
    }

    public void setHi_book_time(String hi_book_time) {
        this.hi_book_time = hi_book_time;
    }

    public Integer getHi_delay() {
        return hi_delay;
    }

    public void setHi_delay(Integer hi_delay) {
        this.hi_delay = hi_delay;
    }

    public String getHi_return_time() {
        return hi_return_time;
    }

    public void setHi_return_time(String hi_return_time) {
        this.hi_return_time = hi_return_time;
    }

    public String getHi_status() {
        return hi_status;
    }

    public Integer getHi_isFriday() {
        return hi_isFriday;
    }

    public void setHi_isFriday(Integer hi_isFriday) {
        this.hi_isFriday = hi_isFriday;
    }

    public void setHi_status(String hi_status) {
        this.hi_status = hi_status;
    }
}