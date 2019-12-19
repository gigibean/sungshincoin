package model;

import org.jetbrains.annotations.NotNull;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class DailyUpdate {

    // 오늘 날짜 구하기 yyyy-MM-dd
    @NotNull
    public static String getTodayDate() {
        System.out.println("DailyUpdate.getTodayDate() 실행");

        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        Calendar time = Calendar.getInstance();
        String format_time = format.format(time.getTime());

        System.out.println("ㄴ 결과 : " + format_time);
        return format_time;
    }

    // 마지막으로 history 테이블의 hi_delay를 업데이트한 날짜를 확인하기 (yyyy-MM-dd)
    public static String getLastUpdatedDate(String path) {
        System.out.println("DailyUpdate.getLastUpdatedDate() 실행");

        try {
            System.out.println("DailyUpdate.getLastUpdatedDate()에서 열어보는 파일경로: ");
            System.out.println(path);

            BufferedReader bufReader = new BufferedReader(new FileReader(path));
            String line = bufReader.readLine(); // .readLine()은 끝에 개행문자를 읽지 않는다.
            bufReader.close();
            System.out.println("파일에서 읽어본 내용 한 줄 : " + line);
            return line;
        } catch (FileNotFoundException e) {
            System.out.println("DailyUpdate.getLastUpdatedDate(): 파일을 찾지 못한 예외 발생");
            System.out.println(e);
            return "";
        } catch (IOException e) {
            System.out.println("DailyUpdate.getLastUpdatedDate(): 입출력 예외 발생");
            System.out.println(e);
            return "";
        }
    }

    // hi_delay 갱신을 위한 함수
    public static int getDayCount(@NotNull String hi_book_time) { // 예약날짜~오늘날짜까지 경과한 날 수
        Date today = Calendar.getInstance().getTime();

        SimpleDateFormat yearFormat = new SimpleDateFormat("yyyy");
        SimpleDateFormat monthFormat = new SimpleDateFormat("MM");
        SimpleDateFormat dayFormat = new SimpleDateFormat("dd");

        int year = Integer.parseInt(yearFormat.format(today));
        int month = Integer.parseInt(monthFormat.format(today));
        int date = Integer.parseInt(dayFormat.format(today));

        // 예약날짜를 저장할 변수
        int reserveYear = 0;
        int reserveMonth = 0;
        int reserveDay = 0;

        // 계산된 일수를 저장할 변수
        int dayCount = 0;

        // 년 입력받기
        reserveYear = Integer.parseInt(hi_book_time.substring(0, 4)); // 0, 1, 2, 3
        System.out.print("예약날짜 : " + Integer.toString(reserveYear));

        // 월 입력받기
        reserveMonth = Integer.parseInt(hi_book_time.substring(5, 7)); // 5, 6
        System.out.print("-" + Integer.toString(reserveMonth));

        // 일 입력받기
        reserveDay = Integer.parseInt(hi_book_time.substring(8, 10)); // 8, 9
        System.out.println("-" + Integer.toString(reserveDay));

        // 계산하는 부분
        dayCount = date - reserveDay;
        dayCount = dayCount + ((month * 30) - (reserveMonth * 30));
        dayCount = dayCount + ((year * 365) - (reserveYear * 365));

        System.out.println("예약날짜~오늘날짜까지 경과한 날 수 = " + dayCount);
        return dayCount;
    }

    // 예약시간, 반납시간 갱신을 위해서 현재시간 구하기 yyyy-MM-dd(E) HH:mm:ss
    @NotNull
    public static String getConcreteTime() {
        System.out.println("DailyUpdate.getTodayTime() 실행");

        Calendar cal = Calendar.getInstance();

        SimpleDateFormat formatDateTime = new SimpleDateFormat("yyyy-MM-dd(E) HH:MM:dd");
        String format_dateTime = formatDateTime.format(cal.getTime());

        return format_dateTime;
    }

    // 오늘 요일 구하기
    public static boolean getIsFriday() {
        System.out.println("DailyUpdate.getIsFriday() 실행");

        Calendar cal = Calendar.getInstance();

        SimpleDateFormat formatDateTime = new SimpleDateFormat("E");
        String format_dateTime = formatDateTime.format(cal.getTime());

        if (format_dateTime.equals("금"))
            return true;
        else
            return false;
    }
}
