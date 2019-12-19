package model;

public class Item {
    private String ca_name;
    private String it_serial;
    private Integer it_status;

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

    public Integer getIt_status() {
        return it_status;
    }
    public void setIt_status(Integer it_status) {
        this.it_status = it_status;
    }
}